select * from Restaurants

select * from Orders

-- Which restaurant received most sales?
SELECT top 1 Restaurants.RestaurantName, sum(Order_Amount) AS SalesAmount
from Orders
INNER JOIN Restaurants ON
Orders.Restaurant_ID = Restaurants.RestaurantID
group BY Restaurant_ID, Restaurants.RestaurantName
Order by SalesAmount DESC

-- Return the total sales of each restaurants.
SELECT Restaurant_ID, Restaurants.RestaurantName, sum(Order_Amount) AS Amount
from Orders
INNER JOIN Restaurants ON
Orders.Restaurant_ID = Restaurants.RestaurantID
group BY Restaurant_ID, Restaurants.RestaurantName
ORDER BY Amount DESC

-- Which customer ordered the most?

SELECT Customer_Name, sum(Order_Amount) AS Amount
from Orders
GROUP BY Customer_Name
ORDER BY Amount DESC

-- When do customers order more in a day?

select top 1 Order_Date
from Orders

-- Which is the most liked cuisine?

SELECT Restaurants.Cuisine, sum(Quantity_of_Items) AS Orders
from Orders
INNER JOIN Restaurants ON
Orders.Restaurant_ID = Restaurants.RestaurantID
group BY Restaurants.Cuisine
Order by Orders DESC

-- Which zone has the most sales?

SELECT Restaurants.[Zone], sum(Order_Amount) AS Amount
from Orders
INNER JOIN Restaurants ON
Orders.Restaurant_ID = Restaurants.RestaurantID
group BY Restaurants.[Zone]
ORDER BY Amount DESC


