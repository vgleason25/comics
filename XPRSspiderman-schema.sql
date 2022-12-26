USE MASTER; --always start in master
GO

ALTER DATABASE spiderman
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE spiderman;
GO

DROP DATABASE IF EXISTS spiderman --get rid of it if we are making chanages
GO

CREATE DATABASE spiderman; --make new database
GO

USE spiderman; --get in the database
GO

-- create tables and relationships
-- 1. listing table
CREATE TABLE listing (
    ID INT PRIMARY KEY IDENTITY (1, 1),
    [title] nvarchar(4000) NULL, --bc every item has an title 
    issue_num INT NULL,
    issue_variant NVARCHAR(4000) NULL,
    image_url NVARCHAR(4000) NULL,
    grade DECIMAL(3,1) NULL,
    publication_year INT NULL,
    features NVARCHAR(4000) NULL,
    sale_price DECIMAL(18,2) NULL,
    shipping_price DECIMAL(18,2) NULL,
    num_of_bids INT NULL,
    time_of_sale DATE NULL,
    sellers_total_sales INT NULL,
    listing_url NVARCHAR(4000) NOT NULL,
);

CREATE TABLE series_title (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    series_title NVARCHAR(4000) NULL,
        CONSTRAINT uq_series_title
        UNIQUE (series_title)--so each series_title can only be listed once
); 

CREATE TABLE condition (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    condition NVARCHAR(4000) NULL,
        CONSTRAINT uq_condition
        UNIQUE (condition)--so each condition can only be listed once
); 

CREATE TABLE publisher (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    publisher NVARCHAR(4000) NULL,
        CONSTRAINT uq_publisher
        UNIQUE (publisher)--so each publisher can only be listed once
); 

CREATE TABLE format (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    format NVARCHAR(4000) NULL,
        CONSTRAINT uq_format
        UNIQUE (format)--so each format can only be listed once
); 

CREATE TABLE tradition (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    tradition NVARCHAR(4000) NULL,
        CONSTRAINT uq_tradition
        UNIQUE (tradition)--so each tradition can only be listed once
); 

CREATE TABLE era (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    era NVARCHAR(4000) NULL,
        CONSTRAINT uq_era
        UNIQUE (era)--so each era can only be listed once
); 

CREATE TABLE [type] (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    [type] NVARCHAR(4000) NULL,
        CONSTRAINT uq_type
        UNIQUE ([type])--so each type can only be listed once
); 

CREATE TABLE genre (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    genre NVARCHAR(4000) NULL,
        CONSTRAINT uq_genre
        UNIQUE (genre)--so each genre can only be listed once
); 

CREATE TABLE series (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    series NVARCHAR(4000) NULL,
        CONSTRAINT uq_series
        UNIQUE (series)--so each series can only be listed once
); 

CREATE TABLE universe (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    universe NVARCHAR(4000) NULL,
        CONSTRAINT uq_universe
        UNIQUE (universe)--so each universe can only be listed once
); 

CREATE TABLE sale_currency (
    ID INT PRIMARY KEY IDENTITY(1, 1),
    sale_currency NVARCHAR(50) NULL,
        CONSTRAINT uq_currency
        UNIQUE (sale_currency)--so each sale_currency can only be listed once
);   

CREATE TABLE sale_method (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    sale_method NVARCHAR(100) NOT NULL,
        CONSTRAINT uq_method
        UNIQUE (sale_method)--so each handle can only be listed once
);  
    
CREATE TABLE seller_handle (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    seller_handle NVARCHAR(4000) NOT NULL,
        CONSTRAINT uq_handle
        UNIQUE (seller_handle)--so each handle can only be listed once
);   


CREATE TABLE seller_location (    
    ID INT PRIMARY KEY IDENTITY(1, 1),
    sellers_location NVARCHAR(4000) NULL,
        CONSTRAINT uq_location
        UNIQUE (sellers_location)--so each location can only be listed once
);

        IF  EXISTS (
            SELECT * 
            FROM sys.objects 
            WHERE object_id = OBJECT_ID(N'[dbo].[spiderman]') 
            AND TYPE IN (N'U'))
        DROP TABLE spiderman
        GO

--master table
CREATE TABLE  spiderman (
    ID INT PRIMARY KEY IDENTITY (1, 1),
    [title] nvarchar(4000) NULL, 
    series_titleID INT NULL,
    issue_num INT NULL,
    issue_variant NVARCHAR(4000) NULL,
    image_url NVARCHAR(4000) NULL,
    conditionID INT NULL,
    grade DECIMAL(3,1) NULL,
    eraID INT NULL,
    publisherID INT NULL,
    publication_year INT NULL,
    typeID INT NULL,
    genreID INT NULL,
    seriesID INT NULL,
    universeID INT NULL,
    features NVARCHAR(4000) NULL,
    formatID INT NULL,
    traditionID INT NULL,
    sale_methodID INT NULL,
    sale_currencyID INT NULL,
    sale_price DECIMAL(18,2) NULL,
    shipping_price DECIMAL(18,2) NULL,
    num_of_bids INT NULL,
    time_of_sale DATE NULL,
    seller_handleID INT NULL,
    sellers_total_sales INT NULL,
    seller_locationID INT NULL,
    listing_url NVARCHAR(4000) NULL,
        CONSTRAINT fk_spiderman_series_titleID
            FOREIGN KEY (series_titleID)
            REFERENCES series_title (ID),
        CONSTRAINT fk_spiderman_conditionID
            FOREIGN KEY (conditionID)
            REFERENCES condition (ID),
        CONSTRAINT fk_spiderman_publisherID
            FOREIGN KEY (publisherID)
            REFERENCES publisher (ID),
        CONSTRAINT fk_spiderman_formatID
            FOREIGN KEY (formatID)
            REFERENCES format (ID),
        CONSTRAINT fk_spiderman_traditionID
            FOREIGN KEY (traditionID)
            REFERENCES tradition (ID),
        CONSTRAINT fk_spiderman_eraID
            FOREIGN KEY (eraID)
            REFERENCES era (ID),
        CONSTRAINT fk_spiderman_typeID
            FOREIGN KEY (typeID)
            REFERENCES [type] (ID),
        CONSTRAINT fk_spiderman_genreID
            FOREIGN KEY (genreID)
            REFERENCES genre (ID),
        CONSTRAINT fk_spiderman_seriesID
            FOREIGN KEY (seriesID)
            REFERENCES series (ID),
        CONSTRAINT fk_spiderman_universeID
            FOREIGN KEY (universeID)
            REFERENCES universe (ID),
        CONSTRAINT fk_spiderman_sale_currencyID
            FOREIGN KEY (sale_currencyID)
            REFERENCES sale_currency (ID),
        CONSTRAINT fk_spiderman_sale_methodID
            FOREIGN KEY (sale_methodID)
            REFERENCES sale_method (ID),
        CONSTRAINT fk_spiderman_seller_handleID
            FOREIGN KEY (seller_handleID)
            REFERENCES seller_handle (ID),           
        CONSTRAINT fk_spiderman_seller_locationID
            FOREIGN KEY (seller_locationID)
            REFERENCES seller_location (ID)
);

-- SELECT *
-- FROM spiderman










