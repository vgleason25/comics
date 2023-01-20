-- spiderman query
USE spiderman; --always start in spiderman
GO

SELECT distinct(sale_currency)
FROM sale_currency
WHERE distinct 

SELECT TOP 10 *
FROM spiderman;


--1) How many listings are there in this database?
SELECT COUNT(*) AS total_listings
FROM spiderman;

--2a) How many have issue information?
--title
SELECT 0 AS [How many have issue information?]
WHERE 1 = 0
--query
SELECT COUNT(*) AS listings_w_issue_num
FROM spiderman
WHERE issue_num IS NOT NULL;

--2b) How many have series information?
--title
SELECT 0 AS [How many have series information?]
WHERE 1 = 0
--query
SELECT COUNT(series) AS has_series_or_series_title
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE series IS NOT NULL OR series_title IS NOT NULL;

--this shows the series infomration
SELECT series, series_title 
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE series IS NOT NULL OR series_title IS NOT NULL;

--2c) How many have issue and series information?
--title
SELECT 0 AS [How many have issue and series information?]
WHERE 1 = 0
--query
SELECT issue_num, series, series_title 
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE issue_num IS NOT NULL AND issue_num != 9999 AND (series IS NOT NULL OR series_title IS NOT NULL);
-- != 9999 removed becasue 9999 indicates a lot of items

--3a) Which series and issue, has the most listings?
--gets Eminem
SELECT COUNT(CONCAT(series_title, ' ', series, ' ', issue_num)) AS series_issue_count, title, issue_num, series_title
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE issue_num IS NOT NULL AND issue_num != 9999 AND (series IS NOT NULL OR series_title IS NOT NULL)
GROUP BY issue_num, series_title, title
ORDER BY series_issue_count DESC

--also gets Eminem
SELECT COUNT(CONCAT(issue_num, ' ', publication_year)) AS issue_pub_yr_count, title, issue_num, publication_year
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE issue_num IS NOT NULL AND issue_num != 9999 AND (series IS NOT NULL OR series_title IS NOT NULL)
GROUP BY title, issue_num, publication_year
ORDER BY issue_pub_yr_count DESC

SELECT COUNT(title) AS titles_w_Eminem
FROM spiderman SP
WHERE title LIKE '%eminem%';

SELECT COUNT(CONCAT(series_title, ' ', series)) AS series_count, issue_num, series_title, series
FROM spiderman SP
LEFT JOIN series S ON SP.seriesID = S.ID
LEFT JOIN series_title ST on SP.series_titleID = ST.ID
WHERE issue_num IS NOT NULL AND issue_num != 9999 AND issue_num != 1 AND (series IS NOT NULL OR series_title IS NOT NULL)
GROUP BY issue_num, series_title, series
ORDER BY series_count DESC

--3b) what are that issues min, max, and average sell price?
--title
SELECT 0 AS [Sale prices WHERE title LIKE "%eminem%"]
WHERE 1 = 0
--query
SELECT MIN (sale_price) AS min_sale_price, MAX(sale_price) AS max_sale_price, AVG(sale_price) AS avg_sale_price
FROM spiderman SP
WHERE title LIKE '%eminem%';

--4) How are most listings sold? (Buy it now, bidding, Best Offer?)
--title
SELECT 0 AS [How are most listings sold? ]
WHERE 1 = 0
--query
SELECT TOP 1 sale_method, count(*) * 100.0 / sum(COUNT(*)) over() AS percent_sold
FROM spiderman S
LEFT JOIN sale_method SM ON SM.ID = S.sale_methodID
GROUP BY sale_method
ORDER BY percent_sold DESC

--5a) What is the 5 highest price paid for a listing?
--title
SELECT 0 AS [What is the 5 highest price paid for a listing?]
WHERE 1 = 0
--query
SELECT TOP 5 title, issue_num, sale_price
FROM spiderman S
LEFT JOIN sale_method SM ON SM.ID = S.sale_methodID
WHERE issue_num != 9999
ORDER BY sale_price DESC

--5b) What are their listing title, publish year, Series, Issue, sell method, sell price?
--title
SELECT 0 AS [What is the listing title, publish year, Series, Issue, sell method, sell price for the 5 highest price paid for a listing?]
WHERE 1 = 0
--query
SELECT TOP 5 title, publication_year, series_title, series, issue_num, sale_method, num_of_bids, sale_price
FROM spiderman SP
LEFT JOIN sale_method SM ON SM.ID = SP.sale_methodID
LEFT JOIN series_title ST ON ST.ID = SP.series_titleID
LEFT JOIN series S ON S.ID = SP.seriesID
WHERE issue_num != 9999
ORDER BY sale_price DESC;

--6a) What is the lowest price paid for a listing?
--title
SELECT 0 AS [What is the listing title, publish year, Series, Issue, sell method, sell price for the 5 lowest price paid for a listing?]
WHERE 1 = 0
--query
SELECT TOP 5 title, publication_year, series_title, series, issue_num, sale_method, num_of_bids, sale_price
FROM spiderman SP
LEFT JOIN sale_method SM ON SM.ID = SP.sale_methodID
LEFT JOIN series_title ST ON ST.ID = SP.series_titleID
LEFT JOIN series S ON S.ID = SP.seriesID
WHERE issue_num != 9999
ORDER BY sale_price ASC;

--6b) How many listings sold for that price?
--title
SELECT 0 AS [How many listings sold for that price?]
WHERE 1 = 0
--query
SELECT TOP 1 COUNT(title) AS num_of_titles, MIN(sale_price) AS min_sale_price
FROM spiderman
GROUP BY sale_price;

--6c) What are their listing title, era, publish year, Series, Issue, sell method, sell price?
--title
SELECT 0 AS [What are their listing title, era, publish year, Series, Issue, sell method, sell price?]
WHERE 1 = 0
--query
SELECT title, era, publication_year, series, series_title, issue_num, sale_method, sale_price
FROM spiderman SM
LEFT JOIN era E ON SM.eraID = E.ID
LEFT JOIN series_title ST ON ST.ID = SM.series_titleID
LEFT JOIN series S ON S.ID = SM.seriesID
LEFT JOIN sale_method SMD ON SMD.ID = SM.sale_methodID
WHERE sale_price = (
    SELECT MIN(sale_price) 
    FROM spiderman)
ORDER BY sale_price ASC

--7) List all the listings min, average, and max price grouped by era.
--title
SELECT 0 AS [List all the listings min, average, and max price grouped by era]
WHERE 1 = 0
--query
SELECT era, MAX(sale_price)-MIN(sale_price) AS sale_price_spread, MIN(sale_price) AS MIN_sale_price, AVG(sale_price) AS avg_sale_price, MAX(sale_price) AS MAX_sale_price
FROM spiderman SM
LEFT JOIN era E on SM.eraID = E.ID
GROUP BY list_order, era
ORDER BY E.list_order;

--8) List all the listings min, average, and max price grouped by sell method.
--title
SELECT 0 AS [List all the listings min, average, and max price grouped by sell method]
WHERE 1 = 0
--query
SELECT sale_method, MAX(sale_price)-MIN(sale_price) AS sale_price_spread, MIN(sale_price) AS MIN_sale_price, AVG(sale_price) AS avg_sale_price, MAX(sale_price) AS MAX_sale_price
FROM spiderman SM
LEFT JOIN era E on SM.eraID = E.ID
LEFT JOIN sale_method S on SM.sale_methodID = S.ID
GROUP BY sale_method;

--9)  Find the average sale price, minimum sale price, and maximum sale price for each era by name and sales method. Use meaningful alias names for the aggregates.
--title
SELECT 0 AS [Find the average sale price, minimum sale price, and maximum sale price for each era by name and sales method]
WHERE 1 = 0
--query
SELECT era, sale_method, MAX(sale_price)-MIN(sale_price) AS sale_price_spread, MIN(sale_price) AS MIN_sale_price, AVG(sale_price) AS avg_sale_price, MAX(sale_price) AS MAX_sale_price
FROM spiderman SM
LEFT JOIN era E on SM.eraID = E.ID
LEFT JOIN sale_method S on SM.sale_methodID = S.ID
GROUP BY list_order, era, sale_method
ORDER BY E.list_order;

--10) What is the most popular publishing year? Store this date in a variable. Find all listings with that publishing year.
--title
SELECT 0 AS [What is the most popular publishing year?]
WHERE 1 = 0
--query
SELECT COUNT(publication_year) AS num_of_listing, publication_year
FROM spiderman 
GROUP BY publication_year
ORDER BY COUNT(publication_year) DESC;