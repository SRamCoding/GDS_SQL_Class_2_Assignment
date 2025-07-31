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
    SELECT SUM(amount)
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






































