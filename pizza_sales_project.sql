create database pizzahut 
use pizzahut 

--Qns 1 . Retrieve the total number of order placed .


select COUNT(order_id) as total_orders   from orders ; 

-- Qns 2 . Calculate the total revenue generated from  pizza sales ?


select round (sum(order_details.quantity * pizzas.price ),2) as total_revenue  from order_details inner join pizzas on 
pizzas.pizza_id =order_details.pizza_id 


--Qns 3. Identify the highest priced pizza ?

select top 1 pizza_types.name , pizzas.price from pizza_types join pizzas on 
pizza_types.pizza_type_id = pizzas.pizza_type_id 
order by price desc 


-- Qns 4 . Identify the most pizza size ordered ?

select top 1 pizzas.size , sum(order_details.quantity) as order_count 
from pizzas join order_details on pizzas. pizza_id = order_details.pizza_id 
group by size  order by order_count desc 


--Qns 5. List the top 5 most ordered pizza types along with their quantities ?

select top 5  pt.name , sum(od.quantity) as Quantity from pizza_types as  pt 
join  pizzas as p  on pt.pizza_type_id = p.pizza_type_id 
join order_details as  od on od.pizza_id = p.pizza_id 
group by pt.name order by Quantity desc    ;

-- Qns 6 . Join the necessary  tables  to find the total quantity of each pizza category ordered ?

select pizza_types.category, SUM(  order_details.quantity ) as Quantity from pizza_types 
join  pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category order by Quantity desc ;


--Qns 7. Determine the distribution of orders by hour of the day ? 

select   DATEPART (hour, order_time) as Hour_time , COUNT (order_id) as  order_count  from orders 
group by  DATEPART (hour, order_time) 
order by order_time


-- Qns 8 . Join relevent tables to find the category-wise distribution of pizzas ?

select category, count(name) as distribution_pizzas from pizza_types
group by category



-- Qns 9 . Group the order by date and calculate the average number of pizzas ordered by per day ?


select AVG(sum_perday) as avg_pizza_order_perday from 
(select orders.order_date , sum(order_details.quantity) sum_perday from orders join order_details 
on orders.order_id= order_details.order_id group by orders.order_date )d 
 

--Qns 10. Determine the top 3 most ordered pizza types based on revenue ?

select top 3  pizza_types.name , sum (order_details.quantity * pizzas.price) as revenue from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name 
order by revenue desc ;

-- Qns11 . Calculate the percentage contribution of each pizza type to total revenue ?


select  pizza_types.category , round ( sum (order_details.quantity * pizzas.price) / 
(select ROUND (sum ( order_details.quantity * pizzas.price ) ,2 ) as total_sales 
from order_details 
join pizzas on pizzas.pizza_id=order_details.pizza_id) * 100 ,2) as revenue_percentage 

from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category 
order by  revenue_percentage  desc ;
 

--Qns 12 . Analyze the comulative revenue generated  over time ?

select order_date ,round( sum (Revenue ) over (order by order_date),2) as cum_revenue from 
(select orders.order_date , SUM (order_details.quantity * pizzas.price )as Revenue 
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id join orders 
on orders.order_id = order_details.order_id
group by orders.order_date ) sales 
 

--Qns 13. Determine the top 3 most ordered pizza type based on revenue for each pizza category ?

select category, name ,  revenue   from 
(select category , name, revenue , rank() over (partition by category order by revenue desc ) rnk from 
(select pizza_types.category , pizza_types.name ,sum (order_details.quantity * pizzas.price ) as revenue  from 
pizza_types  join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details  on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category ,pizza_types.name) as a ) b  
where rnk <=3 



select *from pizzas
select *from pizza_types
select *from orders
select *from order_details

