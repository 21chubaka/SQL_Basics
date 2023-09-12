-- Return user emails where the user account has not been deleted
SELECT email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;