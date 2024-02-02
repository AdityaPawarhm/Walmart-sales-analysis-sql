--I have imported flat file and remaned it as supermarketsalesdata
select * from dbo.SupermarketSalesData

Alter Table dbo.SupermarketSalesData
Alter Column  Unit_price decimal(10,2) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column Tax_5 decimal (6,4) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [Total] [decimal] (15,4) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [Date] [Date] NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [Time] [TIME] NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [COGS] [decimal] (10,2) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [gross_margin_percentage][decimal](10,9) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [gross_margin_percentage][decimal](10,9) NOT NULL;

Alter Table dbo.SupermarketSalesData
Alter Column [gross_income] [decimal](10,4) NOT NULL;


UPDATE dbo.SupermarketSalesData
SET Rating = ROUND(Rating, 2)

---Feature Engineering
--time of day
Select Time from dbo.SupermarketSalesData

Select Time ,
(Case 
When Time Between '00:00:00' AND '12:00:00' Then 'Morning'
When Time Between '12:01:00' AND '16:00:00' Then 'Afternoon'
Else 'Evening' 
END) as time_of_date
from dbo.SupermarketSalesData;

Alter Table dbo.SupermarketSalesData 
Add [time_of_day] [varchar] (20); 

select * from dbo.SupermarketSalesData 
Update dbo.SupermarketSalesData
SET time_of_day=(Case 
When Time Between '00:00:00' AND '12:00:00' Then 'Morning'
When Time Between '12:01:00' AND '16:00:00' Then 'Afternoon'
Else 'Evening' 
END);

--day name
select Date,
DATENAME (WEEKDAY, Date) AS day_of_week
from dbo.SupermarketSalesData;

Alter Table dbo.SupermarketSalesData 
Add [day_name] [varchar] (20); 

Update dbo.SupermarketSalesData
SET day_name=DATENAME (WEEKDAY, Date);



--month name
select Date,
DATENAME (MONTH, Date) AS day_of_week
from dbo.SupermarketSalesData;

Alter Table dbo.SupermarketSalesData 
Add [month_name] [varchar] (20); 

Update dbo.SupermarketSalesData
SET month_name=DATENAME (MONTH, Date);

select * from dbo.SupermarketSalesData


--Generic Question
--1-How many unique cities does the data have?
select Distinct(City) from dbo.SupermarketSalesData
--There are 3 dictinct cities- Mandalay,Yangon,Naypyitaw

--2-In which city is each branch?
select * from dbo.SupermarketSalesData
select Distinct City,Branch from dbo.SupermarketSalesData
--Naypyitaw has branch C,Yangon has branch A,Mandalay has branch B

--Product
select * from dbo.SupermarketSalesData

--1-How many unique product lines does the data have?
select distinct(Product_line)  from dbo.SupermarketSalesData
--six distinct product lines Electronic accessories,Fashion accessories,Food and beverages,
--Health and beauty,Home and lifestyle,Sports and travel
--if we need only number of count
select Count(distinct(Product_line))  from dbo.SupermarketSalesData
--2-What is the most common payment method?

select * from dbo.SupermarketSalesData
select Payment,Count(Payment) as CNT from dbo.SupermarketSalesData 
group by Payment
order by CNT desc;
--Ewallet is most common payment method
--3-What is the most selling product line?
select * from dbo.SupermarketSalesData
select Top 1 Product_line,Count(Product_line) PCNT from dbo.SupermarketSalesData
group by Product_line
Order by PCNT desc

--Fashion accessories is most selling product line


--4-What is the total revenue by month?
select * from dbo.SupermarketSalesData
select month_name,Sum(Total) as Revenue from dbo.SupermarketSalesData
group by month_name
order by Revenue desc;
--5-What month had the largest COGS?
select * from dbo.SupermarketSalesData
select month_name,Sum(cogs) as Ctotal from dbo.SupermarketSalesData
group by month_name
order by Ctotal desc;

--if we want the top value then 
select Top 1 month_name,Sum(cogs) as Ctotal from dbo.SupermarketSalesData
group by month_name
order by Ctotal;

--6-What product line had the largest revenue?
select * from dbo.SupermarketSalesData
select Top 1 Product_line, Sum(Total) Revenue from dbo.SupermarketSalesData
Group by Product_line
Order by Revenue desc;

--7-What is the city with the largest revenue?
select Top 1 City, Sum(Total) Revenue from dbo.SupermarketSalesData
Group by City
Order by Revenue desc;

--8-What product line had the largest VAT?
select * from dbo.SupermarketSalesData
select Top 1 Product_line, Sum(Tax_5) VAT from dbo.SupermarketSalesData
Group by Product_line
Order by VAT desc;

--9-Fetch each product line and add a column to those product line 
--showing "Good", "Bad". Good if its greater than average sales
select * from dbo.SupermarketSalesData
select distinct Product_line,
(Case 
When sum(Total)> AVG(Total) then 'Good'
Else 'Bad'
END) PD
from dbo.SupermarketSalesData
group by Product_line
--10-Which branch sold more products than average product sold?
select * from dbo.SupermarketSalesData
select Branch,sum(Quantity) as QTY from dbo.SupermarketSalesData
group by Branch
Having Sum(Quantity)> AVG(Quantity);

--11-What is the most common product line by gender?
select * from dbo.SupermarketSalesData
select Gender, Product_line, count (Gender) as Tcount from dbo.SupermarketSalesData
group by Gender, Product_line
order by Tcount desc;

--12-What is the average rating of each product line?
select  Product_line, Round(AVG (Rating),2) as AVGR from dbo.SupermarketSalesData
group by Product_line
order by AVGR desc;

-----Sales-----
--1-Number of sales made in each time of the day per weekday
select * from dbo.SupermarketSalesData

--Which of the customer types brings the most revenue?
select Customer_type, SUM(Total) as Revenue from dbo.SupermarketSalesData
group by Customer_type
order by Revenue desc;
--Which city has the largest tax percent/ VAT (Value Added Tax)?
select * from dbo.SupermarketSalesData

select city, AVG(Tax_5) as VAT from dbo.SupermarketSalesData
group by City
Order by VAT desc;
--Which customer type pays the most in VAT?
select Customer_type, AVG(Tax_5) as VAT from dbo.SupermarketSalesData
group by Customer_type
Order by VAT desc;

-------Customer----
--1-How many unique customer types does the data have?

select Distinct (Customer_type) from dbo.SupermarketSalesData
--2-How many unique payment methods does the data have?
select Distinct (Payment ) from dbo.SupermarketSalesData

--3-What is the most common customer type?
select Customer_type, count (Customer_type) from dbo.SupermarketSalesData
group by Customer_type

--4-Which customer type buys the most?
select Customer_type, sum (Total) from dbo.SupermarketSalesData
group by Customer_type

--5-What is the gender of most of the customers?
select  Gender,count(Gender) CG from dbo.SupermarketSalesData
group by Gender
order by CG desc

--6-What is the gender distribution per branch?
select Branch, Gender,count(Gender) CG from dbo.SupermarketSalesData
group by Gender, Branch
order by Branch

--7-Which time of the day do customers give most ratings?
select * from dbo.SupermarketSalesData
select AVG (Rating) RC,time_of_day from dbo.SupermarketSalesData
group by time_of_day
order by RC desc;
--8-Which time of the day do customers give most ratings per branch?
select  Branch,time_of_day, AVG (Rating) RC from dbo.SupermarketSalesData
group by Branch, time_of_day
order by RC desc;

--9-Which day of the week has the best avg ratings?
select  day_name, Round(AVG (Rating),2) AR from dbo.SupermarketSalesData
group by day_name
order by AR desc

--10-Which day of the week has the best average ratings per branch?
select  Branch,day_name, Round(AVG (Rating),2) AR from dbo.SupermarketSalesData
group by Branch, day_name
order by day_name,AR desc

