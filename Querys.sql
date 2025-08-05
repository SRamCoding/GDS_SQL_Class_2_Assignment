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
WHERE T.free = 1 AND (T.anterior = 1 OR T.siguiente = 1);

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






















































