import pickle
import numpy as np
import pandas as pd
from xgboost.sklearn import XGBClassifier
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split, StratifiedKFold, GridSearchCV


class XGBModelBuilder(object):
    def __init__(self):
        self.model = None

    def fill_data(self, df: pd.DataFrame, test_size: float = 0.1):
        df = df.fillna(value=np.nan)
        self.X = df.drop('result', axis=1)
        self.Y = df.result
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
        grid_search = GridSearchCV(estimator=XGBClassifier(), param_grid=params, cv=kfold, n_jobs=-1, verbose=10)
        grid_search.fit(self.X, self.Y)
        self.model = grid_search.best_estimator_
        self.model.fit(self.train_x, self.train_y, eval_metric='mlogloss')

    def predict(self):
        pred_res = self.model.predict(self.test_x)
        pred = pd.DataFrame(pred_res, columns=['prediction'], index=self.test_x.index)
        pred_prob = self.model.predict_prob(self.test_x)
        prob = pd.DataFrame(data=pred_prob[0:, 0:], index=self.test_x.index)
        prob.columns = prob.columns.astype('str')
        return pred, prob

    def evaluate(self, acturl, pred):
        df = pd.DataFrame({'actual': np.ravel(acturl), 'pred': pred})
        df = df.eval('notch=actual-pred')
        df = df.eval('abs_notch=abs(actual-pred)')
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


if __name__ == '__main__':
    df = None
    params = {
        'n_estimators': [10, 30, 60, 100, 120],  # 迭代次数
        'max_depth': [3, 4, 5],  # 决策树深度
        'num_class': [17],  # 分类种类数
        'objective': ['multi:softprob'],  # 目标函数
        'gamma': [0.001, 0.01, 0.1, 0.2],  # 惩罚项系数
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

