-- Python and SQL Foundations - cleaned SQL examples
-- Portfolio note: these are public, cleaned examples based on DSCI 405 / SQL practice
-- using the Chinook sample database structure. They demonstrate query patterns rather
-- than reproduce every original assignment file.

-- 1. Inspect a full table.
SELECT *
FROM tracks;

-- 2. Select specific fields from a table.
SELECT
    TrackId,
    Name,
    Composer,
    Milliseconds
FROM tracks;

-- 3. Filter records with WHERE.
SELECT
    TrackId,
    Name,
    UnitPrice
FROM tracks
WHERE UnitPrice >= 0.99;

-- 4. Sort records for review.
SELECT
    Name,
    Milliseconds
FROM tracks
ORDER BY Milliseconds DESC;

-- 5. Aggregate records by category.
SELECT
    GenreId,
    COUNT(*) AS track_count,
    AVG(Milliseconds) AS avg_track_length
FROM tracks
GROUP BY GenreId
ORDER BY track_count DESC;

-- 6. Join related tables.
SELECT
    t.Name AS track_name,
    g.Name AS genre_name,
    a.Title AS album_title
FROM tracks AS t
JOIN genres AS g
    ON t.GenreId = g.GenreId
JOIN albums AS a
    ON t.AlbumId = a.AlbumId;

-- 7. Create a simple business-style summary query.
SELECT
    c.Country,
    COUNT(i.InvoiceId) AS invoice_count,
    ROUND(SUM(i.Total), 2) AS total_revenue
FROM customers AS c
JOIN invoices AS i
    ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY total_revenue DESC;
