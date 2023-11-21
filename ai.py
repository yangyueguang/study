import numpy as np
import pandas as pd
from enum import Enum
import xgboost as xgb
import pickle
import pika
import xmind
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.base import BaseEstimator, TransformerMixin, RegressorMixin, clone
from sklearn.svm import SVC, SVR, LinearSVC, LinearSVR
from sklearn.pipeline import Pipeline
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor
from sklearn.decomposition import PCA, KernelPCA
from sklearn.compose import ColumnTransformer
from sklearn.linear_model import LinearRegression, LogisticRegression, Perceptron, SGDRegressor, HuberRegressor, SGDClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder, OneHotEncoder
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor, RandomForestClassifier, AdaBoostClassifier, ExtraTreesClassifier, GradientBoostingClassifier, ExtraTreesRegressor, BaggingRegressor, AdaBoostRegressor
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split, learning_curve, StratifiedKFold, cross_val_score, GridSearchCV, KFold
from sklearn.naive_bayes import GaussianNB, MultinomialNB
from sklearn.tree import DecisionTreeClassifier, ExtraTreeRegressor, DecisionTreeRegressor
from sklearn.impute import SimpleImputer

class HTTPServer(object):
    def __init__(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.bind(('0.0.0.0', 8001))

    def start(self):
        self.socket.listen(128)
        while True:
            client_socket, client_address = self.socket.accept()
            dlog(f'{client_address}用户连接上了')
            handle_client_process = Process(target=self.handle_client, args=(client_socket,))
            handle_client_process.start()
            client_socket.close()

    def handle_client(self, client_socket):
        request_data = client_socket.recv(1024)
        print("request data:", request_data)
        client_socket.send(bytes(json.dumps({'code': 'd'}), "utf-8"))
        client_socket.close()

    def client_test(self):
        http_server = HTTPServer()
        http_server.start()
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(("localhost", 8887))
        sock.send(json.dumps({"symbol": "audusd@FXALL"}).encode('utf-8'))
        while True:
            res = sock.recv(1024)
            print(res, '#######33')


class ImageElement(xmind.core.mixin.WorkbookMixinElement):
    TAG_NAME = 'xhtml:img'

    def __init__(self, name, node=None, ownerWorkbook=None):
        super(ImageElement, self).__init__(node, ownerWorkbook)
        self.setAttribute('align', 'left')
        self.setAttribute('svg:height', '30')
        self.setAttribute('svg:width', '30')
        for i in os.listdir('markers'):
            for j in os.listdir(f'markers/{i}'):
                if name in j:
                    self.setAttribute('xhtml:src', f'xap:markers/{i}/{j}')


class Mind(object):
    def __init__(self, name):
        super(Mind, self).__init__()
        self.name = name
        self.content = []
        self.is_zen = False
        self.workbook = xmind.load(name)
        if not os.path.exists(name):
            return
        with zipfile.ZipFile(name) as m:
            if 'content.json' in m.namelist():
                self.is_zen = True
                d = m.open('content.json').read().decode('utf-8')
                self.content = json.loads(d)

    def save(self, name=None):
        if not self.is_zen:
            xmind.save(self.workbook, name or self.name)
        else:
            with zipfile.ZipFile(name or self.name, 'w') as x:
                x.writestr('content.json', json.dumps(self.content, ensure_ascii=False, indent=3))
                manifest = '{"file-entries":{"content.json":{},"metadata.json":{},"":{}}}'
                metadata = '{"creator":{"name":"Vana","version":"10.1.1.202003310622"}}'
                x.writestr('manifest.json', manifest)
                x.writestr('metadata.json', metadata)

    def parse_mm(self, name):
        sheet = self.workbook.getPrimarySheet()
        sheet.setTitle(Path(name).name)
        topic = sheet.getRootTopic()
        topic.setTitle('map')
        topic = topic.addSubTopic()
        topic.addMarker('mark')
        topic.appendChild('icon')
        topic.setTitle('title')
        topic.setURLHyperlink('link')
        self.save()

        with zipfile.ZipFile(self.name, 'a') as f:
            manifest = '''
                <manifest xmlns="urn:xmind:xmap:xmlns:manifest:1.0" password-hint="">
                    %s
                    <file-entry full-path="markers/" media-type=""/>
                    <file-entry full-path="content.xml" media-type="text/xml"/>
                    <file-entry full-path="META-INF/" media-type=""/>
                    <file-entry full-path="META-INF/manifest.xml" media-type="text/xml"/>
                    <file-entry full-path="meta.xml" media-type="text/xml"/>
                    <file-entry full-path="styles.xml" media-type="text/xml"/>
                    <file-entry full-path="markers/markerSheet.xml" media-type="text/xml"/>
                </manifest>
                '''
            marks = '<marker-sheet xmlns="urn:xmind:xmap:xmlns:marker:2.0" version="2.0"> %s </marker-sheet>'
            manis = []
            mars = []
            for i in os.listdir('markers'):
                mars.append(f'<marker-group id="{i}" name="{i}" singleton="true">')
                for j in os.listdir('markers/' + i):
                    icon_name = f'{i}/{j}'
                    f.write(f'markers/{icon_name}')
                    mars.append(f'<marker id="{j.split(".")[0]}" name="{j}" resource="{icon_name}"/>')
                    manis.append(f'<file-entry full-path="markers/{icon_name}" media-type="image/{j.split(".")[-1].replace("jpg", "jpeg")}"/>')
                mars.append(f'</marker-group>')

            manifest = manifest % '\n'.join(manis)
            marks = marks % '\n'.join(mars)
            f.writestr('META-INF/manifest.xml', manifest)
            f.writestr('markers/markerSheet.xml', marks)


class MQConsumer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.queue_declare(queue='api_queue')
        self.channel.basic_qos(prefetch_count=1)
        self.channel.basic_consume('api_queue', on_message_callback=self.callback)

    def start_service(self):
        self.channel.start_consuming()

    def callback(self, channel, method, properties, body):
        dlog('消费：{}'.format(body))
        result = {"task": 'over'}
        channel.basic_publish(
            exchange='',
            routing_key=properties.reply_to,
            body=json.dumps(result).encode(),
            properties=pika.BasicProperties(correlation_id=properties.correlation_id)
        )
        channel.basic_ack(delivery_tag=method.delivery_tag)


class MQProducer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.exchange_declare(exchange='api_ex', exchange_type='fanout')
        self.channel.queue_declare(queue='api_queue')
        self.channel.queue_bind(exchange='api_ex', queue='api_queue')
        self.callbackQueue = self.channel.queue_declare(queue='', exclusive=False)
        self.queueName = self.callbackQueue.method.queue
        self.channel.basic_consume(on_message_callback=self.callback, auto_ack=False, queue=self.queueName)

    def callback(self, channel, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call(self, requestStr):
        dlog('生产：{}'.format(requestStr))
        self.response = None
        import uuid
        self.corr_id = str(uuid.uuid4().hex)
        properties = pika.BasicProperties(reply_to=self.queueName, correlation_id=self.corr_id)
        self.channel.basic_publish(exchange='api_ex', routing_key='api_queue', body=requestStr, properties=properties)
        while self.response is None:
            self.connection.process_data_events()
        return self.response


class Estimat(Enum):
    gs = GaussianNB()
    mn = MultinomialNB()
    kr = KNeighborsRegressor()
    kc = KNeighborsClassifier()
    logisticr = LogisticRegression(random_state=0)
    liner = LinearRegression(),
    lsvc = LinearSVC()
    lsvr = LinearSVR(),
    svr = SVR(),
    svcl = SVC(kernel='linear', random_state=0)
    svcr = SVC(kernel='rbf', random_state=0)
    svcs = SVC(kernel='sigmoid', random_state=0)
    etc = ExtraTreesClassifier()
    etr = ExtraTreeRegressor(),
    etsr = ExtraTreesRegressor()
    dtr = DecisionTreeRegressor(),
    dtc = DecisionTreeClassifier(criterion='entropy', random_state=0)
    rfc = RandomForestClassifier(n_estimators=10, criterion='entropy', random_state=0)
    rfr = RandomForestRegressor(n_estimators=200),
    adbc = AdaBoostClassifier(n_estimators=10, learning_rate=0.01)
    adbr = AdaBoostRegressor(n_estimators=500)
    gbc = GradientBoostingClassifier(n_estimators=100)
    gbr = GradientBoostingRegressor(n_estimators=1000)
    br = BaggingRegressor(),
    sgdc = SGDClassifier()
    sgdr = SGDRegressor(max_iter=1000),
    hr = HuberRegressor(),
    pp = Perceptron(),
    xgbc = xgb.XGBClassifier(n_estimators=2000, max_depth=4, min_child_weight=2, gamma=0.9, subsample=0.8,
                        colsample_bytree=0.8, objective='binary:logistic', nthread=-1, scale_pos_weight=1)
    xgbr = xgb.XGBRegressor()

    def test(self, X, Y):
        x_train, x_test, y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=0)
        for k, model in self.items():
            model.fit(x_train, y_train)
            score = model.score(x_test, y_test)
            result = model.predict(x_test)
            scores = accuracy_score(y_test, result)
            X = StandardScaler().fit_transform(x_train.drop(['Survived'], axis=1))
            y = x_train['Survived'].values
            train_sizes = [50, 100, 150, 200, 250, 350, 400, 450, 500]
            plt.figure()
            plt.xlabel('Training examples')
            plt.ylabel('Score')
            train_sizes, train_scores, test_scores = learning_curve(model, X, y, cv=None, n_jobs=-1,
                                                                    train_sizes=train_sizes)
            train_scores_mean = np.mean(train_scores, axis=1)
            train_scores_std = np.std(train_scores, axis=1)
            test_scores_mean = np.mean(test_scores, axis=1)
            test_scores_std = np.std(test_scores, axis=1)
            cross_log = cross_val_score(model, x_train, y_train, cv=5).mean()
            plt.figure()
            plt.grid()
            plt.fill_between(train_sizes, train_scores_mean - train_scores_std, train_scores_mean + train_scores_std,
                             alpha=0.1, color='r')
            plt.fill_between(train_sizes, test_scores_mean - test_scores_std, test_scores_mean + test_scores_std, alpha=0.1,
                             color='g')
            plt.plot(train_sizes, train_scores_mean, 'o-', color='r', label='Training score')
            plt.plot(train_sizes, test_scores_mean, 'o-', color='g', label='Cross-validation score')
            plt.plot(np.arange(len(result)), y_test, 'go-', label='True value')
            plt.plot(np.arange(len(result)), result, 'ro-', label='Predict value')
            plt.title(f'model: {model} --score: {score}')
            plt.legend(loc='best')
            plt.show()


def classification_template(classifier, dataset, gread_search=False, pca=False):
    X = dataset.iloc[:, [2, 3]].values
    y = dataset.iloc[:, 4].values
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=0)
    sc = StandardScaler()
    X_train = sc.fit_transform(X_train)
    X_test = sc.transform(X_test)
    if pca:
        kpca = KernelPCA(n_components=2, kernel='rbf')
        X_train = kpca.fit_transform(X_train)
        X_test = kpca.transform(X_test)
    classifier.fit(X_train, y_train)
    y_pred = classifier.predict(X_test)
    cm = confusion_matrix(y_test, y_pred)
    if gread_search:
        accuracies = cross_val_score(estimator=classifier, X=X_train, y=y_train, cv=10)
        accuracies.mean()
        accuracies.std()
        parameters = [{'C': [1, 10, 100, 1000], 'kernel': ['linear']},
                      {'C': [1, 10, 100, 1000], 'kernel': ['rbf'], 'gamma': [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]}]
        grid_search = GridSearchCV(estimator=classifier, param_grid=parameters, scoring='accuracy', cv=10, n_jobs=-1)
        grid_search = grid_search.fit(X_train, y_train)
        best_accuracy = grid_search.best_score_
        best_parameters = grid_search.best_params_
    X1, X2 = np.meshgrid(np.arange(start=X_train[:, 0].min() - 1, stop=X_train[:, 0].max() + 1, step=0.01),
                         np.arange(start=X_train[:, 1].min() - 1, stop=X_train[:, 1].max() + 1, step=0.01))
    plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
                 alpha=0.75, cmap=ListedColormap(('red', 'green')))
    plt.xlim(X1.min(), X1.max())
    plt.ylim(X2.min(), X2.max())
    for i, j in enumerate(np.unique(y_train)):
        plt.scatter(X_train[y_train == j, 0], X_train[y_train == j, 1], c=ListedColormap(('orange', 'blue'))(i), label=j)
    plt.title('Classifier (Training set)')
    plt.xlabel('Age')
    plt.ylabel('Estimated Salary')
    plt.legend()
    plt.show()
    X1, X2 = np.meshgrid(np.arange(start=X_test[:, 0].min() - 1, stop=X_test[:, 0].max() + 1, step=0.01),
                         np.arange(start=X_test[:, 1].min() - 1, stop=X_test[:, 1].max() + 1, step=0.01))
    plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
                 alpha=0.75, cmap=ListedColormap(('red', 'green')))
    plt.xlim(X1.min(), X1.max())
    plt.ylim(X2.min(), X2.max())
    for i, j in enumerate(np.unique(y_test)):
        plt.scatter(X_test[y_test == j, 0], X_test[y_test == j, 1], c=ListedColormap(('orange', 'blue'))(i), label=j)
    plt.title('Classifier (Test set)')
    plt.xlabel('Age')
    plt.ylabel('Estimated Salary')
    plt.legend()
    plt.show()


class StackingAveragedModels(BaseEstimator, RegressorMixin, TransformerMixin):
    def __init__(self, base_models, meta_model, n_folds=5):
        self.base_models = base_models
        self.meta_model = meta_model
        self.n_folds = n_folds

    # 拟合模型
    def fit(self, X, y):
        self.base_models_ = [list() for x in self.base_models]
        self.meta_model_ = clone(self.meta_model)
        kfold = KFold(n_splits=self.n_folds, shuffle=True, random_state=156)
        # 训练模型，做出预测
        out_of_fold_predictions = np.zeros((X.shape[0], len(self.base_models)))
        for i, model in enumerate(self.base_models):
            for train_index, holdout_index in kfold.split(X, y):
                instance = clone(model)
                self.base_models_[i].append(instance)
                instance.fit(X[train_index], y[train_index])
                y_pred = instance.predict(X[holdout_index])
                out_of_fold_predictions[holdout_index, i] = y_pred
        self.meta_model_.fit(out_of_fold_predictions, y)
        return self

    # 使用所有基本模型的测试结果作为元数据训练元模型
    def predict(self, X):
        meta_features = np.column_stack(
            [np.column_stack([model.predict(X) for model in base_models]).mean(axis=1) for base_models in
             self.base_models_])
        return self.meta_model_.predict(meta_features)


class XGBModelBuilder(object):
    def __init__(self):
        self.model = None

    def fill_data(self, df: pd.DataFrame, test_size: float = 0.1):
        df = df.fillna(value=np.nan)
        self.X = df.drop('R', axis=1)
        self.Y = df.R
        self.train_x, self.test_x, self.train_y, self.test_y = train_test_split(self.X, self.Y, test_size=test_size, random_state=0)

    def build_proprocessor(self):
        features_number = self.X.select_dtypes(exclude=['object']).columns
        features_str = self.X.select_dtypes(include=['object']).columns
        ohe = OneHotEncoder(handle_unknown='ignore')
        ohe.fit_transform(self.X.select_dtypes(include=['object']).fillna('missing'))
        self.features = list(features_number) + list(ohe.get_feature_names(features_str))
        steps_number = [('imputer', SimpleImputer(strategy='median', verbose=True)), ('scaler', StandardScaler())]
        steps_str = [('imputer', SimpleImputer(strategy='constant', fill_value='missing')), ('onehot', OneHotEncoder(handle_unknown='ignore'))]
        transformers = [('num', Pipeline(steps=steps_number), features_number), ('str', Pipeline(steps=steps_str), features_str)]
        self.preprocessor = ColumnTransformer(transformers=transformers)
        self.preprocessor.fit_transform(self.X)
        self.preprocessor.sparse_output_ = False
        self.columns = pd.DataFrame(self.features).set_index(0).index
        self.X = self._preprocess_data(self.X)
        self.train_x = self._preprocess_data(self.train_x)
        self.test_x = self._preprocess_data(self.test_x)

    def _preprocess_data(self, X):
        return pd.DataFrame(self.preprocessor.transform(X), index=X.index, columns=self.columns)

    def extract_model(self, params):
        kfold = StratifiedKFold(n_splits=10, shuffle=True, random_state=123)
        grid_search = GridSearchCV(estimator=xgb.XGBClassifier(), param_grid=params, cv=kfold, n_jobs=-1, verbose=10)
        grid_search.fit(self.X, self.Y)
        self.model = grid_search.best_estimator_
        self.model.fit(self.train_x, self.train_y, eval_metric='mlogloss')

    def predict(self):
        pred_res = self.model.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        pred_prob = self.model.predict_proba(self.test_x)
        prob = pd.DataFrame(data=pred_prob[0:, 0:], index=self.test_x.index)
        prob.columns = prob.columns.astype('str')
        return pred, prob

    def evaluate(self, acturl, pred):
        df = pd.DataFrame({'actual': np.ravel(acturl), 'pred': pred})
        df = df.eval('notch=actual==pred')
        df = df.eval('abs_notch=abs(actual==pred)')
        df_notch = pd.DataFrame(df.notch.value_counts(normalize=True).mul(100).sort_index(axis=0)).round(2)
        df_notch.notch = ['%.2f%%' % notch for notch in df_notch.notch]
        df_abs_notch = pd.DataFrame(df.abs_notch.value_counts(normalize=True).mul(100).sort_index(axis=0)).round(2)
        df_abs_notch = df_abs_notch.cumsum()
        df_abs_notch.abs_notch = ['%.2f%%' % abs_notch for abs_notch in df_abs_notch.abs_notch]
        return df_notch, df_abs_notch

    def save(self, model_path):
        pickle.dump(self.model, open(model_path, 'wb'))
        pickle.dump(self.preprocessor, open(f'{model_path}.p', 'wb'))

    def load(self, model_path):
        self.model = pickle.load(open(model_path, 'rb'))
        self.preprocessor = pickle.load(open(f'{model_path}.p', 'rb'))

    def w(self):
        sorted_idx = self.model.feature_importances_.argsort()
        w = pd.DataFrame((self.columns[sorted_idx], self.model.feature_importances_[sorted_idx]))
        w = w.T.reset_index(drop=True)
        w.columns = w.columns.astype('str')
        return w

    def params(self):
        return self.model.get_patams()

    def main(self):
        bdt = AdaBoostClassifier(DecisionTreeClassifier(max_depth=3, min_samples_split=20, min_samples_leaf=5), algorithm='SAMME', n_estimators=200, learning_rate=0.8)
        bdt.fit(self.train_x, self.train_y)
        pred_res = bdt.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        return pred

    # 随机森林分类
    def random_forst(self):
        clf = RandomForestClassifier(n_estimators=10)
        clf = clf.fit(self.train_x, self.train_y)
        pred_res = clf.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        return pred

    # 梯度渐进分类
    def gradient(self):
        clf = GradientBoostingClassifier(n_estimators=100, learning_rate=1.0, max_depth = 1, random_state = 0).fit(self.train_x, self.train_y)
        abc = clf.score(self.test_x, self.test_y)
        print(abc)
        pred_res = clf.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        return pred

    # 支持向量机分类
    def svm(self):
        model = SVC(kernel='rbf', C=1)
        model.fit(self.train_x, self.train_y)
        pred_res = model.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        return pred

    # xgb
    def xgb(self, params):
        self.extract_model(params)
        pred_res = self.model.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        return pred


if __name__ == '__main__':
    df = pd.read_csv('filename.csv')
    params = {
        'n_estimators': [100],  # 迭代次数
        'max_depth': [3],  # 决策树深度
        'num_class': [2],  # 分类种类数
        'objective': ['multi:softprob'],  # 目标函数
        'gamma': [0.01],  # 惩罚项系数
        'learning_rate': [0.1],  # 学习率
        'min_child_weight': [1]  # 最小叶子结点权重和
    }
    build = XGBModelBuilder()
    build.fill_data(df, 0.3)
    build.build_proprocessor()
    build.extract_model(params)
    build.save('model')
    build.load('model')
    pred, prob = build.predict()
    notch, abs_notch = build.evaluate(build.test_y, pred['prediction'])
    ada = build.main()
    random_for = build.random_forst()
    gradent = build.gradient()
    svm = build.svm()
    xgb = build.xgb(params)
    results = [ada, random_for, gradent, svm, xgb]
    res = []
    for i in results:
        notch = build.evaluate(build.test_y, i['prediction'])
        res.append(notch)
    print(res)
    print('over')
