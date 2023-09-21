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

-- Error Codes Worksheet
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