-- ------------------------------------ SQL PROJECT ONLINE BOOKSTORE  --------------------------------------------
CREATE database onlinebookstore;
use onlinebookstore;

-- create  table
Drop table if exists books;
create table books (
Book_id serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price Numeric(10 , 2),
Stock int
);
Drop table if exists customers;
create table customers (
Customer_id serial primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(50),
City varchar(50),
Country varchar(150)
);
Drop table if exists orders;
create table orders (
 Order_id serial primary key,
 Customer_id  int references customers(Customer_id),
 Book_id  int references books(Book_id),
 Order_Date date,
 Quantity int,
 Total_Amount numeric(10,2)
 );
 
select * from books;

select * from customers;

select * from orders;

-- QUESTIONS

-- 1) Retrieve all books in the "Fiction" genre
select * from books where genre = "Fiction";

-- 2) Find books published after the year 1950
select * from books where Published_year > 1950; 
 
-- 3) List all customers from the Canada
select * from customers where Country = 'Canada';

-- 4) Show orders placed in November 2023
select * from orders where Order_Date between '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
select sum(stock) as total_stock from books;

-- 6) Find the details of the most expensive book
select * from books  order by Price Desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
select * from orders where quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $200
select * from orders where Total_amount > 200;

-- 9) List all genres available in the Books table
select distinct genre from books;

-- 10) Find the book with the lowest stock
select * from books order by stock  limit 1;

-- 11) Calculate the total revenue generated from all orders
select sum(total_amount) as revenue from orders;

-- Advance Queries
-- 1) Retrieve the total number of books sold for each genre

select b.genre ,SUM(o.Quantity ) AS TOTAL_BOOK_SOLD
from orders o
join Books b on o.book_id = b.book_id
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre

select AVG(Price) as avrage_price
from books
where Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders
select o.customer_id , c.name ,count(o.Order_id) as order_count
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(o.Order_id)  > 2;

-- 4) Find the most frequently ordered book
select o.book_id,b.title,count(o.order_id) as order_count
from orders o
join books b on o.book_id = b.book_id
group by o.book_id ,b.title
order by order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
select * from books
where Genre = 'Fantasy' order by price desc limit 3 ;

-- 6) Retrieve the total quantity of books sold by each author
select b.author, sum(o.quantity) as total_books_sold
from orders o 
join books b on  o.book_id = b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located
select distinct c.city , total_amount
from orders o 
join customers c on c.customer_id = o.customer_id
where o.total_amount > 30;

-- 8) Find the customer who spent the most on orders
select c.customer_id , c.name ,sum( o.total_amount) as total_spent
from orders o 
join customers c on c.customer_id = o.customer_id
group by c.customer_id , c.name 
order by total_spent desc limit 1 ;

-- 9) Calculate the stock remaining after fulfilling all orders
select b.book_id , b.title , b.stock , coalesce(sum(o.quantity),0) as order_quantity,
 b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b 
left join orders o on b.book_id = o.book_id
group by b.book_id  order by b.book_id ;