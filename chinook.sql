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
