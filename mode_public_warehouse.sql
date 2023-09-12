-- Return user emails where the user account has not been deleted
SELECT email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;

-- Return the number of items for sale for each category from the items table
SELECT category, COUNT(*) AS num_of_items
FROM dsv1069.items
GROUP BY category
ORDER BY category;