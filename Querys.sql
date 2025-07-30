use module1;

-- Q51:
/*Write an SQL query to report the 
name, population, and area of the 
big countries.
Return the result table in any order.
A country is big if:
● it has an area of at least three 
million (i.e., 3000000 km2), or
● it has a population of at least 
twenty-five million (i.e., 25000000).*/
select name, population, area 
from Q51_World
where area >= 3000000 and population >= 25000000;

create table if not exists Q51_World
(
	name varchar(20) primary key,
	continent varchar(10),
    area int,
    population int,
    gdp bigint
);

insert into Q51_World (name, continent, area, population, gdp) 
values
('Afghanistan', 'Asia', 6522300, 25500100, 20343000000),
('Albania', 'Europe', 28748, 2831741, 12960000000),
('Algeria', 'Africa', 23817410, 37100000, 188681000000),
('Andorra', 'Europe', 468, 78115, 3712000000),
('Angola', 'Africa', 1246700, 20609294, 100990000000);

-- Q52:
/*Write an SQL query to report the 
names of the customer that are not 
referred by the customer with id = 2.
Return the result table in any order.*/
select name from Q52_Customer
where referee_id <> 2 or referee_id is null;

create table if not exists Q52_Customer
(
	id int primary key,
	name varchar(10),
    referee_id int
);

insert into Q52_Customer (id, name, referee_id) 
values
(1, 'Will', NULL),
(2, 'Jane', NULL),
(3, 'Alex', 2),
(4, 'Bill', NULL),
(5, 'Zack', 1),
(6, 'Mark', 2);

-- Q53:
/*Write an SQL query to report 
all customers who never order anything.
Return the result table in any order.*/
select name as Customers 
from Q53_Customers
where id not in (select distinct customerId from Q53_Orders);

create table if not exists Q53_Customers
(
	id int primary key,
	name varchar(10)
);

create table if not exists Q53_Orders
(
	id int primary key,
	customerId int,
    foreign key(customerId) references Q53_Customers(id)
);

insert into Q53_Customers (id, name) 
values
(1, 'Joe'),
(2, 'Henry'),
(3, 'Sam'),
(4, 'Max');

insert into Q53_Orders (id, customerId) 
values
(1, 3),
(2, 1);

-- Q54:
/*Write an SQL query to find the 
team size of each of the employees.
Return result table in any order.*/
select 
employee_id, 
count(*) over (partition by team_id) as team_size
from Q54_Employee;

create table if not exists Q54_Employee
(
	employee_id int primary key,
	team_id int
);

insert into Q54_Employee (employee_id, team_id) 
values
(1, 8),
(2, 8),
(3, 8),
(4, 7),
(5, 9),
(6, 9);

-- Q55:
/*A telecommunications company wants to 
invest in new countries. The company 
intends to invest in the countries where 
the average call duration of the calls 
in this country is strictly greater than 
the global average call duration.
Write an SQL query to find the countries 
where this company can invest.
Return the result table in any order.*/
SELECT T_FINAL.name
FROM
(select T2.name, sum(T1.duration) as calls_duration
from
(select t1.caller_id as person, t1.duration, t2.phone_number
from Q55_Calls t1
join Q55_Person t2
on t1.caller_id = t2.id
union all
select t1.callee_id as person, t1.duration, t2.phone_number
from Q55_Calls t1
join Q55_Person t2
on t1.callee_id = t2.id) T1
join Q55_Country T2
on CAST(SUBSTRING_INDEX(T1.phone_number, '-', 1) AS UNSIGNED) = T2.country_code
group by T2.name) AS T_FINAL
WHERE 
T_FINAL.calls_duration 
			>
(select avg(calls_duration)
from 
(select T2.name, sum(T1.duration) as calls_duration
from
(select t1.caller_id as person, t1.duration, t2.phone_number
from Q55_Calls t1
join Q55_Person t2 
on t1.caller_id = t2.id
union all
select t1.callee_id as person, t1.duration, t2.phone_number
from Q55_Calls t1
join Q55_Person t2 
on t1.callee_id = t2.id) T1
join Q55_Country T2
on CAST(SUBSTRING_INDEX(T1.phone_number, '-', 1) AS UNSIGNED) = T2.country_code
group by T2.name) as temp_avg);

create table if not exists Q55_Person
(
	id int primary key,
	name varchar(15),
    phone_number varchar(30)
);

create table if not exists Q55_Country
(
	name varchar(15),
    country_code varchar(5) primary key
);

create table if not exists Q55_Calls
(
	caller_id int,
    callee_id int,
    duration int
);

insert into Q55_Person (id, name, phone_number) 
values
(3, 'Jonathan', '051-1234567'),
(12, 'Elvis', '051-7654321'),
(1, 'Moncef', '212-1234567'),
(2, 'Maroua', '212-6523651'),
(7, 'Meir', '972-1234567'),
(9, 'Rachel', '972-0011100');

insert into Q55_Country (name, country_code) 
values
('Peru', 51),
('Israel', 972),
('Morocco', 212),
('Germany', 49),
('Ethiopia', 251);

insert into Q55_Calls (caller_id, callee_id, duration) 
values
(1, 9, 33),
(2, 9, 4),
(1, 2, 59),
(3, 12, 102),
(3, 12, 330),
(12, 3, 5),
(7, 9, 13),
(7, 1, 3),
(9, 7, 1),
(1, 7, 7);

-- Q56:
/*Write an SQL query to report the 
device that is first logged in for 
each player.
Return the result table in any order.*/
SELECT t1.player_id, t1.device_id	 
FROM Q24_Activity t1
JOIN  
(select player_id, min(event_date) as first_loggin
from Q24_Activity
group by player_id) t2
ON t1.player_id = t2.player_id
AND t1.event_date = t2.first_loggin;

-- Q57:
/*Write an SQL query to report the 
device that is first logged in for 
each player.
Return the result table in any order.*/












































































