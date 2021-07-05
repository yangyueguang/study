-- oracle 建表
-- https://www.jianshu.com/p/79b92439fbbd
-- 'docker run -d -P -p 1521:1521 -v /Users/supers/Documents/oracle:/u01/app/oracle/gtja --name oracle_11g  docker.io/arahman/docker-oracle-xe-11g'
-- #   IP: 10.100.16.170
-- #   PORT: 1521
-- #   sid: xe
-- #   service name: xe
-- #   username: system
-- #   password: oracle
create tablespace gtja_space datafile '/u01/app/oracle/gtja/gtja.dbf' size 5000M;
create user gtja identified by gtja_data default tablespace gtja_space;
GRANT connect, resource TO gtja;
grant create session to gtja;
-- 研报抽取记录表
create table DH_REPORT_EXTRACT_RECORD (
ID NUMBER primary key not null, --	主键
REPORTID	VARCHAR2(100),  	--	研报ID
REPORTTYPE	VARCHAR2(100),  	--	研报类型（个股/行业/总量）
STATUS	VARCHAR2(100),	    	--	抽取状态（OK/FAIL）
MESSAGE_ID	VARCHAR2(100),		--	错误信息ID
MESSAGE_TXT	VARCHAR2(100),		--	错误信息内容
CREATE_TIME	TIMESTAMP,	    	--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);



-- 研报基本信息表
create table DH_REPORT_BASIC (
ID VARCHAR2(100) primary key not null,
REPORTID	VARCHAR2(100),		--	研报ID
TITLE	VARCHAR2(100),			--	标题
SUBTITLE	VARCHAR2(100),		--	副标题
PUBLISHTIME	VARCHAR2(100),		--	发布时间
TYPE	VARCHAR2(100),			--	类型（个股/行业/总量等）
CATEGORY1	VARCHAR2(100),		--	分类（对应88）
CATEGORY2	VARCHAR2(100),		--	分类（对应89）
STOCKCODE	VARCHAR2(100),		--	股票代码
STOCKNAME	VARCHAR2(100),		--	股票名称
INDUSTRY1	VARCHAR2(100),		--	一级行业
INDUSTRY2	VARCHAR2(100),		--	二级行业
RATING	VARCHAR2(100),			--	评级
LASTRATING	VARCHAR2(100),		--	上次评级
TARGETPRICE	NUMBER,				--	目标价
LASTTARGETPRICE	NUMBER,			--	上次目标价
CURRENTPRICE	NUMBER,			--	当前价格
UPPERPRICE	NUMBER,				--	价格上限
LOWERPRICE	NUMBER,				--	价格下限
AVERAGEPRICE	NUMBER,			--	平均价
COMPANYWEBSITE VARCHAR2(100),	--	公司网站
COMPANYPROFILE	CLOB,			--	公司简介
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);



-- 研报作者表
create table DH_REPORT_AUTHOR (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
AUTHORID	VARCHAR2(100),		--	作者ID
AUTHORNAME	VARCHAR2(100),		--	作者名称
POSITION	VARCHAR2(100),		--	职位
TEL	VARCHAR2(100),				--	电话
EMAIL	VARCHAR2(100),			--	邮箱
CERTNO	VARCHAR2(100),			--	证书编号
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);

-- 研报摘要表
create table DH_REPORT_ABSTRACT (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
REPORTINTRO	VARCHAR2(1000),		--	研报导读
INVESTMENTPOINT	CLOB,			--	投资要点
CATALYST	VARCHAR2(1000),		--	催化剂
RISKWARNING	VARCHAR2(1000),		--	风险提示
EVENT	VARCHAR2(1000),			--	事件
COMMENTS	VARCHAR2(1000),		--	评论
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);

-- 研报正文表
create table DH_REPORT_CONTENT (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
CATALOGUE	CLOB,				--	正文目录
CONTENT	CLOB,					--	正文
ESTIMATEDVALUE	CLOB,			--	估值
EARNINGSFORECAST	CLOB,		--	盈利预测
RISKWARNING	CLOB,				--	风险提示
CONCLUSION	CLOB,				--	结论
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);

-- 研报正文图表表
create table DH_REPORT_CHART (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
CHARTID	NUMBER,					--	图表ID
CHARTNAME	VARCHAR2(200),		--	图表名称
CHARTFROM	VARCHAR2(200),		--	图表数据来源
CHARTPATH	VARCHAR2(200),		--	图表路径
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);


-- 研报excel表格表
create table DH_REPORT_EXCEL (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
EXCELID	NUMBER,					--	图表ID
EXCELNAME	VARCHAR2(200),		--	图表名称
EXCELPATH	VARCHAR2(200),		--	图表路径
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);

-- 相关报告表
create table DH_REPORT_RELATED (
ID NUMBER primary key not null,	--	主键
REPORTID	VARCHAR2(100),		--	研报ID
TITLE	VARCHAR2(100),			--	标题
PUBLISHTIME	VARCHAR2(100),		--	发布时间
CREATE_TIME	TIMESTAMP,			--	创建时间
UPDATETIME	TIMESTAMP			--	最近修改时间
);

