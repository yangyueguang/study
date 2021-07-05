-- 　Mysql常用命令
　　show databases; 显示数据库
　　create database name; 创建数据库
　　use databasename; 选择数据库
　　drop database name 直接删除数据库，不提醒
　　show tables; 显示表
　　describe tablename; 显示具体的表结构
　　select 中加上distinct去除重复字段
　　mysqladmin drop databasename 删除数据库前，有提示。
　　显示当前mysql版本和当前日期
　　select version(),current_date;
　　修改mysql中root的密码：
　　shell>mysql -h localhost -u root -p //登录
　　mysql> update user set password=password("xueok654123") where user='root';
　　mysql> flush privileges //刷新数据库
　　mysql>use dbname; 打开数据库：
　　mysql>show databases; 显示所有数据库
　　mysql>show tables; 显示数据库mysql中所有的表：先use mysql;然后
　　mysql>describe user; 显示表mysql数据库中user表的列信息);
　　grant
　　创建用户firstdb(密码firstdb)和数据库，并赋予权限于firstdb数据库
　　mysql> create database firstdb;
　　mysql> grant all on firstdb.* to firstdb identified by 'firstdb'
　　会自动创建用户firstdb
　　mysql默认的是本地主机是localhost,对应的IP地址就是127.0.0.1，所以你用你的IP地址登录会出错，如果你想用你的IP地址登录就要先进行授权用grant命令。
　　mysql>grant all on *.* to root@202.116.39.2 identified by "123456";
　　说明:grant 与on 之间是各种权限，例如:insert,select,update等
　　on 之后是数据库名和表名,第一个*表示所有的数据库，第二个*表示所有的表
　　root可以改成你的用户名，@后可以跟域名或IP地址，identified by 后面的是登录用的密码，可以省略，即缺省密码或者叫空密码。
　　drop database firstdb;
　　创建一个可以从任何地方连接服务器的一个完全的超级用户，但是必须使用一个口令something做这个
　　mysql> grant all privileges on *.* to user@localhost identified by 'something' with
　　增加新用户
　　格式：grant select on 数据库.* to 用户名@登录主机 identified by "密码"
　　GRANT ALL PRIVILEGES ON *.* TO monty@localhost IDENTIFIED BY 'something' WITH GRANT OPTION;
　　GRANT ALL PRIVILEGES ON *.* TO mailto:monty@"" IDENTIFIED BY 'something' WITH GRANT OPTION;
　　删除授权：
　　mysql> revoke all privileges on *.* from mailto:root@"";
　　mysql> delete from user where user="root" and host="%";
　　mysql> flush privileges;
　　创建一个用户custom在特定客户端it363.com登录，可访问特定数据库fangchandb
　　mysql >grant select, insert, update, delete, create,drop on fangchandb.* to custom@ it363.com identified by ' passwd'
　　重命名表:
　　mysql > alter table t1 rename t2;
　　mysqldump
　　备份数据库
　　shell> mysqldump -h host -u root -p dbname >dbname_backup.sql
　　恢复数据库
　　shell> mysqladmin -h myhost -u root -p create dbname
　　shell> mysqldump -h host -u root -p dbname < dbname_backup.sql
　　如果只想卸出建表指令，则命令如下：
　　shell> mysqladmin -u root -p -d databasename > a.sql
　　如果只想卸出插入数据的sql命令，而不需要建表命令，则命令如下：
　　shell> mysqladmin -u root -p -t databasename > a.sql
　　那么如果我只想要数据，而不想要什么sql命令时，应该如何操作呢?
　　mysqldump -T./ phptest driver
　　其中，只有指定了-T参数才可以卸出纯文本文件，表示卸出数据的目录，./表示当前目录，即与mysqldump同一目录。如果不指定driver表，则将卸出整个数据库的数据。每个表会生成两个文件，一个为.sql文件，包含建表执行。另一个为.txt文件，只包含数据，且没有sql指令。
　　可将查询存储在一个文件中并告诉mysql从文件中读取查询而不是等待键盘输入。可利用外壳程序键入重定向实用程序来完成这项工作。例如，如果在文件my_file.sql 中存放有查
　　询，可如下执行这些查询：
　　例如，如果您想将建表语句提前写在sql.txt中，
　　mysql > mysql -h myhost -u root -p
　　Mysql5.0支持的字符集
　　MySQL中的字符集控制做得比较细，可以分为数据库级，表级， 字段级(这一点和ORACLE不同)。我上次改的字符集是数据库级的，对表sysuser没有影响，所以出现了改了字符集却一样无法插入中文的情况。
　　Drop TABLE IF EXISTS `firstdb`.`users`;
　　Create TABLE `firstdb`.`users` (
　　`id` int(11) NOT NULL auto_increment,
　　`username` varchar(40) default NULL,
　　`birthday` date default NULL,
　　PRIMARY KEY (`id`)
　　) ENGINE=InnoDB DEFAULT CHARSET=gb2312;
　　update firstdb.users set username='以' where id=3;

mysql 字段类型：
string
hash
list
set
zset

# 插入
mysql:insert into Student(name) values(abc)
mongo:db.Student.insert({})

# 更新
mysql:update Student set name=abc where id > 2
mongo:db.Student.update({id == 2},{$set},{name: abc})

# 删除
mysql:delete from Student where ....
mongo:db.Student.remove({id:2},{name: abc})

# 查找
db.stu.find({},{})
$where
limit(),skip(),sort(),count(),distinct()


db,show dbs,use Student,drop names
db.Student.insert({})
db.Student.update({},{$set:{}},{multi:true})
db.Student.remove({})
db.Student.find({},{}).limit().skip().sort().count().distinct()


mysql	insert update delete select
redis	set	set	del	get
mongodb	insert	update	remove	find,aggregate





mysql

create database Student charset=utf8;
drop database Student
show databases;
use Student
----------------------------------------

create table Student(name...);
id
	age int unsigned
	name not null
	id primary key
	ida auto_increment)

create table stu(
    -> id int not null primary key auto_increment,
    -> name varchar(10) not null,
    -> gender bit default 1,
    -> birthday datetime,
    -> isDelete bit default 0,
    -> );
show tables;
desc Student;
alter table Student add|modify|drop Student;
alter table stu modify column isDelete bit not null default 0;
drop table Student;
----------------------------------------

insert into Student(name) values(abc),(def)...;
update Student set age=23,... where ...;
delete from Student where ...;
update ....
mysqldump >
mysql <



select * from stu where gender=1 and (name like 'abc%' or name like 'def%')

distinct


create table sco(
id int not null auto_increment primary key,
stu_id int,
sub_id int,
score int(3),
foreign key(stu_id) references stu(id),
foreign key(sub_id) references sub(id)
);

insert into sco values(0,1,1,100);


select distinct * from Student
where ...
group by ...
having ...
order by ...
limit ...

stu,class
stu.class_id=class.id
select * from stu inner join class on stu.class_id=class.id


select name,score from stu inner join sco on stu.id=sco.stu_id

select name,avg(score) from stu inner join sco on stu.id=sco.stu_id
group by name

sub.title->sub
avg(),score->sco
sub.id=sco.sub_id



stu
sub
sco


select * from areas where title='abc'


	#select * from areas where title='abc'  #370300
	#select * from areas where pid='370300'  #370301
	#select * from areas where pid='370301'

	#areas as shi where shi.title='abc'
	#areas as qu on qu.pid=shi.id
	#areas as qu1 on qu1.pid=qu.id

	select qu.*,qu1.*
	from areas as shi
	inner join areas as qu on qu.pid=shi.id
	left join areas as qu1 on qu1.pid=qu.id
	where shi.title='abc'


#select id from areas where title='abc' or title='def'
select * from areas where pid in(select id from areas where title='abc' or title='def')


python setup.py install


MySQLdb
Connection
Cursor

fetchone(),fetchall()
hashlib
sha1()
update()
hexdigest()




pip list

Connection:MySQLdb.connect(),cursor(),commit(),rollback(),close()
Cursor:execute(),fetchone(),fetchall(),close()

string
hash
list
set
zset



If key already exists and is a string, this command appends the value at the end of the string. If key does not exist it is created and set as an empty string, so APPEND will be similar to SET in this special case.

----------------------------------------


create table stu(
    -> id int not null primary key auto_increment,
    -> name varchar(10) not null,
    -> gender bit default 1,
    -> birthday datetime,
    -> isDelete bit default 0,
    -> );

----------------------------------------

MySQLdb
Connection
Cursor


hashlib
sha1()
update()
hexdigest()
select distinct * from Student
where ...
group by ...
having ...
order by ...
limit ...

stu.class_id=class.id
????select * from stu inner join class on stu.class_id=class.id



select name,score from stu inner join sco on stu.id=sco.stu_id

select name,avg(score) from stu inner join sco on stu.id=sco.stu_id
group by name


	#select * from areas where title='¡Á?????'  #370300
	#select * from areas where pid='370300'  #370301
	#select * from areas where pid='370301'

	#areas as shi where shi.title='??????'
	#areas as qu on qu.pid=shi.id
	#areas as qu1 on qu1.pid=qu.id

	select qu.*,qu1.*
	from areas as shi
	inner join areas as qu on qu.pid=shi.id
	left join areas as qu1 on qu1.pid=qu.id
	where shi.title='a'

select * from areas where pid in(select id from areas where title='a' or title='b')

python setup.py install

db,show dbs,use Student,drop Teacher
db.Student.insert({})
db.Student.update({},{$set:{}},{multi:true})
db.Student.remove({})
db.Student.find({},{}).limit().skip().sort().count().distinct()


mysql	insert update delete select
redis	set	set	del	get
mongodb	insert	update	remove	find,aggregate

create table sco(
id int not null auto_increment primary key,
stu_id int,
sub_id int,
score int(3),
foreign key(stu_id) references stu(id),
foreign key(sub_id) references sub(id)
)

insert into sco values(0,1,1,100);

string
hash
list
set
zset









