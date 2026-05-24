-- SQL Layoffs Project - Data Cleaning
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- Steps for data cleaning 
-- 1. Check for duplicates and remove any
-- 2. Standardize data and fix errors
-- 3. Look at null values
-- 4. Remove any columns and rows that are unnecessary

SELECT * 
FROM world_layoffs.layoffs;

-- Create a staging table to work in and clean the data
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;


-- 1. Remove Duplicates

-- Finding duplicates
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
SELECT COUNT(*)
FROM world_layoffs.layoffs_staging;

-- Delete where the row number is > 1
CREATE TABLE world_layoffs.layoffs_staging2 AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country,
                            funds_raised_millions
               ORDER BY company
           ) AS row_num
    FROM world_layoffs.layoffs_staging
) t
WHERE row_num = 1;

-- Duplicates are removed
SELECT COUNT(*)
FROM world_layoffs.layoffs_staging2;

-- 2. Standardize Data

SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Using trim to remove inconsistent spacing
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Crypto has multiple different variations which need to be standardized
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Now there is only one industry for all of Crypto
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

-- There are some "United States" and some "United States." (period at the end, this needs to be standardized)
SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

-- Date column needs to be changed from text to date type:
SELECT *
FROM world_layoffs.layoffs_staging2;

-- Use str_to_date to update this field
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM world_layoffs.layoffs_staging2;

-- 3. Look at Null Values

-- I will fill in the null values for industry
-- The other null values in total_laid_off, percentage_laid_off, and funds_raised_millions are fine for now since they makes it easier for calculations during the EDA phase
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'airbnb%';

-- Airbnb is a travel, but the industry isn't filled out, the other nulls may face a similar issue
-- Best thing to do is write a query where if another row has the same company name and has their industry filled out
-- it will update the null to the correct industry

-- Set the blanks to nulls since they are typically easier to work with
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- They are all null now
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Nulls need to be populated
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Bally's is the only one that does not have industry filled out
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- 4. remove any columns and rows we need to
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Data is not helpful for EDA so it will be removed
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- No need for row_num column since we are done data cleaning
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM world_layoffs.layoffs_staging2;

