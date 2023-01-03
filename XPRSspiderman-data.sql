USE spiderman; --always start in spiderman
GO

/*
--   ~~ shows that my skeleton has all the columns it should have --checks out */
        -- SELECT * 
        -- FROM dbo.spiderman L
--         JOIN dbo.condition C 
--             ON L.conditionID = C.ID
--         JOIN dbo.era E
--             ON E.ID = L.eraID
--         JOIN dbo.format F
--             ON F.ID = L.formatID 

--   ~~  create a temporary table in SQL Server: COULD NOT GET THIS TO WORK THE WAY I WANTED. ENDED UP USING IMPORT WIZARD
IF OBJECT_ID(N'tempdb..#tempSpiderman') IS NOT NULL
BEGIN
DROP TABLE #tempSpiderman
END
GO


CREATE TABLE #tempSpiderman
(
    [title] nvarchar(4000) NOT NULL, --bc every item has an title 
    series_title nvarchar(4000) NULL,
    issue_num SMALLINT NULL,
    issue_variant NVARCHAR(4000) NULL,
    image_url NVARCHAR(4000) NULL,
    condition NVARCHAR(4000) NULL,
    grade FLOAT NULL,
    publisher NVARCHAR(4000) NULL,
    publication_year INT NULL,
    format NVARCHAR(4000) NULL,
    tradition NVARCHAR(4000) NULL,
    features NVARCHAR(4000) NULL,
    era NVARCHAR(4000) NULL,
    [type] NVARCHAR(4000) NULL,
    genre NVARCHAR(4000) NULL,
    charater NVARCHAR(4000) NULL,
    series NVARCHAR(4000) NULL,
    universe NVARCHAR(4000) NULL,
    sale_currency NVARCHAR(4000) NULL,
    sale_price FLOAT NOT NULL,
    shipping_price FLOAT NULL,
    sale_method NVARCHAR(4000) NULL,
    num_of_bids TINYINT NULL,
    time_of_sale DATE NULL,
    seller_location NVARCHAR(4000) NULL,
    seller_handle NVARCHAR(4000) NULL,
    sellers_total_sales INT NULL,
    listing_url NVARCHAR(4000) NULL,
);


BULK INSERT #tempSpiderman
FROM "C:\Users\Public\Documents\spiderman20221209R01.csv"
WITH
(
FirstRow = 2,
FORMAT = 'CSV'
);
GO
;
--  -- ~~ shows that my TEMP file has all the data it should have 
        -- SELECT publication_year
        -- FROM #tempSpiderman;

/* =======================================================
CRUD operations to create, read, update and delete data. */
  /* ~~1. Get rid of any sales where the sale price is 0 */
        -- SELECT *
        -- FROM #tempSpiderman
        -- WHERE Sale_Price = 0;
        -- --this returns 1413 rows. Delete these rows

       DELETE FROM #tempSpiderman
       WHERE Sale_Price = 0;

--        SELECT COUNT(*)
--        FROM #tempSpiderman
--        WHERE Sale_Price = 0;
--       --returns 0. SUCCESS

--       --how many are there now?
--        SELECT COUNT(*)
--        FROM #tempSpiderman;
--       --reduced to 8600
--/*==========================================================*/
--    /*   get rid of any  "Not Specified and replace with "NULL"*/
    --    SELECT *
    --    FROM #tempSpiderman
    --    WHERE <some_row> = "Not Specified"


/*~~1A. Will move all distinct Sellers to the Sellers table*/
    
--       SELECT *
--       FROM [seller_handle];

--     /*Confirmed seller_handle table is empty*/



--        SELECT COUNT (DISTINCT Seller_Handle) 
--        FROM #tempSpiderman;
--        --there are 3084 distinct handles
    
 /*   Confirmed this is the data I want
*/


        INSERT INTO [seller_handle]
        SELECT DISTINCT [Seller_Handle]
        FROM #tempSpiderman;

/*  Inserted data into seller_handle table */


        -- SELECT *
        -- FROM seller_handle;

        /*Confirmed move to seller_handle table*/
--/*==========================================================*/
/*~~1B. Will move all distinct conditions to the condition table*/
    
--       SELECT *
--       FROM [condition];

--     --Confirmed condition table is empty



--        SELECT COUNT (DISTINCT Condition) 
--        FROM #tempSpiderman;
-- --       /* --there are 7 distinct conditions
    
--     --Confirmed this is the data I want
-- */


        INSERT INTO [condition]
        SELECT DISTINCT [Condition]
        FROM #tempSpiderman;

-- /*  Inserted data into condition table


        -- SELECT *
        -- FROM condition;

--         Confirmed move to condition table
--/*==========================================================*/
--~~1C. Move all distinct eras to the eras table
    
        /* =======================================================
        First, CRUD operations to create, read, update and delete data. */

        /*~~There are duplicate eras. Reduce them to: 

        Platinum Age (1897-1937)
        Golden Age (1938-1955) 
        Silver Age (1956-1969)
        Bronze Age (1970-1983)
        Copper Age (1984-1991)
        Modern Age (1992-Now)

        -- */
--      ~~GOLDEN
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman;
 
        UPDATE #tempSpiderman
        SET Era = 'Golden Age (1938-1955)'
        WHERE Era LIKE '%Golden%' or Era LIKE '%golden%';
 
--      ~~SILVER
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman 
        -- WHERE Era LIKE 'Silver Age' ;
 
        UPDATE #tempSpiderman
        SET Era = 'Silver Age (1956-1969)'
        WHERE Era LIKE '%Silver%' or Era LIKE '%silver%';

--      ~~Bronze
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman ;

        UPDATE #tempSpiderman
        SET Era = 'Bronze Age (1970-1983)'
        WHERE Era LIKE '%Bronze%' or Era LIKE '%bronze%';
        
--      ~~COPPER
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman ;

 
        UPDATE #tempSpiderman
        SET Era = 'Copper Age (1984-1991)'
        WHERE Era LIKE '%Copper%' or Era LIKE '%copper%';
        
--      ~~MODERN
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman ;

 
        UPDATE #tempSpiderman
        SET Era = 'Modern Age (1992-Now)'
        WHERE Era LIKE '%Modern%' or Era LIKE '%modern%' or Era LIKE '%2000%' or Era LIKE '%2010%' or Era LIKE '%2020%';
        

--      ~~NULL
        -- SELECT DISTINCT Era
        -- FROM #tempSpiderman ;

 
        UPDATE #tempSpiderman
        SET Era = NULL
        WHERE Era LIKE 'Not Specified' ;
        ;

-- THEN fill the era table with them 
--       SELECT *
--       FROM [era];
      

--     Confirmed era table is empty



--        SELECT COUNT (DISTINCT Era) 
--        FROM #tempSpiderman;
--        --there are 5 distinct eras
    
--     Confirmed this is the data I want
-- */


        INSERT INTO [era]
        SELECT DISTINCT era
        FROM #tempSpiderman;

-- /*  Inserted data into era table


        -- SELECT *
        -- FROM [era]
 ;
--         Confirmed move to era table

--want to rearrange them in chronological order

ALTER TABLE era
ADD list_order int;
GO
;

UPDATE era
SET list_order = 1
WHERE Era LIKE 'Platinum Age (1897-1937)' ;

UPDATE era
SET list_order = 2
WHERE Era LIKE 'Golden Age (1938-1955)' ;

UPDATE era
SET list_order = 3
WHERE Era LIKE 'Silver Age (1956-1969)' ;

UPDATE era
SET list_order = 4
WHERE Era LIKE 'Bronze Age (1970-1983)' ;

UPDATE era
SET list_order = 5
WHERE Era LIKE 'Copper Age (1984-1991)' ;

UPDATE era
SET list_order = 6
WHERE Era LIKE 'Modern Age (1992-Now)' ;

UPDATE era
SET list_order = 7
WHERE Era = NULL;
        

-- SELECT *
-- FROM era;
--/*==========================================================*/
-- ~~1D. Move Format to format table
--     Confirmed format table is empty


--       SELECT DISTINCT Format 
--        FROM #tempSpiderman;
-- --        --there are 30 distinct formats
    
--     Confirmed this is the data I want
-- */


        INSERT INTO [format]
        SELECT DISTINCT [Format]
        FROM #tempSpiderman;

-- /*  Inserted data into format table


        -- SELECT *
        -- FROM format;

--         Confirmed move to format table
--/*==========================================================*/
--   ~~1E. move all distinct genres to the genre table
    
--       SELECT *
--       FROM [genre];

--     Confirmed genre table is empty

--        SELECT COUNT (DISTINCT Genre) 
--        FROM #tempSpiderman;
-- --        --there are 231 distinct genres
    
-- --     Confirmed this is the data I want
--        SELECT DISTINCT Genre 
--        FROM #tempSpiderman;
-- --        --these are lists, I am not going to parse them out
-- -- */


        INSERT INTO [genre]
        SELECT DISTINCT [Genre]
        FROM #tempSpiderman;

-- /*  Inserted data into genre table


        -- SELECT *
        -- FROM genre;

--         Confirmed move to genre table
--=============================================================
--   ~~1F. Will move all distinct publishers to the publisher table
    
--       SELECT *
--       FROM [publisher];

--     Confirmed publisher table is empty



--        SELECT COUNT (DISTINCT Publisher) 
--        FROM #tempSpiderman;
-- --        --there are 91 distinct publishers

--        SELECT DISTINCT Publisher 
--        FROM #tempSpiderman;
-- --        --lots of variety, not going to try to clean this up
    
--     Confirmed this is the data I want
-- */


        INSERT INTO [publisher]
        SELECT DISTINCT [Publisher]
        FROM #tempSpiderman;

-- /*  Inserted data into Publisher table


        -- SELECT *
        -- FROM publisher;

--         Confirmed move to publisher table
--/*==========================================================*/
--   ~~1G. Will move all distinct currencies to the currency table
    
--       SELECT *
--       FROM [sale_currency];

-- --     Confirmed sale_currency table is empty



--        SELECT COUNT (DISTINCT sale_currency) 
--        FROM #tempSpiderman;
-- --        --there are 5 distinct currencies    
    
--     Confirmed this is the data I want
-- */


        INSERT INTO [sale_currency]
        SELECT DISTINCT [Sale_Currency]
        FROM #tempSpiderman;

-- /*  Inserted data into Owner table


        -- SELECT *
        -- FROM sale_currency;

--         Confirmed move to sale_currency table
----==========================================================================
--  -- ~~1H. Will move all distinct sale_methods to the sale_method table
        
--         SELECT *
--         FROM sale_method;

-- --         Confirmed sale method table is empty
--   SELECT COUNT (DISTINCT sale_method) 
--        FROM #tempSpiderman;
-- --        --there are 3 distinct sale_method    
    
--     Confirmed this is the data I want
-- */


        INSERT INTO [sale_method]
        SELECT DISTINCT [Sale_Method]
        FROM #tempSpiderman;

-- /*  Inserted data into sale_method table


        -- SELECT *
        -- FROM sale_method;

--         Confirmed move to sale_method table


----==========================================================================
--  -- ~~1I. Will move all distinct seller_location to the seller_location table
        
--         SELECT *
--         FROM seller_location;

-- --         Confirmed seller_location table is empty

--   SELECT DISTINCT seller_location
--        FROM #tempSpiderman;
-- --        --there are 1989 distinct seller_locations    
    
-- --     Confirmed this is the data I want
-- */


        INSERT INTO seller_location
        SELECT DISTINCT seller_location
        FROM #tempSpiderman;

-- /*  Inserted data into seller_location table


        -- SELECT *
        -- FROM seller_location;

--         Confirmed move to seller_location table
----==========================================================================
--  -- ~~1J. Will move all distinct series to the series table
        
--         SELECT *
--         FROM series;

-- --         Confirmed series table is empty
--   SELECT COUNT (DISTINCT series) 
--        FROM #tempSpiderman;
-- --        --there are 160 distinct series 
    
-- --     Confirmed this is the data I want
-- -- */


        INSERT INTO [series]
        SELECT DISTINCT [Series]
        FROM #tempSpiderman;

-- /*  Inserted data into series table


--         SELECT *
--         FROM series;

-- --         Confirmed move to series table
-- ----==========================================================================
-- --  -- ~~1K. Will move all distinct series_title to the series_title table
        
--         SELECT *
--         FROM series_title
-- ;
-- --         Confirmed sale series_title table is empty
--   SELECT COUNT (DISTINCT series_title) 
--        FROM #tempSpiderman;
-- --        --there are 3 distinct series_title    
    
-- --     Confirmed this is the data I want
-- -- */


        INSERT INTO [series_title]
        SELECT DISTINCT [Series_Title]
        FROM #tempSpiderman;

-- /*  Inserted data into series_title table


--         SELECT *
--         FROM series_title;

-- --         Confirmed move to series_title table
-- ----==========================================================================
-- --  -- ~~1L. Will move all distinct tradition to the tradition table
        
--         SELECT *
--         FROM tradition;

-- --         Confirmed tradition table is empty
--   SELECT COUNT (DISTINCT tradition) 
--        FROM #tempSpiderman;
-- --        --there are 9 distinct tradition    

-- --     Confirmed this is the data I want
-- */


        INSERT INTO [tradition]
        SELECT DISTINCT [Tradition]
        FROM #tempSpiderman;

-- /*  Inserted data into tradition table


--         SELECT *
--         FROM tradition;

-- --         Confirmed move to tradition table

-- ----==========================================================================
-- --  -- ~~1M. Will move all distinct type to the type table
        
--         SELECT *
--         FROM type;

-- --         Confirmed type table is empty
--   SELECT COUNT (DISTINCT type) 
--        FROM #tempSpiderman;
-- --        --there are 171 distinct type    
--       SELECT DISTINCT type 
--        FROM #tempSpiderman;
-- --     Confirmed this is the data I want
-- -- */


        INSERT INTO [type]
        SELECT DISTINCT [Type]
        FROM #tempSpiderman;

-- /*  Inserted data into type table


--         SELECT *
--         FROM type;

-- --         Confirmed move to type table

-- ----==========================================================================
-- --  -- ~~1N. Will move all distinct universe to the universe table
        
--         SELECT *
--         FROM universe;

-- --         Confirmed universe table is empty
--   SELECT COUNT (DISTINCT universe) 
--        FROM #tempSpiderman;
-- --        --there are 92 distinct universe    
    
-- --     Confirmed this is the data I want
-- -- */


        INSERT INTO [universe]
        SELECT DISTINCT [Universe]
        FROM #tempSpiderman;

-- /*  Inserted data into universe table


--         SELECT *
--         FROM universe;

-- --         Confirmed move to universe table

-- ----==========================================================================
-- --  -- ~~1O. Move all listing information to listing table
        
        -- SELECT *
        -- FROM listing;

-- --         Confirmed listing table is empty
--   SELECT COUNT (title)
--        FROM #tempSpiderman;
-- --        --there are 8600 titles
    
-- --     Confirmed this is the data I want
-- -- */


        INSERT INTO [listing](
                title,
                issue_num,
                issue_variant,
                image_url,
                grade,
                publication_year,
                features,
                sale_price,
                shipping_price,
                num_of_bids,
                time_of_sale,
                sellers_total_sales,
                listing_url
        )
        SELECT
                title,
                issue_num,
                issue_variant,
                image_url,
                grade,
                publication_year,
                features,
                sale_price,
                shipping_price,
                num_of_bids,
                time_of_sale,
                sellers_total_sales,
                listing_url
        FROM #tempSpiderman;

-- /*  Inserted data into universe table


        -- SELECT COUNT(*)
        -- FROM listing;

-- --         Confirmed move of 8600 listings to listing table

-- ----==========================================================================
-- --  -- ~~1P. Create the spiderman master table with all the foreign keys of the above tables 
        
--         SELECT *
--         FROM spiderman;

-- --         Confirmed spiderman table is empty
--   SELECT COUNT (title) 
--        FROM #tempSpiderman;
-- --        --there are 8600 rows   
    
--     Confirmed this is the data I want
-- */


        INSERT INTO spiderman (
                title,
                series_titleID,
                issue_num,
                issue_variant,
                image_url,
                conditionID,
                grade,
                eraID,
                publisherID,
                publication_year,
                typeID,
                genreID,
                seriesID,
                universeID,
                features,
                formatID,
                traditionID,
                sale_methodID,
                sale_currencyID,
                sale_price,
                shipping_price,
                num_of_bids,
                time_of_sale,
                seller_handleID,
                sellers_total_sales,
                seller_locationID,
                listing_url
                )
            SELECT 
                TS.title,
                ST.ID,--series title
                TS.issue_num,
                TS.issue_variant,
                TS.image_url,
                C.ID,
                TS.grade,
                E.ID,
                P.ID,
                TS.publication_year,
                TY.ID,
                G.ID,
                S.ID,
                U.ID,--universe
                TS.features,
                F.ID,
                T.ID,
                SM.ID,
                SC.ID,
                TS.sale_price,
                TS.shipping_price,
                TS.num_of_bids,
                TS.time_of_sale,
                SH.ID,
                TS.sellers_total_sales,
                SL.ID,
                TS.listing_url         
        
            FROM listing L 
            LEFT JOIN #tempSpiderman TS ON TS.listing_url = L.listing_url
            LEFT JOIN condition C ON TS.condition = C.condition
            LEFT JOIN era E ON TS.era = E.era
            LEFT JOIN  format F ON TS.format = F.format
            LEFT JOIN genre G ON TS.genre = G.genre
            LEFT JOIN  publisher P ON TS.publisher = P.publisher
            LEFT JOIN sale_currency SC ON TS.sale_currency = SC.sale_currency
            LEFT JOIN  sale_method SM ON TS.sale_method = SM.sale_method
            LEFT JOIN seller_handle SH ON TS.seller_handle = SH.seller_handle
            LEFT JOIN seller_location SL ON TS.seller_location = SL.sellers_location
            LEFT JOIN series S ON TS.series = S.series
            LEFT JOIN series_title ST ON TS.series_title = ST.series_title
            LEFT JOIN  tradition T ON TS.tradition = T.tradition
            LEFT JOIN  [type] TY ON TS.type = TY.type
            LEFT JOIN  universe U ON TS.universe = U.universe
            ;

            SELECT COUNT(*)
            FROM spiderman
        --     LEFT JOIN era F ON TS.era = F.era

-- SELECT publication_year
-- FROM #tempSpiderman
-- --         

/*  ~~2. Drop TEMPSpiderman table */

        IF  EXISTS (
            SELECT * 
            FROM sys.objects 
            WHERE object_id = OBJECT_ID(N'[dbo].[#tempSpiderman]') 
            AND TYPE IN (N'U'))
        DROP TABLE #tempSpiderman
        GO


-- /*    =========================================================================
--   ~~UPDATES  
--   ~~1. Video games need to be broken out from the Toy category. 
--     ~~a. Add a category for Video Game. */

--     INSERT INTO Category (Category)
--     VALUES ('Video Game'); 

-- /*    
--     ~~b. Update the souvenirs that are video games with the new category. This may require you looking at the data carefully to identify video games.
-- */
--     UPDATE Souvenir SET
--     CategoryID = 12
--     WHERE     
--     SouvenirName LIKE 'Oxygen Not Included'
--     AND SouvenirName LIKE 'Stardew Valley';

-- /*
--     SELECT *
--     FROM Souvenir
--     WHERE CategoryID = 12;
--     ~~Confirmed Video Games are there

--   ~~2. Jewelry boxes should be recategorized as Miscellaneous.
--     SELECT *
--     FROM Category
--     figured out Miscellaneous = 8
-- */

--     UPDATE Souvenir 
--     SET CategoryID = 8
--     WHERE SouvenirName LIKE'%jewelry box%';

-- /*
--     SELECT *
--     FROM Souvenir
--     WHERE SouvenirName LIKE'%jewelry box%';
--     ~~Confirmed it changed from 1 to 8



--   ~~3. Shamisen, Egyptian Drum, and Zuffolo need to be broken out as Musical Instruments.
--     ~~create new category
-- */
--     INSERT INTO Category (Category)
--     VALUES ('Musical Instrument'); 

-- /*  
--     ~~Confirm it works:
--     SELECT *
--     FROM Category
--     Musical Instruments = 13
-- */

--     UPDATE Souvenir SET
--         CategoryID = 13
--     WHERE SouvenirName LIKE 'Shamisen'

--     UPDATE Souvenir SET
--         CategoryID = 13
--     WHERE SouvenirName LIKE 'Egyptian Drum'

--     UPDATE Souvenir SET
--         CategoryID = 13
--     WHERE SouvenirName LIKE 'Zuffolo';

-- /*  
--     ~~Confirm it works:
--     SELECT *
--     FROM Souvenir
--     WHERE CategoryID = 13


--   ~~4.Delete the souvenir that is the heaviest. This is causing trouble in graphing data and is an outlier we want to exclude.

--     SELECT *
--     FROM Souvenir
--     WHERE CategoryID = 13
-- */
--     DECLARE @HeaviestWeight decimal(7,2)

--     SELECT @HeaviestWeight = MAX([Weight])
--     FROM Souvenir

--     DELETE FROM Souvenir 
--     WHERE [Weight] = @HeaviestWeight


-- /*  
--     ~~Confirm it worked (there should be no ID#2)
--     SELECT *
--     FROM Souvenir

--   ~~5. Delete all souvenirs that are dirt or sand.

--     Select *
--     FROM Souvenir
--     WHERE SouvenirName LIKE '%sand%'

--     Select *
--     FROM Souvenir
--     WHERE SouvenirName LIKE '%dirt%'

--     ~~See what we are looking at
-- */
--     DELETE FROM Souvenir 
--     WHERE SouvenirName LIKE '%-sand%'

--     DELETE FROM Souvenir
--     WHERE SouvenirName LIKE '%-dirt%'

-- /* 
--     ~~Confirm dirt and sand are gone
--     Select *
--     FROM Souvenir
--     WHERE SouvenirName LIKE '%dirt%'

--         Select *
--     FROM Souvenir
--     WHERE SouvenirName LIKE '%sand%
-- */

/*drop the temp table when you're done*/
-- IF OBJECT_ID(N'tempdb..#tempSpiderman') IS NOT NULL
-- BEGIN
-- DROP TABLE #tempSpiderman
-- END
-- GO


