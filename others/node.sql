select * from Student;
select * from Course;
select * from SC;
select Sno from SC;
select distinct Sno from SC;
select all Sno from SC;
select Sname From Student where Sdept='CS';
select Sname,Sage From Student where Sage<20;
select Sname,Sage from Student where Sage between 0 and 19;
select Sname,Sage from Student where not Sage=20;
select Sname,Sage from Student where not Sage between 20 and 20;
select Sno,Sname,Ssex,Sage from Student;
select * from Student where Sdept='CS' or Sdept='IS' or Sdept='MA';
select * from Student where Sdept in('CS','IS','MA');
select Sname,Ssex,Sage from Student where Sname like'刘%';
select Sno,Sname,Sage from Student where Sname like'刘__';
select Sno,Cno from SC where Grade is null;
select Sno,Cno from SC where Grade is not null;
select count(distinct Sno) from SC;
select top 1 Grade From SC where Cno=1 order by Grade desc;
select max(Grade) from SC where Cno=1;
select Sno from SC Group by Sno Having count(Cno)>3;
select * from Student,SC where Student.Sno=SC.Sno;--笛卡尔基
select Student.Sno,Sname,Ssex,Sage,Sdept,Cno,Grade from Student,SC where Student.Sno=SC.Sno;
select a.cno,b.cpno from Course a,Course b where a.cpno=b.cno;
select Student.* ,SC.Grade from Student,SC where Student.Sno *=SC.Sno;--哪个信息多*在那头
select Student.* ,SC.Grade from Student left join SC on Student.Sno=SC.Sno;--左连接
select Student.Sno,Student.Sname,Course.Cname,SC.Grade from Student,Course,SC where Student.Sno=SC.Sno and Course.Cno=SC.Cno;
select Sno,Sname from Student where Sno in (select Sno from SC where Cno in (select Cno From Course where Cname='信息系统'));
select Sname,Sage from Student where Sage < any (select Sage from Student where Sdept='IS') and Sdept<>'IS';
select Sname from Student where not exists (select * from Course where not exists(select * from SC where Sno=Student.Sno and Cno=Course.Cno));