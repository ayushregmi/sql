create database db_dbms;

use db_dbms;

create table Tbl_Employee(
					employee_name varchar(255) primary key not null,
                    street varchar(255) not null,
                    city varchar(255) not null
                    );

create table Tbl_Company(
					company_name varchar(255) primary key not null,
                    city varchar(255) not null
                    );

create table Tbl_Works(
					employee_name varchar(255) primary key not null,
                    company_name varchar(255) not null,
                    salary int not null, 
                    foreign key(employee_name) references Tbl_Employee(employee_name),
                    foreign key (company_name) references Tbl_Company(company_name)
                    );
                    
create table Tbl_manages(
					employee_name varchar(255) not null,
                    manager_name varchar(255) not null,
                    foreign key(employee_name) references Tbl_Employee(employee_name),
                    foreign key(manager_name) references Tbl_Employee(employee_name)
                    );

insert into Tbl_Company (company_name, city)
values ("First Bank", "New York"),
("Small Bank", "LA"),
("Second Bank", "Dallas");

insert into Tbl_Employee (employee_name, street, city)
values  
("Peter","123 street","New York"),("Joe","xyz street","Quahog"),("Carl","Groove Street","Los Santos"),("Quagmire","Groove Street","Los Santos"),
("Chris","XYZ Street","LA"),("Meg","Groove Street","Los Santos"),("Rick","XYZ street","LA"),("Morty","Groove Street","Los Santos"), 
("Stewie", "galli no 2","Dallas"),("Leo", "123 Street", "Chicago"), ("Mesut", "galli no 2", "Dallas"), ("Wenger", "groove street","Los Santos");

insert into Tbl_Works(employee_name, company_name, salary)
values("Peter", "First Bank", 10000),
("Joe","First Bank", 15000), 
("Carl", "First Bank", 50000),
("Quagmire", "First Bank", 30000);

insert into Tbl_Works(employee_name, company_name, salary)
values ("Chris","Small Bank",30000),
("Meg","Small Bank",25000),
("Rick","Small Bank",50000),
("Morty","Small Bank",15000);

insert into Tbl_Works(employee_name, company_name, salary)
values ("Stewie","Second Bank",10000),
("Leo","Second Bank",45000),
("Mesut","Second Bank",32000),
("Wenger","Second Bank",50000);

insert into Tbl_manages(employee_name, manager_name)
values("Peter","Carl"),
("Joe","Carl"),
("Quagmire","Carl");

insert into Tbl_manages(employee_name, manager_name)
values("Chris","Rick"),
("Meg","Rick"),
("Morty","Rick");

insert into Tbl_manages(employee_name, manager_name)
values ("Leo","Wenger"),
("Stewie","Wenger"),
("Mesut","Wenger");


-- 2 (a)
select employee_name from Tbl_Works where company_name = "First Bank";

-- 2 (b)
-- using sub query
select Tbl_Employee.employee_name, Tbl_Employee.city from Tbl_Employee
where Tbl_Employee.employee_name = any (select Tbl_Works.employee_name from Tbl_Works where Tbl_Works.company_name = "First Bank");

-- using join
select Tbl_Employee.employee_name, Tbl_Employee.city from Tbl_Employee join Tbl_Works 
on Tbl_Works.employee_name = Tbl_Employee.employee_name 
where Tbl_Works.company_name = "First Bank";

-- 2 (c)
-- using sub query
select Tbl_Employee.employee_name, Tbl_Employee.street, Tbl_Employee.city from Tbl_Employee
where Tbl_Employee.employee_name in (select Tbl_Works.employee_name from Tbl_Works where Tbl_Works.company_name = "First Bank"
and Tbl_Works.salary > 10000);

-- using join
select Tbl_Employee.employee_name, Tbl_Employee.street, Tbl_Employee.city from Tbl_Employee join Tbl_Works 
on Tbl_Works.employee_name = Tbl_Employee.employee_name
where Tbl_Works.company_name = "First Bank" and Tbl_Works.salary > 10000;

-- 2 (d)
-- using sub query
select Tbl_Employee.employee_name from Tbl_Employee 
where Tbl_Employee.city = any (select Tbl_Company.city from Tbl_Company
where Tbl_Company.company_name in (select Tbl_Works.company_name from Tbl_Works where Tbl_Works.employee_name = Tbl_Employee.employee_name));

-- using join
select Tbl_Employee.employee_name, Tbl_Works.company_name, Tbl_Company.city from Tbl_Employee 
join Tbl_Works on Tbl_Works.employee_name = Tbl_Employee.employee_name
join Tbl_Company on Tbl_Company.company_name = Tbl_Works.company_name 
where Tbl_Employee.city = Tbl_Company.city;

-- 2 (e)
-- using join
select * from Tbl_manages 
join Tbl_Employee as E on Tbl_manages.employee_name = E.employee_name
join Tbl_Employee as M on Tbl_manages.manager_name = M.employee_name
where E.city = M.city and E.street = M.street;

-- 2 (f) 
select * from Tbl_Works
where Tbl_Works.company_name != "First Bank";

-- 2 (g)
select * from Tbl_Works
where Tbl_Works.company_name != "Small Bank" and Tbl_Works.salary > (select max(salary) from Tbl_Works where Tbl_Works.company_name = "Small Bank")

-- 2 (h)
select * from Tbl_Company 
where Tbl_Company.city in (select Tbl_Company.city from Tbl_Company where Tbl_Company.company_name = "Small Bank") 
and Tbl_Company.company_name != "Small Bank"

-- 2 (i)
select * from Tbl_Works as M
where M.salary > (select avg(salary) from Tbl_Works as MT where M.company_name = MT.company_name)

-- 2 (j)
select count(employee_name) as emp_count, Tbl_Works.company_name from Tbl_Works 
group by Tbl_Works.company_name
order by emp_count asc
limit 1;

-- 2 (k) 
select sum(salary) as avg_sal, Tbl_Works.company_name from Tbl_Works
group by Tbl_Works.company_name
order by avg_sal asc
limit 1;

-- 2 (l)
select Tbl_Company.company_name from Tbl_Company
where Tbl_Company.company_name in 
(select W.company_name from Tbl_Works as W
where (select avg(salary) from Tbl_Works as WT where WT.company_name = W.company_name) > 
(select avg(salary) from Tbl_Works as WM where WM.company_name="First Bank"))

-- 3 (a)
update Tbl_Employee 
set Tbl_Employee.city = "Newton"
where Tbl_Employee.employee_name = "Jones";

-- 3 (b)
update Tbl_Works
set Tbl_Works.salary = Tbl_Works.salary * (1.1)
where Tbl_Works.employee_name = any (select Tbl_manages.employee_name from Tbl_manages)
and Tbl_Works.company_name = "First Bank";

-- 3 (c)
update Tbl_Works
set Tbl_Works.salary = Tbl_Works.salary * (1.1)
where Tbl_Works.employee_name = any (select Tbl_manages.manager_name from Tbl_manages)
and Tbl_Works.company_name = "First Bank";

-- 3(d)
update Tbl_Works
set Tbl_Works.salary = case when Tbl_Works.salary * (1.1) < 100000 then Tbl_Works.salary * (1.1)
else Tbl_Works.salary * (1.03) end
where Tbl_Works.employee_name = any (select Tbl_manages.manager_name from Tbl_manages)
and Tbl_Works.company_name = "First Bank";


















