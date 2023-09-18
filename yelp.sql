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

-- Check if there is any null values in the User Table
SELECT *
FROM user
WHERE id IS NULL OR
        name IS NULL OR
        review_count IS NULL OR
        yelping_since IS NULL OR
        useful IS NULL OR
        funny IS NULL OR
        cool IS NULL OR
        fans IS NULL OR
        average_stars IS NULL OR
        compliment_hot IS NULL OR
        compliment_more IS NULL OR
        compliment_profile IS NULL OR
        compliment_cute IS NULL OR
        compliment_list IS NULL OR
        compliment_note IS NULL OR
        compliment_plain IS NULL OR
        compliment_cool IS NULL OR
        compliment_funny IS NULL OR
        compliment_writer IS NULL OR
        compliment_photos IS NULL;

-- Find the Min, Max, Avg star rating from the Review Table
SELECT MIN(stars) AS star_min,
        MAX(stars) AS star_max,
        AVG(stars) AS star_avg
FROM review;

-- Find the Min, Max, Avg star rating from the Business Table
SELECT MIN(stars) AS star_min,
        MAX(stars) AS star_max,
        AVG(stars) AS star_avg
FROM business;

-- Find the Min, Max, Avg of likes from the Tip Table
SELECT MIN(likes) AS like_min,
        MAX(likes) AS like_max,
        AVG(likes) AS like_avg
FROM tip;

-- Find the Min, Max, Avg of counts from the Check-in Table
SELECT MIN(count) AS count_min,
        MAX(count) AS count_max,
        AVG(count) AS count_avg
FROM checkin;

-- Find the Min, Max, Avg of the review counts from the User Table
SELECT MIN(review_count) AS review_count_min,
        MAX(review_count) AS review_count_max,
        AVG(review_count) AS review_count_avg
FROM user;

-- Find the number of reviews by city
SELECT city, 
        COUNT(review_count) AS city_review_count
FROM business
GROUP BY city
ORDER BY city_review_count DESC;

-- Find the count of star values for the city 'Avon'
SELECT stars AS 'star rating', COUNT(stars) AS count
FROM business
WHERE city = 'Avon'
GROUP BY stars;

-- Find the count of star values for the city 'Beachwood'
SELECT stars AS 'star rating', COUNT(stars) AS count
FROM business
WHERE city = 'Beachwood'
GROUP BY stars;

-- Find top 3 users in terms of their total number of reviews
SELECT id, name, review_count
FROM user
ORDER BY review_count DESC
LIMIT 3;

-- Does posting more reviews correlate with more fans?
SELECT id, name, review_count, fans
FROM user
ORDER BY review_count DESC
LIMIT 10;