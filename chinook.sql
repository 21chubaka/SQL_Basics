-- Simple Queries

-- Find Alls --
-- Find all data from the tracks table
SELECT *
FROM tracks;

-- Find all data from the artists table
SELECT *
FROM artisits;

-- Find all data from the invoices table
SELECT *
FROM invoices;

-- Column Returns --
-- Return Playlist ID and Name from the playlist table
SELECT PlaylistId, Name
FROM playlist;

-- Return Customer ID, Invoice Date, and Billing City from the Invoices table
SELECT CustomerId, InvoiceDate, BillingCity
FROM invoices;

-- Return First Name, Last Name, Email, and Phone Number from the Customer table
SELECT FirstName, LastName, email, phone
FROM customer;

-- Limits --
-- Find all data from the Playlist Track, but only return the first 10 records
SELECT *
FROM PlaylistTrack
LIMIT 10;

-- Find all data from the Media Types table, but only return 25 records
SELECT *
FROM MediaType
LIMIT 25;

-- Find all data from the Albums table, but limit the results to 5 records
SELECT *
FROM Albums
LIMIT 5;

-- Simple Where --
-- Find all the tracks with a length of 5,000,000 milliseconds or more
SELECT *
FROM tracks
WHERE milliseconds >= 5000000;

-- Find all invoices whose Total is between $5 and $15
SELECT *
FROM invoices
WHERE total BETWEEN 5 AND 15;

-- Find all Customers that are located in these States: RJ, DF, AB, BC, CA, WA, NY
SELECT *
FROM customer
WHERE state IN ('RJ', 'DF', 'AB', 'BC', 'CA', 'WA', 'NY');

-- Find all invoices for customers 56 and 58 where the total is between $1 and $5
SELECT *
FROM invoices
WHERE (CustomerId IN ('56', '58'))
    AND (total BETWEEN 1 AND 5);

-- Find all tracks whose name starts with 'All'
SELECT *
FROM tracks
WHERE name LIKE 'All%';

-- Find all customer emails that start with 'J' and use gmail.com
SELECT email
FROM customer
WHERE email LIKE 'J%@gmail.com';

-- Order By, Group By, Having
-- Find all the invoices with billing city set as Brasilia, Edmonton, and Vancouver and
-- sort the results in descending order by Invoice ID
SELECT InvoiceId, BillingCity, total
FROM invoices
WHERE BillingCity IN ('Brasilia', 'Edmonton', 'Vancouver')
ORDER BY InvoiceId DESC;

-- Find all the number of orders placed by each customer and sort the results by the
-- number of orders in descending order
SELECT COUNT(InvoiceId) AS order_cnt, CustomerId
FROM invoices
GROUP BY CustomerId
ORDER BY order_cnt DESC;

-- Find the albums that have at least 12 tracks
SELECT AlbumId, COUNT(*) AS num_tracks
FROM tracks
GROUP BY AlbumId
Having num_tracks >= 12;

-- Nested Queries --
-- Find all albums from Led Zeppelin
SELECT *
FROM albums
WHERE ArtistId = (
    SELECT ArtistId
    FROM artists
    WHERE name = 'Led Zeppelin'
);