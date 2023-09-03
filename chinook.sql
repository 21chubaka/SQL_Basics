-- Simple Queries

-- Find Alls --
-- Find all data from the tracks table
SELECT *
FROM tracks;

-- Find all data from the artists table
SELECT *
FROM artists;

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

-- Nested Subqueries --
-- Find all albums from Led Zeppelin
SELECT *
FROM albums
WHERE ArtistId = (
    SELECT ArtistId
    FROM artists
    WHERE name = 'Led Zeppelin'
);

-- Find the number of albums Led Zeppelin has
SELECT COUNT(*)
FROM albums
WHERE ArtistId = (
    SELECT ArtistId
    FROM artists
    WHERE name = 'Led Zeppelin'
);

-- Find the names and tracks for the album 'Californication'
SELECT name AS Track_Name
FROM tracks
WHERE AlbumId = (
    SELECT AlbumId
    FROM albums
    WHERE title = 'Californication'
);

-- Return the total number of invoices, first & last name, city, and email for each customer
SELECT DISTINCT(c.CustomerId), c.FirstName, c.LastName, c.email,
                COUNT(i.InvoiceId) AS Num_of_Invoices
FROM customers c
    LEFT JOIN invoices i ON
        c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;

-- Joins --
-- Find all the album titles and unit prices for the artist 'Audioslave'
SELECT artists.Name AS 'Artist Name',
        albums.Title AS 'Album Title',
        tracks.UnitPrice AS 'Unit Price'
FROM artists
    LEFT JOIN albums ON 
        artists.ArtistId = albums.ArtistId
    LEFT JOIN tracks ON
        albums.AlbumId = tracks.AlbumId
WHERE artists.Name = 'Audioslave';

-- Find all the customers first and last names and give a count of how many invoices each have
SELECT DISTINCT(c.CustomerId), c.FirstName, c.LastName,
                COUNT(i.InvoiceId) AS Num_of_Invoices
FROM customers c
    LEFT JOIN invoices i ON
        c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Num_of_Invoices ASC;

-- Find the total album price for the 'Big Ones' album
SELECT albums.Title AS 'Album Title',
        SUM(tracks.UnitPrice) AS 'Album Price'
FROM albums
    LEFT JOIN tracks ON
        albums.AlbumId = tracks.AlbumId
WHERE albums.Title = 'Big Ones';