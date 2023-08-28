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