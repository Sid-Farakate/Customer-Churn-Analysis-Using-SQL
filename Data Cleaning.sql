-- DATA CLEANING

USE e_commerce;

CREATE TABLE churn_analysis_staging
LIKE churn_analysis;

INSERT INTO churn_analysis_staging
SELECT * FROM churn_analysis;

-- 1. Checking for duplicates
-- SELECT COUNT(DISTINCT ï»¿CustomerID) FROM churn_analysis_staging

WITH duplicates_cte AS(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY ï»¿CustomerID) AS row_num
FROM churn_analysis_staging
)
SELECT * FROM duplicates_cte
WHERE row_num > 1;
-- No duplicate records found.


-- 2. Standardize Data

-- 2.1. Update column name customerID
ALTER TABLE churn_analysis_staging
RENAME COLUMN ï»¿CustomerID
TO CustomerID;

-- 2.2. Update values of tenure 
SELECT * FROM churn_analysis_staging;

UPDATE churn_analysis_staging
SET Tenure = NULL
WHERE Tenure = 99;

WITH AvgTenure AS (
  SELECT ROUND(AVG(Tenure)) AS avg_tenure
  FROM churn_analysis_staging
)
UPDATE churn_analysis_staging
SET Tenure = (SELECT avg_tenure FROM AvgTenure)
WHERE Tenure IS NULL;

-- 2.3. Update values of PreferredLoginDevice
SELECT DISTINCT PreferredLoginDevice FROM churn_analysis_staging;

UPDATE churn_analysis_staging
SET PreferredLoginDevice = 'Phone'
WHERE PreferredLoginDevice = 'Mobile Phone';

-- 2.4. Update values of WarehouseToHome
SELECT DISTINCT WarehouseToHome FROM churn_analysis_staging;

UPDATE churn_analysis_staging
SET WarehouseToHome = 26
WHERE WarehouseToHome = 126;

UPDATE churn_analysis_staging
SET WarehouseToHome = 27
WHERE WarehouseToHome = 127;

-- 2.5. Update values of PreferredPaymentMode
SELECT DISTINCT PreferredPaymentMode FROM churn_analysis_staging;

UPDATE churn_analysis_staging
SET PreferredPaymentMode = CASE
    WHEN PreferredPaymentMode = 'COD' THEN 'Cash on Delivery'
    WHEN PreferredPaymentMode = 'CC' THEN 'Credit Card'
    ELSE PreferredPaymentMode
END;

-- 2.6. Update values of PreferedOrderCat
SELECT distinct PreferedOrderCat FROM churn_analysis_staging;

UPDATE churn_analysis_staging
SET PreferedOrderCat = 'Mobile'
WHERE PreferedOrderCat = 'Mobile Phone';


-- 3. HANDLING NULL VALUES

-- No null values found


