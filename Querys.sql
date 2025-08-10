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
/*Write an SQL query to find the 
customer_number for the customer 
who has placed the largest
number of orders.
The test cases are generated so 
that exactly one customer will have 
placed more orders than any
other customer.*/
select T.customer_number
from
(select distinct customer_number, count(*) as t
from Q57_Orders
group by customer_number
having t = (select count(*) as t
from Q57_Orders
group by customer_number
order by t desc
limit 1)) as T;

create table if not exists Q57_Orders
(
	order_number int primary key,
    customer_number int
);

insert into Q57_Orders (order_number, customer_number)
values
(1, 1),
(2, 2),
(3, 3),
(4, 3);

-- Q58:
/*Write an SQL query to report 
all the consecutive available 
seats in the cinema.
Return the result table ordered 
by seat_id in ascending order.
The test cases are generated so 
that more than two seats are 
consecutively available.*/
SELECT T.seat_id
FROM
(select seat_id, free,
lag(free) over (order by seat_id) as anterior,
lead(free) over (order by seat_id) as siguiente
from Q58_Cinema) T
WHERE T.free = 1 AND (T.anterior = 1 OR T.siguiente = 1)
ORDER BY T.seat_id;

create table if not exists Q58_Cinema
(
	seat_id int primary key,
    free bool
);

insert into Q58_Cinema (seat_id, free)
values
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 1);

-- Q59:
/*Write an SQL query to report the 
names of all the salespersons who 
did not have any orders related to
the company with the name "RED".
Return the result table in any order.*/
SELECT DISTINCT name
FROM Q59_SalesPerson 
WHERE 
sales_id NOT IN (select distinct t1.sales_id
from Q59_Orders t1
join Q59_Company t2
on t1.com_id = t2.com_id
where t2.name = 'RED');

create table if not exists Q59_SalesPerson
(
	sales_id int primary key,
    name varchar(10),
    salary int,
    commission_rate int,
    hire_date date
);

create table if not exists Q59_Company
(
	com_id int primary key,
    name varchar(10),
    city varchar(10)
);

create table if not exists Q59_Orders
(
	order_id int primary key,
    order_date date,
    com_id int,
    sales_id int,
    amount int,
    foreign key(com_id) references Q59_Company(com_id),
    foreign key(sales_id) references Q59_SalesPerson(sales_id)
);

insert into Q59_SalesPerson (sales_id, name, salary, commission_rate, hire_date)
values
(1, 'John', 100000, 6, '2006-04-01'),
(2, 'Amy', 12000, 5, '2010-05-01'),
(3, 'Mark', 65000, 12, '2008-12-25'),
(4, 'Pam', 25000, 25, '2005-01-01'),
(5, 'Alex', 5000, 10, '2007-02-03');

insert into Q59_Company (com_id, name, city)
values
(1, 'RED', 'Boston'),
(2, 'ORANGE', 'New York'),
(3, 'YELLOW', 'Boston'),
(4, 'GREEN', 'Austin');

insert into Q59_Orders (order_id, order_date, com_id, sales_id, amount)
values
(1, '2014-01-01', 3, 4, 10000),
(2, '2014-02-01', 4, 5, 5000),
(3, '2014-03-01', 1, 1, 50000),
(4, '2014-04-01', 1, 4, 25000);

-- Q60:
/*Write an SQL query to report for 
every three line segments whether 
they can form a triangle.
Return the result table in any order.*/
select *, (case when (x + y > z and x + z > y and y + z > x) then 'Si' else 'No' end) as triangle 
from Q60_Triangle;

create table if not exists Q60_Triangle
(
	x int,
    y int,
    z int,
    primary key (x, y, z)
);

insert into Q60_Triangle (x, y, z)
values
(13, 15, 30),
(10, 20, 15);

-- Q61:
/*Write an SQL query to report the 
shortest distance between any two 
points from the Point table.*/
select abs(t1.x - t2.x) as shortest
from Q61_Point t1
cross join Q61_Point t2
where t1.x <> t2.x
order by shortest asc
limit 1;

with OrderedPoints as 
(select x,
lead(x) over (order by x) as next_x
from Q61_Point)
select min(abs(x-next_x)) as shortest
from OrderedPoints
where next_x is not null; 

/*O(n²) → O(n)*/

create table if not exists Q61_Point
(
	x int primary key
);

insert into Q61_Point (x)
values
(-1),
(0),
(2);

-- Q62:
/*Write a SQL query for a report 
that provides the pairs 
(actor_id, director_id) where the 
actor has cooperated with the 
director at least three times.
Return the result table in any order.*/
select T.actor_id, T.director_id
from
(select actor_id, director_id, count(*) as t
from Q62_ActorDirector
group by actor_id, director_id
having t >= 3) T;

create table if not exists Q62_ActorDirector
(
	actor_id int,
    director_id int,
    timestamp int primary key
);

insert into Q62_ActorDirector (actor_id, director_id, timestamp) 
values
(1, 1, 0),
(1, 1, 1),
(1, 1, 2),
(1, 2, 3),
(1, 2, 4),
(2, 1, 5),
(2, 1, 6);

-- Q63:
/*Write an SQL query that reports 
the product_name, year, and price 
for each sale_id in the Sales table.
Return the resulting table in any order.*/
select t2.product_name, t1.year, t1.price
from Q63_Sales t1
join Q63_Product t2
on t1.product_id = t2.product_id
group by t2.product_name, t1.year, t1.price;

create table if not exists Q63_Product
(
	product_id int primary key,
    product_name varchar(15)
);

create table if not exists Q63_Sales
(
	sale_id int,
    product_id int,
    year int,
    quantity int,
    price int,
    primary key(sale_id, year),
	foreign key(product_id) references Q63_Product(product_id)
);

insert into Q63_Product (product_id, product_name)
values 
(100, 'Nokia'),
(200, 'Apple'),
(300, 'Samsung');

insert into Q63_Sales (sale_id, product_id, year, quantity, price)
values
(1, 100, 2008, 10, 5000),
(2, 100, 2009, 12, 5000),
(7, 200, 2011, 15, 9000);

-- Q64:
/*Write an SQL query that reports 
the average experience years of 
all the employees for each project,
rounded to 2 digits.
Return the result table in any order..*/
select t1.project_id, round(avg(t2.experience_years), 2) as average_years
from Q64_Project t1
join Q64_Employee t2
on t1.employee_id = t2.employee_id
group by t1.project_id;

create table if not exists Q64_Employee
(
	employee_id int primary key,
    name varchar(10),
    experience_years int
);

create table if not exists Q64_Project
(
	project_id int,
    employee_id int,
    primary key(project_id, employee_id),
    foreign key(employee_id) references Q64_Employee(employee_id)
);

insert into Q64_Employee (employee_id, name, experience_years)
values
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 1),
(4, 'Doe', 2);

insert into Q64_Project (project_id, employee_id)
values
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);

-- Q65:
/*Write an SQL query that reports the 
best seller by total sales price, If 
there is a tie, report them all.
Return the result table in any order.*/
select distinct t1.seller_id
from 
(select seller_id, sum(price) as price
from Q17_Sales 
group by seller_id) t1
where t1.price = 
(select max(t.price)
from
(select seller_id, sum(price) as price
from Q17_Sales 
group by seller_id) t);

SELECT seller_id
FROM
(select  seller_id, 
		sum(price) as price, 
		rank() over (order by sum(price) desc) as rk
from Q17_Sales
group by seller_id) t
WHERE t.rk = 1;

-- Q66:
/*Write an SQL query that 
reports the buyers who have 
bought S8 but not iPhone. 
Note that S8 and iPhone are 
products present in the Product table.
Return the result table in any order.*/
select t1.buyer_id 
from Q17_Sales t1
join Q17_Product t2
on t1.product_id = t2.product_id
where t2.product_name <> 'iPhone'
and t2.product_name = 'S8';

-- Q67:
/*You are the restaurant owner and 
you want to analyse a possible 
expansion (there will be at least one
customer every day).
Write an SQL query to compute the 
moving average of how much the 
customer paid in a seven days
window (i.e., current day + 6 days 
before). average_amount should be 
rounded to two decimal places.
Return result table ordered by 
visited_on in ascending order.*/
SELECT
  visited_on,
  ROUND((
    SELECT SUM(amount) / 7
    FROM Q67_Customer B
    WHERE B.visited_on BETWEEN DATE_SUB(A.visited_on, INTERVAL 6 DAY) AND A.visited_on
  ), 2) AS total_amount
FROM (
  SELECT DISTINCT visited_on
  FROM Q67_Customer
) A
ORDER BY visited_on;

create table if not exists Q67_Customer
(
	customer_id int,
    name varchar(10),
    visited_on date,
    amount int,
    primary key(customer_id, visited_on)
);

insert into Q67_Customer (customer_id, name, visited_on, amount)
values
(1, 'Jhon', '2019-01-01', 100),
(2, 'Daniel', '2019-01-02', 110),
(3, 'Jade', '2019-01-03', 120),
(4, 'Khaled', '2019-01-04', 130),
(5, 'Winston', '2019-01-05', 110),
(6, 'Elvis', '2019-01-06', 140),
(7, 'Anna', '2019-01-07', 150),
(8, 'Maria', '2019-01-08', 80),
(9, 'Jaze', '2019-01-09', 110),
(1, 'Jhon', '2019-01-10', 130),
(3, 'Jade', '2019-01-10', 150);

-- Q68:
/*Write an SQL query to find the 
total score for each gender on each day.
Return the result table ordered 
by gender and day in ascending order.*/
SELECT 
  gender,
  day,
  SUM(score_points) OVER (
    PARTITION BY gender 
    ORDER BY day
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_score
FROM Q68_Scores
ORDER BY gender, day;

create table if not exists Q68_Scores
(
	player_name varchar(15),
    gender varchar(1),
    day date,
    score_points int,
    primary key(gender, day)
);

insert into Q68_Scores (player_name, gender, day, score_points)
values 
('Aron', 'F', '2020-01-01', 17),
('Alice', 'F', '2020-01-07', 23),
('Bajrang', 'M', '2020-01-07', 7),
('Khali', 'M', '2019-12-25', 11),
('Slaman', 'M', '2019-12-30', 13),
('Joe', 'M', '2019-12-31', 3),
('Jose', 'M', '2019-12-18', 2),
('Priya', 'F', '2019-12-31', 23),
('Priyanka', 'F', '2019-12-30', 17);

-- Q69:
/*Write an SQL query to find the 
start and end number of continuous 
ranges in the table Logs.
Return the result table ordered by 
start_id.*/
select min(log_id) as start_id,
max(log_id) as end_id
from
(select log_id, log_id - row_number() over (order by log_id) as t 
from (select * from Q69_Logs order by log_id) n) ty
group by ty.t;

create table if not exists Q69_Logs
(
	log_id int primary key
);

insert into Q69_Logs (log_id)
values
(1),
(2),
(3),
(7),
(8),
(10);

-- Q70:
/*Write an SQL query to find the 
number of times each student 
attended each exam.
Return the result table ordered by 
student_id and subject_name.*/
select t1.student_id, t1.student_name, t2.subject_name, count(t3.subject_name) as attended_exams
from Q70_Students t1
cross join Q70_Subjects t2 
left join Q70_Examinations t3
on t1.student_id = t3.student_id
and t2.subject_name = t3.subject_name
group by t1.student_id, t1.student_name, t2.subject_name
order by t1.student_id asc, t2.subject_name asc; 

create table if not exists Q70_Students
(
	student_id int primary key,
    student_name varchar(10)
);

create table if not exists Q70_Subjects
(
	subject_name varchar(25) primary key
);

create table if not exists Q70_Examinations
(
	student_id int,
    subject_name varchar(25)
);

insert into Q70_Students (student_id, student_name) 
values
(1, 'Alice'),
(2, 'Bob'),
(13, 'John'),
(6, 'Alex');

insert into Q70_Subjects (subject_name) 
values
('Math'),
('Physics'),
('Programming');

insert into Q70_Examinations (student_id, subject_name) 
values
(1, 'Math'),
(1, 'Physics'),
(1, 'Programming'),
(2, 'Programming'),
(1, 'Physics'),
(1, 'Math'),
(13, 'Math'),
(13, 'Programming'),
(13, 'Physics'),
(2, 'Math'),
(1, 'Math');

-- Q71:
/*Write an SQL query to find employee_id 
of all employees that directly or 
indirectly report their work to the head 
of the company.
The indirect relation between managers 
will not exceed three managers as the 
company is small.
Return the result table in any order.*/
select employee_id
from Q71_Employees
where manager_id in (select employee_id
from Q71_Employees
where manager_id in 
(select employee_id from Q71_Employees where manager_id = 1 and employee_id <> 1))
UNION ALL
select employee_id
from Q71_Employees
where manager_id in 
(select employee_id from Q71_Employees where manager_id = 1 and employee_id <> 1)
UNION ALL
select employee_id from Q71_Employees where manager_id = 1 and employee_id <> 1;

create table if not exists Q71_Employees
(
	employee_id int primary key,
    employee_name varchar(20),
    manager_id int
);

insert into Q71_Employees (employee_id, employee_name, manager_id) 
values
(1, 'Boss', 1),
(3, 'Alice', 3),
(2, 'Bob', 1),
(4, 'Daniel', 2),
(7, 'Luis', 4),
(8, 'Jhon', 3),
(9, 'Angela', 8),
(77, 'Robert', 1);

-- Q72:
/*Write an SQL query to find for each 
month and country, the number of 
transactions and their total
amount, the number of approved 
transactions and their total amount.
Return the result table in any order.*/
select date_format(trans_date, '%Y-%m') as month, 
country, 
count(*) as trans_count,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as roved_total_amo
from Q72_Transactions
group by country, date_format(trans_date, '%Y-%m');

create table if not exists Q72_Transactions
(
	id int primary key,
    country varchar(2),
    state enum('approved', 'declined'),
    amount int,
    trans_date date
);

insert into Q72_Transactions (id, country, state, amount, trans_date) 
values
(121, 'US', 'approved', 1000, '2018-12-18'),
(122, 'US', 'declined', 2000, '2018-12-19'),
(123, 'US', 'approved', 2000, '2019-01-01'),
(124, 'DE', 'approved', 2000, '2019-01-07');

-- Q73:
/*Write an SQL query to find the 
average daily percentage of posts 
that got removed after being
reported as spam, rounded to 2 decimal 
places.*/
select round(avg(average_daily_percent)*100, 0) as average_daily_percent
from 
(SELECT T1.dia, ROUND(T1.distinct_posts_ids/ T2.distinct_posts_ids, 2) AS average_daily_percent
FROM 
(select day(t1.action_date) as dia, count(distinct t1.post_id) as distinct_posts_ids
from Q73_Actions t1
join Q73_Removals t2
on t1.post_id = t2.post_id 
and day(t1.action_date) in (select day(action_date) as dia
from Q73_Actions
where action = 'report' and extra = 'spam')
group by day(t1.action_date)) T1
JOIN
(select day(action_date) as dia, count(distinct post_id) as distinct_posts_ids
from Q73_Actions
group by day(action_date)) T2
ON T1.dia = T2.dia
GROUP BY T1.dia) tuti;

create table if not exists Q73_Actions
(
	user_id int,
    post_id int,
    action_date date,
    action enum('view', 'like', 'reaction', 'comment', 'report', 'share'),
    extra varchar(10)
);

create table if not exists Q73_Removals
(
	post_id int primary key,
    remove_date date
);

insert into Q73_Actions (user_id, post_id, action_date, action, extra) 
values
(1, 1, '2019-07-01', 'view', NULL),
(1, 1, '2019-07-01', 'like', NULL),
(1, 1, '2019-07-01', 'share', NULL),
(2, 2, '2019-07-04', 'view', NULL),
(2, 2, '2019-07-04', 'report', 'spam'),
(3, 4, '2019-07-04', 'view', NULL),
(3, 4, '2019-07-04', 'report', 'spam'),
(4, 3, '2019-07-02', 'view', NULL),
(4, 3, '2019-07-02', 'report', 'spam'),
(5, 2, '2019-07-03', 'view', NULL),
(5, 2, '2019-07-03', 'report', 'racism'),
(5, 5, '2019-07-03', 'view', NULL),
(5, 5, '2019-07-03', 'report', 'racism');

insert into Q73_Removals (post_id, remove_date) 
values
(2, '2019-07-20'),
(3, '2019-07-18');

-- Q74:
/*Write an SQL query to report the 
fraction of players that logged in 
again on the day after the day they
first logged in, rounded to 2 decimal 
places. In other words, you need to 
count the number of players
that logged in for at least two 
consecutive days starting from their 
first login date, then divide that
number by the total number of players.*/
with y1 as (SELECT count(distinct T.player_id) as i
FROM 
(select *, lag(event_date) over (partition by player_id order by event_date) as g,
datediff(event_date, lag(event_date) over (partition by player_id order by event_date)) as t
from Q24_Activity) T
WHERE T.t = 1),
y2 as (select count(distinct player_id) as h from Q24_Activity)
	SELECT round(y1.i/y2.h, 2) as fraction
    FROM y1, y2;

-- Q75:
/*Write an SQL query to report the 
fraction of players that logged in 
again on the day after the day they
first logged in, rounded to 2 decimal 
places. In other words, you need to 
count the number of players
that logged in for at least two 
consecutive days starting from their 
first login date, then divide that
number by the total number of players.*/
with y1 as 
(select count(distinct t.player_id) as i
from 
(select t1.player_id, datediff(t1.event_date, t2.first_log) as g
from Q24_Activity t1 
join 
(select player_id, min(event_date) as first_log, count(distinct event_date) as total_days
from Q24_Activity
group by player_id
having total_days >= 2) t2
on t1.player_id = t2.player_id) t
where t.g = 1), 
y2 as (select count(distinct player_id) as h 
from Q24_Activity)
	select round(y1.i / (y2.h), 2) as fraction
	from y1, y2;

-- Q76:
/*Write an SQL query to find the salaries 
of the employees after applying taxes. 
Round the salary to the
nearest integer.
The tax rate is calculated for each company 
based on the following criteria:
● 0% If the max salary of any employee in 
the company is less than $1000.
● 24% If the max salary of any employee in 
the company is in the range [1000, 10000] 
inclusive.
● 49% If the max salary of any employee in 
the company is greater than $10000.
Return the result table in any order.*/
select 	t1.company_id,
		t1.employee_id,
        t1.employee_name,
		round
        (case 
			when t2.max_salary < 1000 then t1.salary*1 
			when (t2.max_salary >= 1000 and t2.max_salary <= 10000) then t1.salary*0.76 
			when t2.max_salary > 10000 then t1.salary*0.51 
		end) as salary
from Q76_Salaries t1
join
(select company_id, max(salary) as max_salary 
from Q76_Salaries 
group by company_id) t2
on t1.company_id = t2.company_id
order by t1.company_id;

create table if not exists Q76_Salaries
(
	company_id int,
    employee_id int,
    employee_name varchar(20),
    salary int,
    primary key(company_id, employee_id)
);

insert into Q76_Salaries (company_id, employee_id, employee_name, salary)
values
(1, 1, 'Tony', 2000),
(1, 2, 'Pronub', 21300),
(1, 3, 'Tyrrox', 10800),
(2, 1, 'Pam', 300),
(2, 7, 'Bassem', 450),
(2, 9, 'Hermione', 700),
(3, 7, 'Bocaben', 100),
(3, 2, 'Ognjen', 2200),
(3, 13, 'Nyan Cat', 3300),
(3, 15, 'Morning Cat', 7777);

-- Q77:
/*Write an SQL query to evaluate the 
boolean expressions in Expressions table.
Return the result table in any order.*/
SELECT 
	T.left_operand, T.operator, T.right_operand,
    case when
		(case when operator = '<' then (T.left_operand2 < T.right_operand2)
			 when operator = '>' then (T.left_operand2 > T.right_operand2)
			 when operator = '=' then (T.left_operand2 = T.right_operand2)
		end) then 'true'
        else 'false'
	end as value
FROM 
(select t3.left_operand2, t3.left_operand, t3.operator, t4.value as right_operand2, t3.right_operand
from
(select t2.value as left_operand2, t1.left_operand, t1.operator, t1.right_operand
from Q77_Expressions t1
join Q77_Variables t2
on t1.left_operand = t2.name) t3
join Q77_Variables t4
on t3.right_operand = t4.name) T;

create table if not exists Q77_Variables
(
    name varchar(1) primary key,
    value int
);

create table if not exists Q77_Expressions
(
    left_operand varchar(1),
    operator enum('<', '>', '='),
    right_operand varchar(1),
    primary key(left_operand, operator, right_operand)
);

insert into Q77_Variables (name, value)
values
('x', 66),
('y', 77);

insert into Q77_Expressions (left_operand, operator, right_operand)
values
('x', '>', 'y'),
('x', '<', 'y'),
('x', '=', 'y'),
('y', '>', 'x'),
('y', '<', 'x'),
('x', '=', 'x');

-- Q78:
/*A telecommunications company wants 
to invest in new countries. The company 
intends to invest in the countries where 
the average call duration of the calls 
in this country is strictly greater than 
the global average call duration.
Write an SQL query to find the countries 
where this company can invest.
Return the result table in any order.*/
with y1 as 
	(select t1.user_id, t1.duration, CAST(SUBSTRING_INDEX(t2.phone_number, '-', 1) AS UNSIGNED) as code
	from 
	(select caller_id as user_id, duration 
	from Q55_Calls
	UNION ALL
	select callee_id as user_id, duration 
	from Q55_Calls) t1
	left join Q55_Person t2
	on t1.user_id = t2.id),
y2 as 
	(select * from Q55_Country),
y1_y2 as 
	(select sum(y1.duration) as total, y2.name
	from y1
	join y2
	on y1.code = y2.country_code
	group by y2.name)
select y1_y2.name as country
from y1_y2
where total > (select avg(total) as promedio from y1_y2);

-- Q79:
/*Write a query that prints a list 
of employee names (i.e.: the name 
attribute) from the Employee table 
in alphabetical order.*/
select distinct name 
from Q79_Employee
order by name;

create table if not exists Q79_Employee
(
    employee_id int primary key,
    name varchar(15),
    months int,
    salary int
);

insert into Q79_Employee (employee_id, name, months, salary)
values
(12228, 'Rose', 15, 1968),
(33645, 'Angela', 1, 3443),
(45692, 'Frank', 17, 1608),
(56118, 'Patrick', 7, 1345),
(59725, 'Lisa', 11, 2330),
(74197, 'Kimberly', 16, 4372),
(78454, 'Bonnie', 8, 1771),
(83565, 'Michael', 6, 2017),
(98607, 'Todd', 5, 3396),
(99989, 'Joe', 9, 3573);

-- Q80:
/*Assume you are given the table below 
containing information on user transactions 
for particular products. Write a query to 
obtain the year-on-year growth rate for the 
total spend of each product for each year.
Output the year (in ascending order) partitioned 
by product id, current year's spend, previous 
year's spend and year-on-year growth rate 
(percentage rounded to 2 decimal places).*/
select 	product_id, 
		spend as curr_year_spend, 
        lag(spend) over (order by year(transaction_date)) as prev_year_spend,
        round((spend*100/lag(spend) over (order by year(transaction_date))) - 100, 2) as yoy_rate
from Q80_user_transactions;

create table if not exists Q80_user_transactions
(
    transaction_id int,
    product_id int,
    spend float,
    transaction_date datetime
);

insert into Q80_user_transactions (transaction_id, product_id, spend, transaction_date)
values
(1341, 123424, 1500.60, '2019-12-31 12:00:00'),
(1423, 123424, 1000.20, '2020-12-31 12:00:00'),
(1623, 123424, 1246.44, '2021-12-31 12:00:00'),
(1322, 123424, 2145.32, '2022-12-31 12:00:00');

-- Q81: **********************FALTA**********************************
/*Amazon wants to maximise the number 
of items it can stock in a 500,000 
square feet warehouse. It wants to 
stock as many prime items as possible, 
and afterwards use the remaining square 
footage to stock the most number of 
non-prime items.
Write a SQL query to find the number of 
prime and non-prime items that can be 
stored in the 500,000 square feet 
warehouse. Output the item type and 
number of items to be stocked.
Hint - create a table containing a summary 
of the necessary fields such as item type 
('prime_eligible','not_prime'), SUM of 
square footage, and COUNT of items grouped 
by the item type.*/
select * from Q81_inventory;

create table if not exists Q81_inventory
(
    item_id int,
    item_type enum('prime_eligible','not_prime'),
    item_category varchar(25),
    square_footage float
);

insert into Q81_inventory (item_id, item_type, item_category, square_footage)
values
(1374, 'prime_eligible', 'mini refrigerator', 68.00),
(4245, 'not_prime', 'standing lamp', 26.40),
(2452, 'prime_eligible', 'television', 85.00),
(3255, 'not_prime', 'side table', 22.60),
(1672, 'prime_eligible', 'laptop', 8.50);


select (500000 / min(square_footage)) as min 
from Q81_inventory
where item_type = 'prime_eligible';

-- Q82:
/*Assume you have the table below 
containing information on Facebook 
user actions. Write a query to
obtain the active user retention 
in July 2022. Output the month 
(in numerical format 1, 2, 3) and 
the number of monthly active users 
(MAUs).
Hint: An active user is a user 
who has user action 
("sign-in", "like", or "comment") 
in the current month and last month.*/
select MONTH(t.y2) as month, count(distinct user_id) as monthly_active_users
from
(select *
, lag(event_type) over(partition by user_id order by event_date) as y1
, lag(event_date) over(partition by user_id order by event_date) as y2
from Q82_user_actions) t
where MONTH(t.event_date) = MONTH(t.y2)
	  AND YEAR(t.event_date) = YEAR(t.y2)
group by MONTH(t.y2);

create table if not exists Q82_user_actions
(
    user_id int,
    event_id int,
    event_type enum('sign-in', 'like', 'comment'),
    event_date datetime
);

insert into Q82_user_actions (user_id, event_id, event_type, event_date)
values
(445, 7765, 'sign-in', '2022-05-31 12:00:00'),
(742, 6458, 'sign-in', '2022-06-03 12:00:00'),
(445, 3634, 'like', '2022-06-05 12:00:00'),
(742, 1374, 'comment', '2022-06-05 12:00:00'),
(648, 3124, 'like', '2022-06-18 12:00:00');

-- Q83:**********************FALTA**************************
/*Google's marketing team is making 
a Superbowl commercial and needs a 
simple statistic to put on
their TV ad: the median number of 
searches a person made last year.
However, at Google scale, querying 
the 2 trillion searches is too costly. 
Luckily, you have access to the
summary table which tells you the 
number of searches made last year and 
how many Google users fall into that 
bucket.
Write a query to report the median of 
searches made by a user. Round the 
median to one decimal point.*/
select * from Q83_search_frequency;

create table if not exists Q83_search_frequency
(
    searches int,
    num_users int
);

insert into Q83_search_frequency (searches, num_users)
values
(1, 2),
(2, 2),
(3, 3),
(4, 1);

-- Q84: *******************************FALTA******************************
/*Write a query to update the Facebook 
advertiser's status using the daily_pay 
table. Advertiser is a two-column table 
containing the user id and their payment 
status based on the last payment and
daily_pay table has current information 
about their payment. Only advertisers 
who paid will show up in this table.
Output the user id and current payment 
status sorted by the user id.
Definition of advertiser status:
● New: users registered and made their 
first payment.
● Existing: users who paid previously 
and recently made a current payment.
● Churn: users who paid previously, 
but have yet to make any recent payment.
● Resurrect: users who did not pay 
recently but may have made a previous 
payment and have made payment again 
recently.*/
select * from Q84_advertiser;
select * from Q84_daily_pay;

create table if not exists Q84_advertiser
(
    user_id varchar(10),
    status varchar(20)
);

create table if not exists Q84_daily_pay
(
    user_id varchar(10),
    paid float
);

insert into Q84_advertiser (user_id, status)
values
('bing', 'NEW'),
('yahoo', 'NEW'),
('alibaba', 'EXISTING');
  
insert into Q84_daily_pay (user_id, paid)
values
('yahoo', 45.00),
('alibaba', 100.00),
('target', 13.00);

-- Q85: 
/*Amazon Web Services (AWS) is powered 
by fleets of servers. Senior management 
has requested data-driven solutions to 
optimise server usage.
Write a query that calculates the total 
time that the fleet of servers was 
running. The output should be in units 
of full days.

1. Calculate individual uptimes
2. Sum those up to obtain the uptime of 
the whole fleet, keeping in mind that 
the result must be output in units of 
full days
Assumptions:
● Each server might start and stop 
several times.
● The total time in which the server 
fleet is running can be calculated as 
the sum of each server's uptime.*/
WITH T AS 
(select * 
from
(select 	*
		, lag(session_status) over(partition by server_id) as y
		, lag(status_time) over(partition by server_id) as y0
        ,(TIMESTAMPDIFF(SECOND,
                LAG(status_time) OVER (PARTITION BY server_id ORDER BY status_time),
                status_time)/86400.0) AS diff_days
from Q85_server_utilization) t
where t.session_status = 'stop' and t.y = 'start'
order by t.server_id asc, t.status_time asc)
SELECT round(sum(T.diff_days)) as total_uptime_days
FROM T;

create table if not exists Q85_server_utilization
(
    server_id int,
    status_time timestamp,
    session_status enum('start', 'stop')
);

insert into Q85_server_utilization (server_id, status_time, session_status)
values
(1, '2022-08-02 10:00:00', 'start'),
(1, '2022-08-04 10:00:00', 'stop'),
(2, '2022-08-17 10:00:00', 'start'),
(2, '2022-08-24 10:00:00', 'stop');

-- Q86: 
/*Sometimes, payment transactions are 
repeated by accident; it could be due 
to user error, API failure or a retry 
error that causes a credit card to be 
charged twice.
Using the transactions table, identify 
any payments made at the same merchant 
with the same credit card for the same 
amount within 10 minutes of each other. 
Count such repeated payments.

Assumptions:
● The first transaction of such payments 
should not be counted as a repeated 
payment. This means, if there are two 
transactions performed by a merchant 
with the same credit card and for the 
same amount within 10 minutes, there 
will only be 1 repeated payment.*/
select count(distinct merchant_id) as payment_count
from
(select *, 
lag(transaction_timestamp) 
	over(partition by merchant_id, credit_card_id, amount 
		 order by transaction_timestamp asc) as g,
(TIMESTAMPDIFF(SECOND,
                LAG(transaction_timestamp) 
					OVER (PARTITION BY merchant_id, credit_card_id, amount 
						  ORDER BY transaction_timestamp asc),
                transaction_timestamp)/60.0) AS diff
from Q86_transactions) t
where t.diff <= 10;

create table if not exists Q86_transactions
(
    transaction_id int,
    merchant_id int,
    credit_card_id int,
    amount int,
    transaction_timestamp datetime
);

insert into Q86_transactions (transaction_id, merchant_id, credit_card_id, amount, transaction_timestamp)
values
(1, 101, 1, 100, '2022-09-25 12:00:00'),
(2, 101, 1, 100, '2022-09-25 12:08:00'),
(3, 101, 1, 100, '2022-09-25 12:28:00'),
(4, 102, 2, 300, '2022-09-25 12:00:00'),
(6, 102, 2, 400, '2022-09-25 14:00:00');

-- Q87: 
/*DoorDash's Growth Team is trying to 
make sure new users (those who are 
making orders in their first 14 days) 
have a great experience on all their 
orders in their 2 weeks on the platform.
Unfortunately, many deliveries are 
being messed up because:
● the orders are being completed incorrectly 
(missing items, wrong order, etc.)
● the orders aren't being received (wrong 
address, wrong drop off spot)
● the orders are being delivered late (the 
actual delivery time is 30 minutes later 
than when the order was placed). Note that 
the estimated_delivery_timestamp is 
automatically set to 30 minutes after the 
order_timestamp.

Write a query to find the bad experience 
rate in the first 14 days for new users 
who signed up in June 2022. Output the 
percentage of bad experience rounded to 
2 decimal places.*/
with y1 as 
(select count(*) as g
from
(select 
  o.customer_id,
  o.status,
  o.order_timestamp,
  c.signup_timestamp,
  (TIMESTAMPDIFF(SECOND, o.order_timestamp, c.signup_timestamp)/86400.0) AS diff
from Q87_orders o
join Q87_customers c on o.customer_id = c.customer_id
where year(c.signup_timestamp) = 2022 and month(c.signup_timestamp) = 6) T
where abs(T.diff) <=14 and (T.status = 'completed_incorrectly' or T.status = 'never_received')), 
y2 as 
(select count(*) as g
from
(select 
  o.customer_id,
  o.status,
  o.order_timestamp,
  c.signup_timestamp,
  (TIMESTAMPDIFF(SECOND, o.order_timestamp, c.signup_timestamp)/86400.0) AS diff
from Q87_orders o
join Q87_customers c on o.customer_id = c.customer_id
where year(c.signup_timestamp) = 2022 and month(c.signup_timestamp) = 6) T)

SELECT round(y1.g*100/y2.g, 2) AS bad_experience_pct
FROM y1,y2;

create table if not exists Q87_orders
(
    order_id int,
    customer_id int,
    trip_id int,
    status enum('completed_successfully', 'completed_incorrectly', 'never_received'),
    order_timestamp timestamp
);

create table if not exists Q87_trips
(
    dasher_id int,
    trip_id int,
    estimated_delivery_timestamp timestamp,
    actual_delivery_timestamp timestamp
);

create table if not exists Q87_customers
(
    customer_id int,
	signup_timestamp timestamp
);

insert into Q87_orders (order_id, customer_id, trip_id, status, order_timestamp)
values
(727424, 8472, 100463, 'completed successfully', '2022-06-05 09:12:00'),
(242513, 2341, 100482, 'completed incorrectly', '2022-06-05 14:40:00'),
(141367, 1314, 100362, 'completed incorrectly', '2022-06-07 15:03:00'),
(582193, 5421, 100657, 'never_received', '2022-07-07 15:22:00'),
(253613, 1314, 100213, 'completed successfully', '2022-06-12 13:43:00');

insert into Q87_trips (dasher_id, trip_id, estimated_delivery_timestamp, actual_delivery_timestamp)
values
(101, 100463, '2022-06-05 09:42:00', '2022-06-05 09:38:00'),
(102, 100482, '2022-06-05 15:10:00', '2022-06-05 15:46:00'),
(101, 100362, '2022-06-07 15:33:00', '2022-06-07 16:45:00'),
(102, 100657, '2022-07-07 15:52:00', NULL),
(103, 100213, '2022-06-12 14:13:00', '2022-06-12 14:10:00');

insert into Q87_customers (customer_id, signup_timestamp)
values
(8472, '2022-05-30 00:00:00'),
(2341, '2022-06-01 00:00:00'),
(1314, '2022-06-03 00:00:00'),
(1435, '2022-06-05 00:00:00'),
(5421, '2022-06-07 00:00:00');

-- Q88: 
/*Write an SQL query to find the 
total score for each gender on each 
day.
Return the result table ordered by 
gender and day in ascending order.*/
select gender, 
	   day, 
	   sum(score_points) over(partition by gender order by day asc) as total 
from Q68_Scores;

-- Q89: 
/*A telecommunications company wants 
to invest in new countries. The company 
intends to invest in the countries where 
the average call duration of the calls 
in this country is strictly greater than 
the global average call duration.
Write an SQL query to find the countries 
where this company can invest.
Return the result table in any order.*/
with t1 as 
(select t.usuario, sum(t.duration) as total_call_duration
from
(select caller_id as usuario, duration from Q55_Calls
union all
select callee_id as usuario, duration from Q55_Calls) t
group by t.usuario),
t2 as 
(select  t1.usuario, 
		t1.total_call_duration, 
        CAST(SUBSTRING_INDEX(y2.phone_number, '-', 1) AS UNSIGNED) as code_country
from t1 
join Q55_Person y2 
on t1.usuario = y2.id),
t3 as 
(select u2.name, sum(t2.total_call_duration) as duration_call_per_country
from t2
join Q55_Country u2
on t2.code_country = u2.country_code
group by u2.name), 
t4 as 
(select avg(t3.duration_call_per_country) as average_duration
from t3)

SELECT t3.name as country
FROM t3, t4
WHERE t3.duration_call_per_country > t4.average_duration;

-- Q90: 
/*The median is the value separating 
the higher half from the lower half 
of a data sample.
Write an SQL query to report the 
median of all the numbers in the 
database after decompressing the
Numbers table. Round the median to 
one decimal point.*/
with recursive Q90_Numbers_descompressed as
(
	select num, 1 as contador
    from Q90_Numbers
    where frequency > 0
    
    union all
    
    select t1.num, t1.contador+1
    from Q90_Numbers_descompressed t1
    join Q90_Numbers t2
    on t1.num = t2.num
    where t1.contador+1 <= t2.frequency
),
Q90_Numbers_descompressed_ordened as 
(select *, row_number() over(order by num) as enumeracion
from Q90_Numbers_descompressed
order by num asc, contador asc),
total_nums as 
(select count(*) as total
from Q90_Numbers_descompressed_ordened)

SELECT ROUND
	  (CASE 
		WHEN mod(total, 2) = 1 THEN (select num from Q90_Numbers_descompressed_ordened where enumeracion = (total+1)/2)
		WHEN mod(total,2) = 0 THEN (select avg(num) from Q90_Numbers_descompressed_ordened where enumeracion in (total/2, (total/2)+1))
	   END, 0) as median
FROM total_nums;

create table if not exists Q90_Numbers
(
    num int primary key,
	frequency int
);

insert into Q90_Numbers (num, frequency)
values
(0, 7),
(1, 1),
(2, 3),
(3, 1);

-- Q91: 
/*Write an SQL query to report the 
comparison result (higher/lower/same) 
of the average salary of employees in 
a department to the company's average 
salary.
Return the result table in any order.*/
with Q91_Employee_join_Q91_Salary as 
(select t2.department_id, t1.pay_date, t1.amount
from Q91_Salary t1 
join Q91_Employee t2
on t1.employee_id = t2.employee_id),
promedio_por_mes as
(select DATE_FORMAT(pay_date, '%Y-%m') AS pay_month, avg(amount) as prom
from Q91_Employee_join_Q91_Salary
group by DATE_FORMAT(pay_date, '%Y-%m')),
promedio_por_mes_departamento as 
(select DATE_FORMAT(pay_date, '%Y-%m') AS pay_month, department_id, avg(amount) as h
from Q91_Employee_join_Q91_Salary
group by DATE_FORMAT(pay_date, '%Y-%m'), department_id)

SELECT  promedio_por_mes_departamento.pay_month, 
		promedio_por_mes_departamento.department_id,
        case when promedio_por_mes_departamento.h < promedio_por_mes.prom then 'lower'
			 when promedio_por_mes_departamento.h = promedio_por_mes.prom then 'same'
             else 'higher'
		end as comparison
FROM promedio_por_mes_departamento
JOIN promedio_por_mes
ON promedio_por_mes_departamento.pay_month = promedio_por_mes.pay_month
ORDER BY 
promedio_por_mes_departamento.department_id asc, 
promedio_por_mes_departamento.pay_month asc;

create table if not exists Q91_Employee
(
    employee_id int primary key,
	department_id int
);

create table if not exists Q91_Salary
(
    id int primary key,
	employee_id int,
    amount int,
    pay_date date,
    foreign key(employee_id) references Q91_Employee(employee_id)
);

insert into Q91_Employee (employee_id, department_id) 
values
(1, 1),
(2, 2),
(3, 2);

insert into Q91_Salary (id, employee_id, amount, pay_date) 
values
(1, 1, 9000, '2017-03-31'),
(2, 2, 6000, '2017-03-31'),
(3, 3, 10000, '2017-03-31'),
(4, 1, 7000, '2017-02-28'),
(5, 2, 6000, '2017-02-28'),
(6, 3, 8000, '2017-02-28');

-- Q92: 
/*The install date of a player is the 
first login day of that player.
We define day one retention of some 
date x to be the number of players 
whose install date is x and they logged 
back in on the day right after x, 
divided by the number of players whose 
install date is x, rounded to 2 decimal 
places.
Write an SQL query to report for each 
install date, the number of players that 
installed the game on that day, and the 
day one retention.
Return the result table in any order.*/
with t1 as 
(select t.player_id, t.event_date as install_date
from
(select *, row_number() over (partition by player_id) as t
from Q24_Activity) t
where t.t = 1),

t2 as
(select t1.install_date, count(distinct player_id) as total_players_per_install_date
from t1
group by t1.install_date),

t3 as 
(select y1.player_id, t1.install_date
from Q24_Activity y1
join t1
on y1.player_id = t1.player_id
where datediff(y1.event_date, t1.install_date)=1),

t4 as 
(select t3.install_date, count(*) as total_players_retained_per_install_date
from t3
group by t3.install_date)

select  t2.install_date as install_dt, 
		t2.total_players_per_install_date as installs, 
		round(coalesce((t4.total_players_retained_per_install_date / t2.total_players_per_install_date), 0), 1) as Day1_retention
from t2
left join t4
on t2.install_date = t4.install_date;

-- Q93: 
/*The winner in each group is the 
player who scored the maximum total 
points within the group. In the
case of a tie, the lowest player_id 
wins.
Write an SQL query to find the winner 
in each group.
Return the result table in any order.*/
with t1 as 
(select first_player as player, first_score as score 
from Q50_Matches

union all

select second_player as player, second_score as score 
from Q50_Matches),

t2 as 
(select Q50_Players.group_id, t1.player, t1.score
from t1 
join Q50_Players 
on t1.player = Q50_Players.player_id),

t3 as 
(select group_id, player, sum(score) as score
from t2 
group by group_id, player
order by group_id desc, score desc, player asc)

select t.group_id, t.player as player_id
from
(select *, row_number() over(partition by group_id order by score desc, player asc) as orden
from t3) t
where t.orden = 1;

-- Q94: 
/*A quiet student is the one who took at 
least one exam and did not score the high 
or the low score.
Write an SQL query to report the students 
(student_id, student_name) being quiet in 
all exams. Do not
return the student who has never taken any 
exam.
Return the result table ordered by 
student_id.*/
with t1 as 
(select 	*, 
		min(score) over(partition by exam_id) as min,
		max(score) over(partition by exam_id) as max 
from Q94_Exam
order by exam_id asc, score asc, student_id asc),

t2 as 
(select distinct student_id 
from t1 
where score = min or score = max),

t3 as 
(select distinct student_id  
from t1
where t1.student_id not in (select student_id from t2))

select t3.student_id, Q94_Student.student_name
from t3 
join Q94_Student
on t3.student_id = Q94_Student.student_id;

create table if not exists Q94_Student
(
    student_id int primary key,
	student_name varchar(15)
);

create table if not exists Q94_Exam
(
    exam_id int,
	student_id int,
    score int,
    primary key(exam_id, student_id)
);

insert into Q94_Student (student_id, student_name)
values
(1, 'Daniel'),
(2, 'Jade'),
(3, 'Stella'),
(4, 'Jonathan'),
(5, 'Will');

insert into Q94_Exam (exam_id, student_id, score)
values
(10, 1, 70),
(10, 2, 80),
(10, 3, 90),
(20, 1, 80),
(30, 1, 70),
(30, 3, 80),
(30, 4, 90),
(40, 1, 60),
(40, 2, 70),
(40, 4, 80);

-- Q95: 
/*A quiet student is the one who took at 
least one exam and did not score the high 
or the low score.
Write an SQL query to report the students 
(student_id, student_name) being quiet in 
all exams. Do not
return the student who has never taken any 
exam.
Return the result table ordered by 
student_id.*/
with min as 
(select exam_id, min(score) as min 
from Q94_Exam
group by exam_id),

max as 
(select exam_id, max(score) as max
from Q94_Exam
group by exam_id),

students_mins as
(select distinct student_id
from Q94_Exam
join min
on Q94_Exam.exam_id = min.exam_id and Q94_Exam.score = min.min), 

students_maxs as
(select distinct student_id
from Q94_Exam
join max
on Q94_Exam.exam_id = max.exam_id and Q94_Exam.score = max.max),

all_students_mins_maxs as
(select distinct student_id
from (select student_id from students_mins 
	  union 
      select student_id from students_maxs) t), 
      
all_students_exams as
(select distinct student_id 
from Q94_Exam)
      
select * 
from Q94_Student 
where 	student_id not in (select student_id from all_students_mins_maxs)
		and student_id in (select student_id from all_students_exams);

-- Q96: 
/*You're given two tables on Spotify users' 
streaming data. songs_history table contains 
the historical streaming data and songs_weekly 
table contains the current week's streaming data.
Write a query to output the user id, song id, 
and cumulative count of song plays as of 
4 August 2022 sorted in descending order.
Definitions:
● song_weekly table currently holds data from 
1 August 2022 to 7 August 2022.
● songs_history table currently holds data up 
to to 31 July 2022. The output should include 
the historical data in this table.
Assumption:
● There may be a new user or song in the 
songs_weekly table not present in the 
songs_history table.*/
with t1 as 
(select song_id, user_id, count(*) as song_plays
from Q96_songs_weekly
group by song_id, user_id

union all 

select song_id, user_id, song_plays
from Q96_songs_history),

t2 as 
(select user_id, song_id, sum(song_plays) as song_plays
from t1
group by user_id, song_id),

t3 as 
(select t1.user_id, t1.song_id 
from Q96_songs_history t1
join Q96_songs_weekly t2
on t1.song_id = t2.song_id
and t1.user_id = t2.user_id

union all
select t2.user_id, t2.song_id
from Q96_songs_history t1
right join Q96_songs_weekly t2
on t1.user_id = t2.user_id
where t1.user_id is null)

select t2.*
from t2 
join t3
on t2.user_id = t3.user_id
and t2.song_id = t3.song_id;


create table if not exists Q96_songs_history
(
    history_id int,
	user_id int,
    song_id int,
    song_plays int
);

create table if not exists Q96_songs_weekly
(
    user_id int,
	song_id int,
    listen_time datetime
);

insert into Q96_songs_history (history_id, user_id, song_id, song_plays)
values
(10011, 777, 1238, 11),
(12452, 695, 4520, 1);

insert into Q96_songs_weekly (user_id, song_id, listen_time)
values
(777, 1238, '2022-08-01 12:00:00'),
(695, 4520, '2022-08-04 08:00:00'),
(125, 9630, '2022-08-04 16:00:00'),
(695, 9852, '2022-08-07 12:00:00');

-- Q97: 
/*New TikTok users sign up with their emails, 
so each signup requires a text confirmation 
to activate the new user's account.
Write a query to find the confirmation rate 
of users who confirmed their signups with 
text messages.
Round the result to 2 decimal places.
Hint- Use Joins
Assumptions:
● A user may fail to confirm several times 
with text. Once the signup is confirmed for 
a user, they will not be able to initiate 
the signup again.
● A user may not initiate the signup 
confirmation process at all.*/
select * from Q97_emails;
select * from Q97_texts;

select * 
from Q97_emails t1
join Q97_texts t2
on t1.email_id = t2.email_id;

create table if not exists Q97_emails
(
    email_id int,
	user_id int,
    signup_date datetime
);

create table if not exists Q97_texts
(
    text_id int,
	email_id int,
    signup_action enum('Confirmed', 'Not_Confirmed')
);

insert into Q97_emails (email_id, user_id, signup_date)
values
(125, 7771, '2022-06-14 00:00:00'),
(236, 6950, '2022-07-01 00:00:00'),
(433, 1052, '2022-07-09 00:00:00');

insert into Q97_texts (text_id, email_id, signup_action)
values
(6878, 125, 'Confirmed'),
(6920, 236, 'Not_Confirmed'),
(6994, 236, 'Confirmed');






































