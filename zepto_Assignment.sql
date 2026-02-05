SELECT * FROM zepto_project.zepto_v2;

alter table zepto_v2 rename column ï»¿Category to Category;

/* q1 Displya all record from table */
select * from zepto_v2;

/* q2 Show only the name and mrp of all products. */
select mrp, name
from zepto_v2;

/* q3 List all products where Category = 'Fruits & Vegetables'. */
select * from zepto_v2
where Category = 'Fruits & Vegetables';

/* q4 Find products where mrp is greater than 3000 */
select name
from zepto_v2
where mrp > 3000;

/*q5 Show products where discountPercent is 15 */
select Category, name, discountPercent
from zepto_v2
where discountPercent = 15;

/*q6 Display products where outOfStock is FALSE. */
select name, outOfStock
from zepto_v2
where outOfStock = 'FALSE';

/*q7 List the names of products with weightInGms greater than 500. */
select name, weightInGms
from zepto_v2
where weightInGms > 500;

/*q8 Find products where availableQuantity is less than 5. */
select name, availableQuantity
from zepto_v2
where availableQuantity < 5;

/*q9 Show distinct categories available in the table. */
select distinct(Category)
from zepto_v2;

/*q10  Count the total number of products. */
select count(name)
from zepto_v2;

/*q11 Display products sorted by mrp in ascending order. */
select name, mrp
from zepto_v2
order by mrp asc;

/*q12 Display products sorted by discountPercent in descending order. */
select name, discountPercent
from zepto_v2
order by discountPercent desc;

/*q13 Show top 10 most expensive products based on mrp. */
select name, mrp
from zepto_v2
order by mrp desc
limit 10;

/*q14  Find products where name starts with letter ‘T’. */
select name
from zepto_v2
where name like 'T%';

/*q15 Count how many products are out of stock. */
select name, count(outOfStock)
from zepto_v2
group by name;

/*q16 Show products where quantity is greater than 50. */
select name, quantity
from zepto_v2
where quantity > 50;

/*q17 Find products where mrp is between 2000 and 4000. */
select name, mrp
from zepto_v2
where mrp between 2000 and 4000;

/*q18 Display products where discountedSellingPrice is less than 1500. */
select name, discountedSellingPrice
from zepto_v2
where discountedSellingPrice < 1500;

/*q19 List products where weightInGms equals 1000. */
select name, weightInGms
from zepto_v2
where weightInGms = 1000;

/*q20 Show all products whose category contains the word ‘Vegetables’. */
select name, Category
from zepto_v2
where Category = 'Vegetables';

/*q21 Find the maximum mrp in each category. */
select name, max(mrp)
from zepto_v2
group by name;

/*q22 Find the minimum discountedSellingPrice in each category. */
select name, min(discountedSellingPrice)
from zepto_v2
group by name;

/*q23 Count the number of products in each category. */
select count(name), Category
from zepto_v2
group by Category;

/*q24 Calculate the average mrp of all products. */
select name, avg(mrp)
from zepto_v2
group by name;

/*q25 Show total available quantity of products category-wise. */
select Category, sum(quantity)
from zepto_v2
group by Category;

/*q26 Find products where the difference between mrp and discountedSellingPrice is greater than 1000. */
select *
from zepto_v2
where (mrp - discountedSellingPrice) > 1000;

/*q27 Display products with discount greater than the average discount. */
SELECT name AS product,mrp-discountedSellingPrice AS discount
FROM zepto_v2
WHERE mrp-discountedSellingPrice>(SELECT AVG(mrp-discountedSellingPrice) FROM zepto_v2);

/*q28 Show categories having more than 50 products */
select Category, count(name)
from zepto_v2
group by Category
having count(name) > 50;

/*q29  Find top 5 products with highest discount percent. */
select distinct(discountPercent), name
from zepto_v2
order by discountPercent desc
limit 5;

/*q30 Display total inventory weight (weightInGms * availableQuantity) for each product. */
SELECT name AS products,weightInGms*availableQuantity AS invintory_weight
FROM zepto_v2;

/*q31 Find products where discountedSellingPrice is less than 50% of mrp. */
select name
from zepto_v2
where discountedSellingPrice < 0.5 * mrp;

/*q32 Show products whose names contain the word ‘Coconut’. */
select name as product, Category
from zepto_v2
where name like '%Coconut%';

/*q33 Calculate total stock value (discountedSellingPrice * availableQuantity) for each product. */
select name, discountedSellingPrice * availableQuantity as total_stock
from zepto_v2;

/*q34 Display the category with the highest average discount.  */
select Category, avg(discountPercent)
from zepto_v2
group by Category
order by avg(discountPercent) desc
limit 1;

/*q35 Show products where availableQuantity is zero but outOfStock is FALSE (data inconsistency 
check). */
select name, outOfStock,availableQuantity
from zepto_v2
where availableQuantity = 0 and outOfStock = FALSE;

/* q36 Rank products within each category based on mrp.*/
select Category, name, mrp,
rank() OVER (PARTITION BY Category ORDER BY mrp DESC) AS mrp_rank
FROM zepto_v2;

/*q37 Find the second highest mrp product in each category. */
select Category, name, mrp
from (
    select Category, name, mrp,
           dense_rank() over (partition by Category order by mrp desc) as rnk
    from zepto_v2
) t
where rnk = 2;

/*q38 Display cumulative sum of availableQuantity category-wise. */
SELECT Category, name, availableQuantity,
       SUM(availableQuantity) OVER (PARTITION BY Category ORDER BY name) AS cumulative_quantity
FROM zepto_v2;

/*q39 Find products whose mrp is higher than the average mrp of their category.*/
SELECT Category, name, mrp
FROM (
    SELECT Category, name, mrp,
           AVG(mrp) OVER (PARTITION BY Category) AS avg_mrp
    FROM zepto_v2
) t
WHERE mrp > avg_mrp;

/*q40 Identify products where discount percent is above category average discount. */
SELECT Category, name, discountPercent
FROM (
    SELECT Category, name, discountPercent,
           AVG(discountPercent) OVER (PARTITION BY Category) AS avg_discount
    FROM zepto_v2
) t
WHERE discountPercent > avg_discount;

/*q41 Create a view showing only in-stock products with discount greater than 20%. */
CREATE VIEW in_stock_high_discount_products AS
SELECT *
FROM zepto_v2
WHERE outOfStock = FALSE
  AND discountPercent > 20;

/*q42 Write a query to update outOfStock = TRUE where availableQuantity = 0. */
UPDATE zepto_v2
SET outOfStock = 'TRUE'
WHERE availableQuantity = 0;

/*q43  Create a stored procedure to fetch products by category name. */
DELIMITER $$

CREATE PROCEDURE GetProducts_ByCategory(IN cat_name VARCHAR(255))
BEGIN
    SELECT *
    FROM zepto_v2
    WHERE category = cat_name;
END $$

DELIMITER ;
CALL GetProducts_ByCategory('Fruits & Vegetables');

/*q45 Find duplicate product names if any exist. */
SELECT name, COUNT(*)
FROM zepto_v2
GROUP BY name
HAVING COUNT(*) > 1;

/*q46 Show top 3 cheapest products in each category. */
SELECT *
FROM (
    SELECT category, name, mrp,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY mrp ASC) AS price_rank
    FROM zepto_v2
) t
WHERE price_rank <= 3;

/*q47  Find categories where total stock value exceeds 1,00,000. */
SELECT Category
FROM zepto_v2
GROUP BY Category
HAVING SUM(mrp * availableQuantity) > 100000;

/*q48 Create a trigger that sets outOfStock to TRUE when availableQuantity becomes 0. */
DELIMITER $$

CREATE TRIGGER trg_set_outofstock
BEFORE UPDATE ON zepto_v2
FOR EACH ROW
BEGIN
    IF NEW.availableQuantity = 0 THEN
        SET NEW.OutOfStock = TRUE;
    END IF;
END $$

DELIMITER ;

/*q49 Generate a report showing: Category, Total Products, Avg MRP, Avg Discount */
SELECT Category,
       COUNT(name) AS total_products,
       AVG(mrp) AS avg_mrp,
       AVG(discountPercent) AS avg_discount
FROM zepto_v2
GROUP BY Category;

/*q50 Write a query using a subquery to find products with mrp greater than overall average mrp. */
SELECT *
FROM zepto_v2
WHERE mrp > (SELECT AVG(mrp) FROM zepto_v2);
