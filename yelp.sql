-- Find the number of records for each table
-- Attribute Table:
SELECT COUNT(*)
FROM attribute;

-- Result: 10000

-- Business Table:
SELECT COUNT(*)
FROM business;

-- Result: 10000

-- Category Table:
SELECT COUNT(*)
FROM category;

-- Result: 10000

-- Check-in Table:
SELECT COUNT(*)
FROM checkin;

-- Result: 10000

-- Elite Years Table:
SELECT COUNT(*)
FROM elite_years;

-- Result: 10000

-- Friend Table:
SELECT COUNT(*)
FROM friend;

-- Result: 10000

-- Hours Table:
SELECT COUNT(*)
FROM hours;

-- Result: 10000

-- Photo Table:
SELECT COUNT(*)
FROM photo;

-- Result: 10000

-- Review Table:
SELECT COUNT(*)
FROM review;

-- Result: 10000

-- Tip Table:
SELECT COUNT(*)
FROM tip;

-- Result: 10000

-- User Table:
SELECT COUNT(*)
FROM user;

-- Result: 10000

-- Find the number of distinct records for each table
-- Business Table:
SELECT COUNT(DISTINCT(id)) AS distinct_records
FROM business;

-- Result: 10000

-- Hours Table:
SELECT COUNT(DISTINCT(business_id)) AS distinct_records
FROM hours;

-- Result: 1562

-- Category Table:
SELECT COUNT(DISTINCT(business_id)) AS distinct_records
FROM category;

-- Result: 2643

-- Attribute Table:
SELECT COUNT(DISTINCT(business_id)) AS distinct_records
FROM attribute;

-- Result: 1115

-- Review Table:
SELECT COUNT(DISTINCT(id)) AS distinct_records
FROM review;

-- Result: 10000

-- Check-in Table:
SELECT COUNT(DISTINCT(business_id)) AS distinct_records
FROM checkin;

-- Result: 493

-- Photo Table:
SELECT COUNT(DISTINCT(id)) AS distinct_records
FROM photo;

-- Result: 10000

-- Tip Table:
SELECT COUNT(DISTINCT(user_id)) AS distinct_records
FROM tip;

-- Result: 537

-- User Table:
SELECT COUNT(DISTINCT(id)) AS distinct_records
FROM user;

-- Result: 10000

-- Friend Table:
SELECT COUNT(DISTINCT(user_id)) AS distinct_records
FROM friend;

-- Result: 11

-- Elite Year Table:
SELECT COUNT(DISTINCT(user_id)) AS distinct_records
FROM elite_years;

-- Result: 2780