-- Return user emails where the user account has not been deleted
SELECT id AS user_id, email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;

-- Return the number of items for sale for each category from the items table
SELECT category, COUNT(*) AS num_of_items
FROM dsv1069.items
GROUP BY category
ORDER BY category;

-- Return all of the columns from a join of the users and orders table
SELECT *
FROM dsv1069.users u
  JOIN dsv1069.orders o ON
    u.id = o.user_id;

-- Return the count of viewed_item events
SELECT COUNT(DISTINCT(event_id)) AS num_of_viewed_events
FROM dsv1069.events
WHERE event_name = 'view_item';

-- Return the number of items which have been ordered
SELECT COUNT(DISTINCT(item_id)) AS item_cnt
FROM dsv1069.orders;

-- Return if a user has ordered anything and when their first purchase was (if they ordered)
SELECT u.id AS user_id,
        MIN(o.paid_at) AS min_paid
FROM dsv1069.users u
  LEFT OUTER JOIN dsv1069.orders o ON
    u.id = o.user_id
GROUP BY u.id;

-- Return the number of users who have and have not viewed the user profile page
SELECT (CASE WHEN first_view IS NULL 
          THEN false
          ELSE true
          END) AS has_viewed_profile_page,
        COUNT(user_id) AS users
FROM 
  (SELECT u.id AS user_id,
          MIN(event_time) AS first_view
    FROM dsv1069.users u
      LEFT OUTER JOIN dsv1069.events e ON
        u.id = e.user_id AND
        event_name = 'view_user_profile'
    GROUP BY u.id) first_profile_views
GROUP BY (CASE WHEN first_view IS NULL
            THEN false
            ELSE true
            END);

-- 0. Error Codes Worksheet
-- Exercise 1:
SELECT id AS user_id, email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;

-- Exercise 2:
SELECT category, COUNT(*) AS num_of_items
FROM dsv1069.items
GROUP BY category
ORDER BY category;

-- Exercise 3:
SELECT *
FROM dsv1069.users u
  JOIN dsv1069.orders o ON
    u.id = o.user_id;

-- Exercise 4:
SELECT COUNT(DISTINCT(event_id)) AS num_of_viewed_events
FROM dsv1069.events
WHERE event_name = 'view_item';

-- Exercise 5:
SELECT COUNT(DISTINCT(item_id)) AS item_cnt
FROM dsv1069.orders o
  INNER JOIN dsv1069.items i ON
    o.item_id = i.id;

-- Exercise 6:
SELECT u.id AS user_id,
        MIN(o.paid_at) AS min_paid
FROM dsv1069.users u
  LEFT OUTER JOIN dsv1069.orders o ON
    u.id = o.user_id
GROUP BY u.id;

-- Exercise 7
SELECT (CASE WHEN first_view IS NULL 
          THEN false
          ELSE true
          END) AS has_viewed_profile_page,
        COUNT(user_id) AS users
FROM 
  (SELECT u.id AS user_id,
          MIN(event_time) AS first_view
    FROM dsv1069.users u
      LEFT OUTER JOIN dsv1069.events e ON
        u.id = e.user_id AND
        event_name = 'view_user_profile'
    GROUP BY u.id) first_profile_views
GROUP BY (CASE WHEN first_view IS NULL
            THEN false
            ELSE true
            END);

-- 1. Flexible Data Formats Worksheet
-- Exercise 1:
SELECT event_id, event_time, user_id, platform,
        (CASE WHEN parameter_name = 'item_id' THEN
              CAST (parameter_value AS INT) ELSE
              NULL 
              END) AS item_id
FROM dsv1069.events 
WHERE event_name = 'view_item'
ORDER BY event_id;

--Exercise 2:
SELECT event_id, event_time, user_id, platform,
        (CASE WHEN parameter_name = 'item_id' THEN
              CAST (parameter_value AS INT) ELSE
              NULL 
              END) AS item_id,
        (CASE WHEN parameter_name = 'referrer' THEN
              parameter_value ELSE
              NULL 
              END) AS referrer
FROM dsv1069.events 
WHERE event_name = 'view_item'
ORDER BY event_id;

-- Exercise 3:
SELECT event_id, event_time, user_id, platform,
        MAX(CASE WHEN parameter_name = 'item_id' THEN
              CAST (parameter_value AS INT) ELSE
              NULL 
              END) AS item_id,
        MAX(CASE WHEN parameter_name = 'referrer' THEN
              parameter_value ELSE
              NULL 
              END) AS referrer
FROM dsv1069.events 
WHERE event_name = 'view_item'
GROUP BY event_id, event_time, user_id, platform
ORDER BY event_id;

-- 2. Identifying Unreliable Data & Nulls Worksheet
-- Exercise 1:
SELECT *
FROM dsv1069.events_201701
-- Dates missing, specific time
SELECT date(event_time) AS chk_date,
        COUNT(*) AS num_of_rows
FROM dsv1069.events_201701
GROUP BY chk_date;

-- Exercise 2:
SELECT *
FROM dsv1069.events_ex2

SELECT date(event_time) AS chk_date,
        event_name,
        COUNT(*) AS num_of_rows
FROM dsv1069.events_ex2
GROUP BY chk_date, event_name

SELECT date(event_time) AS chk_date,
        platform,
        COUNT(*) AS num_of_rows
FROM dsv1069.events_ex2
GROUP BY chk_date, platform;

-- Exercise 3:
SELECT *
FROM dsv1069.item_views_by_category_temp;

-- Exercise 4:
SELECT *
FROM dsv1069.raw_events
LIMIT 100;
-- for web event, user id is NULL

-- Exercise 5:
-- Use COALESCE on user_id
SELECT *
FROM dsv1069.orders
JOIN dsv1069.users ON 
      orders.user_id = COALESCE(users.parent_user_id, users.id);

-- 3. Counting Users Worksheet
-- Exercise 1:
SELECT * 
FROM dsv1069.users;

-- Exercise 2:
SELECT date(created_at) AS day,
        COUNT(*) AS num_of_users
FROM dsv1069.users
GROUP BY day;

-- Exercise 3:
SELECT date(created_at) AS day,
        COUNT(*) AS users
FROM dsv1069.users
WHERE deleted_at IS NULL 
  AND
    (id <> parent_user_id OR parent_user_id IS NULL)
GROUP BY day;

-- Exercise 4:
SELECT date(deleted_at) AS day,
        COUNT(*) AS num_of_del_users
FROM dsv1069.users
WHERE deleted_at IS NOT NULL
GROUP BY day;

-- Exercise 5:
SELECT new.day, new.new_users, del.del_users, merged.merged_users
FROM (SELECT date(created_at) AS day,
              COUNT(*) AS new_users
      FROM dsv1069.users
      GROUP BY day) new
LEFT JOIN (SELECT date(deleted_at) AS del_day,
              COUNT(*) AS del_users
      FROM dsv1069.users
      WHERE deleted_at IS NOT NULL
      GROUP BY del_day) del 
ON del.del_day = new.day
LEFT JOIN (SELECT date(merged_at) AS merg_day,
                  COUNT(*) AS merged_users
          FROM dsv1069.users
          WHERE id <> parent_user_id 
            AND parent_user_id IS NULL
          GROUP BY merg_day) merged
ON merged.merg_day = new.day;

-- Exercise 6:
SELECT new.day, new.new_users, del.del_users, merged.merged_users
FROM (SELECT date(created_at) AS day,
              COUNT(*) AS new_users
      FROM dsv1069.users
      GROUP BY day) new
LEFT JOIN (SELECT date(deleted_at) AS del_day,
              COUNT(*) AS del_users
      FROM dsv1069.users
      WHERE deleted_at IS NOT NULL
      GROUP BY del_day) del 
ON del.del_day = new.day
LEFT JOIN (SELECT date(merged_at) AS merg_day,
                  COUNT(*) AS merged_users
          FROM dsv1069.users
          WHERE id <> parent_user_id 
            AND parent_user_id IS NULL
          GROUP BY merg_day) merged
ON merged.merg_day = new.day;

-- Exercise 7:
SELECT * 
FROM dsv1069.dates_rollup;

SELECT COUNT(*)
FROM dsv1069.users
JOIN dsv1069.orders ON 
      users.parent_user_id = orders.user_id;
      
SELECT COUNT(DISTINCT(event_id))
from dsv1069.events;

SELECT parent_user_id
FROM dsv1069.users;

-- 4. Clean Query into a Table Worksheet
-- Exercise 1:
-- Create table
CREATE TABLE view_item_events_1 AS 
  SELECT event_id, event_time, user_id, platform,
          MAX(CASE WHEN parameter_name = 'item_id'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS item_id,
          MAX(CASE WHEN parameter_name = 'referrer'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS referrer
  FROM dsv1069.events 
  WHERE event_name = 'view_item'
  GROUP BY event_id, event_time, user_id, platform;

-- Exercise 2:
-- Check table
DESCRIBE view_item_events_1;

SELECT *
FROM view_item_events_1
LIMIT 10;

DROP TABLE view_item_events_1;

-- Exercise 3:
CREATE TABLE view_item_events_1 AS 
  SELECT event_id, 
          TIMESTAMP(event_time) AS event_time, 
          user_id, platform,
          MAX(CASE WHEN parameter_name = 'item_id'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS item_id,
          MAX(CASE WHEN parameter_name = 'referrer'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS referrer
  FROM dsv1069.events 
  WHERE event_name = 'view_item'
  GROUP BY event_id, event_time, user_id, platform;

-- Exercise 4:
CREATE TABLE 'view_item_events_1' (
  event_id  VARCHAR(32) NOT NULL PRIMARY KEY,
  event_time VARCHAR(26),
  user_id INT(10),
  platform  VARCHAR(10),
  item_id INT(10),
  referrer  VARCHAR(17)
  );

-- Exercise 5:
-- Insert data
CREATE TABLE IF NOT EXISTS 'view_item_events_1' (
  event_id  VARCHAR(32) NOT NULL PRIMARY KEY,
  event_time VARCHAR(26),
  user_id INT(10),
  platform  VARCHAR(10),
  item_id INT(10),
  referrer  VARCHAR(17)
  );
INSERT INTO 'view_item_events_1'
  SELECT event_id, 
          TIMESTAMP(event_time) AS event_time, 
          user_id, platform,
          MAX(CASE WHEN parameter_name = 'item_id'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS item_id,
          MAX(CASE WHEN parameter_name = 'referrer'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS referrer
  FROM dsv1069.events 
  WHERE event_name = 'view_item'
  GROUP BY event_id, event_time, user_id, platform;

-- Exercise 6:
REPLACE INTO 'view_item_events_1'
  SELECT event_id, 
          TIMESTAMP(event_time) AS event_time, 
          user_id, platform,
          MAX(CASE WHEN parameter_name = 'item_id'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS item_id,
          MAX(CASE WHEN parameter_name = 'referrer'
                      THEN parameter_value
                          ELSE NULL 
                          END) AS referrer
  FROM dsv1069.events 
  WHERE event_name = 'view_item'
  GROUP BY event_id, event_time, user_id, platform;

-- 5. Snapshot Table
-- Exercise 0:
-- Liquid Tags
{% assign ds = '2018-01-01' %}
SELECT id,
        '{{ds}}' AS variable_col
FROM dsv1069.users
WHERE created_at <= variable_col;

-- Exercise 1:
{% assign ds = '2018-01-01' %}

SELECT users.id AS user_id,
        IF(users.created_at = '{{ds}}', 1, 0) AS created_today,
        IF(users.deleted_at <= '{{ds}}', 1, 0) AS is_deleted,
        IF(users.deleted_at = '{{ds}}', 1, 0) AS is_deleted_today,
        IF(users_with_orders.user_id IS NOT NULL, 1, 0) AS has_ever_ordered,
        IF(users_with_orders_today.user_id IS NOT NULL, 1, 0) AS ordered_today,
        '{{ds}}' AS ds
FROM users 
LEFT OUTER JOIN (
  SELECT DISTINCT(user_id)
  FROM orders 
  WHERE created_at <= '{{ds}}'
  ) users_with_orders
  
ON users_with_orders.user_id = users.id 

LEFT OUTER JOIN (
  SELECT DISTINCT(user_id)
  FROM orders 
  WHERE created_at = '{{ds}}'
  ) users_with_orders_today

ON users_with_orders_today.user_id = users.id 
WHERE users.created_at <= '{{ds}}';

-- Exercise 2:
-- Create Table
CREATE TABLE IF NOT EXISTS user_info (
  user_id INT(10) NOT NULL,
  created_today INT(1) NOT NULL,
  is_deleted INT(1) NOT NULL,
  is_deleted_today INT(1) NOT NULL,
  has_ever_ordered INT(1) NOT NULL,
  ordered_today INT(1) NOT NULL,
  ds      DATE    NOT NULL
  );
  
DESCRIBE user_info;

-- Exercise 3:
-- Insert into Table
{% assign ds = '2018-01-01' %}

INSERT INTO user_info

SELECT users.id AS user_id,
        IF(users.created_at = '{{ds}}', 1, 0) AS created_today,
        IF(users.deleted_at <= '{{ds}}', 1, 0) AS is_deleted,
        IF(users.deleted_at = '{{ds}}', 1, 0) AS is_deleted_today,
        IF(users_with_orders.user_id IS NOT NULL, 1, 0) AS has_ever_ordered,
        IF(users_with_orders_today.user_id IS NOT NULL, 1, 0) AS ordered_today,
        '{{ds}}' AS ds
FROM users 
LEFT OUTER JOIN (
  SELECT DISTINCT(user_id)
  FROM orders 
  WHERE created_at <= '{{ds}}'
  ) users_with_orders
  
ON users_with_orders.user_id = users.id 

LEFT OUTER JOIN (
  SELECT DISTINCT(user_id)
  FROM orders 
  WHERE created_at = '{{ds}}'
  ) users_with_orders_today

ON users_with_orders_today.user_id = users.id 
WHERE users.created_at <= '{{ds}}';

-- 6. Create Roll-up Table Worksheet
-- Exercise 1:
-- Create a subtable of orders per day
SELECT DATE(paid_at) AS day,
        COUNT(DISTINCT(invoice_id)) AS orders,
        COUNT(DISTINCT(line_item_id)) AS line_items
FROM dsv1069.orders
GROUP BY day;

-- Exercise 2:
-- Check Joins
SELECT *
FROM dsv1069.dates_rollup
LEFT OUTER JOIN (
  SELECT DATE(paid_at) AS day,
        COUNT(DISTINCT(invoice_id)) AS orders,
        COUNT(DISTINCT(line_item_id)) AS line_items
  FROM dsv1069.orders
  GROUP BY day
  ) daily_orders
ON daily_orders.day = dates_rollup.date;

-- Exercise 3:
-- Cleanup up your columns
SELECT dates_rollup.date,
        COALESCE(SUM(orders),0) AS orders,
        COALESCE(SUM(line_items),0) AS items_ordered
FROM dsv1069.dates_rollup
LEFT OUTER JOIN (
  SELECT DATE(paid_at) AS day,
        COUNT(DISTINCT(invoice_id)) AS orders,
        COUNT(DISTINCT(line_item_id)) AS line_items
  FROM dsv1069.orders
  GROUP BY day
  ) daily_orders
ON daily_orders.day = dates_rollup.date
GROUP BY dates_rollup.date;

-- Exercise 4:
-- Weekly Rollup
SELECT *
FROM dsv1069.dates_rollup
LEFT OUTER JOIN (
  SELECT DATE(paid_at) AS day,
        COUNT(DISTINCT(invoice_id)) AS orders,
        COUNT(DISTINCT(line_item_id)) AS line_items
  FROM dsv1069.orders
  GROUP BY day
  ) daily_orders
ON  dates_rollup.date >= daily_orders.day AND
    dates_rollup.d7_ago < daily_orders.day;

-- Exercise 5:
-- Columm Cleanup
SELECT dates_rollup.date,
        COALESCE(SUM(orders),0) AS orders,
        COALESCE(SUM(line_items),0) AS items_ordered
FROM dsv1069.dates_rollup
LEFT OUTER JOIN (
  SELECT DATE(paid_at) AS day,
        COUNT(DISTINCT(invoice_id)) AS orders,
        COUNT(DISTINCT(line_item_id)) AS line_items
  FROM dsv1069.orders
  GROUP BY day
  ) daily_orders
ON  dates_rollup.date >= daily_orders.day AND
    dates_rollup.d7_ago < daily_orders.day
GROUP BY dates_rollup.date;

-- 7. Promo Email Worksheet
-- Exercise 1:
/* Create the right subtable for recently viewed events using 
   the view_item_events table */
SELECT user_id, item_id, event_time,
        ROW_NUMBER() OVER (
          PARTITION BY user_id ORDER BY event_time DESC
          ) AS view_number
FROM dsv1069.view_item_events;

/* Exercise 2:
-- Skeleton Query --
Join your tables together recent_views, users, items */
SELECT *
FROM (
  SELECT user_id, item_id, event_time,
          ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY event_time DESC
            ) AS view_number
  FROM dsv1069.view_item_events
  ) recent_views
JOIN dsv1069.users
  ON users.id = recent_views.user_id 
JOIN dsv1069.items 
  ON items.id = recent_views.item_id;

/* Exercise 3:
-- With Columns -- */
SELECT users.id AS user_id, users.email_address AS email,
      items.id AS item_id,
      items.name AS item_name,
      items.category AS items_cat
FROM (
  SELECT user_id, item_id, event_time,
          ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY event_time DESC
            ) AS view_number
  FROM dsv1069.view_item_events
  ) recent_views
JOIN dsv1069.users
  ON users.id = recent_views.user_id 
JOIN dsv1069.items 
  ON items.id = recent_views.item_id 
WHERE view_number = 1;

-- Exercise 4:
-- Fine Tuning
SELECT COALESCE(users.parent_user_id, users.id) AS user_id, 
      users.email_address AS email,
      items.id AS item_id,
      items.name AS item_name,
      items.category AS items_cat
FROM (
  SELECT user_id, item_id, event_time,
          ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY event_time DESC
            ) AS view_number
  FROM dsv1069.view_item_events
  ) recent_views
JOIN dsv1069.users
  ON users.id = recent_views.user_id 
JOIN dsv1069.items 
  ON items.id = recent_views.item_id 
LEFT OUTER JOIN dsv1069.orders
  ON orders.item_id = recent_views.item_id
  AND orders.user_id = recent_views.user_id

WHERE view_number = 1
AND users.deleted_at IS NOT NULL
AND orders.item_id IS NULL;

-- 8. Product Analysis Worksheet
-- Exercise 0:
-- User Count
SELECT COUNT(*)
FROM dsv1069.users;

-- Exercise 1:
-- How many Users have ordered
SELECT COUNT(DISTINCT(user_id)) AS users_w_orders
FROM dsv1069.orders;

-- Exercise 2:
-- How many Users have re-ordered the same item
SELECT COUNT(DISTINCT(user_id)) AS users_w_reorders
FROM (
  SELECT user_id, item_id,
        COUNT(DISTINCT(line_item_id)) AS times_user_ordered
  FROM dsv1069.orders
  GROUP BY user_id, item_id
  ) user_level_orders
WHERE times_user_ordered > 1;

-- Exercise 3:
-- Multiple Orders
SELECT COUNT(DISTINCT(user_id)) AS users_w_reorders
FROM (
  SELECT user_id, COUNT(DISTINCT(invoice_id)) AS order_count
  FROM dsv1069.orders
  GROUP BY user_id
  ) user_level
WHERE order_count > 1;

-- Exercise 4:
-- Orders per Item
SELECT item_id,
        COUNT(line_item_id) AS times_ordered
FROM dsv1069.orders
GROUP BY item_id;

-- Exercise 5:
-- Orders per Category
SELECT item_category,
        COUNT(line_item_id) AS times_ordered
FROM dsv1069.orders
GROUP BY item_category;

-- Exercise 6:
-- Multiple items from the same category
SELECT item_category,
        AVG(times_cat_ordered) AS avg_times_cat_ordered
FROM (
  SELECT user_id, item_category,
          COUNT(DISTINCT(line_item_id)) AS times_cat_ordered
  FROM dsv1069.orders
  GROUP BY user_id, item_category
  ) user_level
GROUP BY item_category;

-- Exercise 7:
-- Average time between orders
SELECT first_orders.user_id,
        DATE(first_orders.paid_at) AS first_order_date,
        DATE(second_orders.paid_at) AS first_order_date,
        (DATE(second_orders.paid_at) - DATE(first_orders.paid_at)) AS date_diff
FROM (
  SELECT user_id, invoice_id, paid_at,
          DENSE_RANK( ) OVER (
            PARTITION BY user_id 
            ORDER BY paid_at ASC
            ) AS order_num
  FROM dsv1069.orders
  ) first_orders
JOIN (
  SELECT user_id, invoice_id, paid_at,
          DENSE_RANK( ) OVER (
            PARTITION BY user_id 
            ORDER BY paid_at ASC
            ) AS order_num
  FROM dsv1069.orders
  ) second_orders
ON first_orders.user_id = second_orders.user_id 
WHERE first_orders.order_num = 1 AND
      second_orders.order_num = 2;

-- 9. Test Assignments
-- Exercise 1:
-- Counting Tests Running
SELECT COUNT(DISTINCT(parameter_value)) AS num_of_tests
FROM dsv1069.events 
WHERE event_name = 'test_assignment' AND
      parameter_name = 'test_id';

-- Exercise 2:
-- Check if data is missing
SELECT parameter_value AS test_id,
        DATE(event_time) AS day,
        COUNT(*) AS event_rows
FROM dsv1069.events 
WHERE event_name = 'test_assignment' AND
      parameter_name = 'test_id'
GROUP BY parameter_value, DATE(event_time);

-- Exercise 3:
-- Assignments Event Table
SELECT event_id, event_time, user_id, platform,
        MAX(CASE WHEN parameter_name = 'test_id'
                  THEN CAST(parameter_value AS INT)
                  ELSE NULL 
                  END) AS test_id,
        MAX(CASE WHEN parameter_name = 'test_assignment'
                  THEN parameter_value
                  ELSE NULL 
                  END) AS test_assignment
FROM dsv1069.events 
WHERE event_name = 'test_assignment'
GROUP BY event_id, event_time, user_id, platform
ORDER BY event_id;

-- Exercise 4:
-- Check Assignments
SELECT user_id,
        COUNT(DISTINCT(test_assignment)) AS assignments
FROM(
  SELECT event_id, event_time, user_id, platform,
          MAX(CASE WHEN parameter_name = 'test_id'
                    THEN CAST(parameter_value AS INT)
                    ELSE NULL 
                    END) AS test_id,
          MAX(CASE WHEN parameter_name = 'test_assignment'
                    THEN parameter_value
                    ELSE NULL 
                    END) AS test_assignment
  FROM dsv1069.events 
  WHERE event_name = 'test_assignment'
  GROUP BY event_id, event_time, user_id, platform
  ORDER BY event_id
  ) test_events
WHERE test_id = 5
GROUP BY user_id
ORDER BY assignments DESC;

-- 10. Create a Test Metric Worksheet
-- Exercise 1:
-- Compute Order Binary
SELECT test_events.test_id, test_events.test_assignment, test_events.user_id,
        MAX(CASE WHEN orders.created_at > test_events.event_time 
              THEN 1 
              ELSE 0 
              END) AS orders_after_assign_binary
FROM (
  SELECT event_id, event_time, user_id, platform,
          MAX(CASE WHEN parameter_name = 'test_id'
                    THEN CAST(parameter_value AS INT)
                    ELSE NULL 
                    END) AS test_id,
          MAX(CASE WHEN parameter_name = 'test_assignment'
                    THEN parameter_value
                    ELSE NULL 
                    END) AS test_assignment
  FROM dsv1069.events 
  WHERE event_name = 'test_assignment'
  GROUP BY event_id, event_time, user_id, platform
  ) test_events
LEFT JOIN dsv1069.orders ON 
          orders.user_id = test_events.user_id
GROUP BY test_events.test_id, test_events.test_assignment, test_events.user_id;

-- Exercise 2:
-- Compute Mean Metrics
SELECT test_events.test_id, test_events.test_assignment, test_events.user_id,
        COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time 
              THEN invoice_id 
              ELSE NULL
              END)) AS orders_after_assign,
        COUNT(DISTINCT(CASE WHEN orders.created_at > test_events.event_time 
              THEN line_item_id 
              ELSE NULL
              END)) AS items_after_assign,
        SUM(CASE WHEN orders.created_at > test_events.event_time 
              THEN price
              ELSE 0
              END) AS total_rev
FROM (
  SELECT event_id, event_time, user_id, platform,
          MAX(CASE WHEN parameter_name = 'test_id'
                    THEN CAST(parameter_value AS INT)
                    ELSE NULL 
                    END) AS test_id,
          MAX(CASE WHEN parameter_name = 'test_assignment'
                    THEN parameter_value
                    ELSE NULL 
                    END) AS test_assignment
  FROM dsv1069.events 
  WHERE event_name = 'test_assignment'
  GROUP BY event_id, event_time, user_id, platform
  ) test_events
LEFT JOIN dsv1069.orders ON 
          orders.user_id = test_events.user_id
GROUP BY test_events.test_id, test_events.test_assignment, test_events.user_id;