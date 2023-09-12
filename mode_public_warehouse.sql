-- Return user emails where the user account has not been deleted
SELECT email_address
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
SELECT COUNT(*) AS num_of_viewed_events
FROM dsv1069.events
WHERE event_name = 'view_item';

-- Return the number of items which have been ordered
SELECT COUNT(DISTINCT(item_id))
FROM dsv1069.orders o
  INNER JOIN dsv1069.items i ON
    o.item_id = i.id;