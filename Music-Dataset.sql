-- Q1 : Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A

-- SELECT first_name, last_name, email 
-- FROM customer
-- JOIN invoice ON customer.customer_id = invoice.customer_id
-- JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
-- WHERE track_id IN (
-- 	SELECT track_id FROM track
-- 	JOIN genre ON track.genre_id = genre.genre_id
-- 	WHERE genre.name = 'Rock'
-- )
-- ORDER BY email



--Q2: Let's invite the artists who have written the most rock music in
--our dataset. Write a query that returns the Artist name and total
--track count of the top 10 rock bands

-- SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) as nos_of_songs
-- FROM track
-- JOIN album ON album.album_id = track.album_id
-- JOIN artist ON artist.artist_id = album.artist_id
-- JOIN genre ON genre.genre_id = track.genre_id
-- WHERE genre.name LIKE 'Rock'
-- GROUP BY artist.artist_id
-- ORDER BY nos_of_songs DESC
-- LIMIT 10

-- Q3: Return all the track names that have a song length longer than
-- the average song length. Return the and Milliseconds for
-- each track. Order by the song length with the longest songs listed
-- first.

-- SELECT name, milliseconds from track
-- WHERE milliseconds>(
-- 	SELECT AVG(milliseconds) AS avg_ms
-- 	FROM track
-- )
-- ORDER BY milliseconds DESC
-- LIMIT 10

-- LEVEL - ADVANCE

--Q1: Find how much amount spent by each customer on artists? Write a
--query to return customer name, artist name and total spent.

-- WITH best_selling_artist AS (
-- 	SELECT artist.artist_id as artistId, artist.name as artistName,
-- 	SUM(invoice_line.unit_price*invoice_line.quantity) as total_sales
-- 	FROM invoice_line
-- 	JOIN track ON track.track_id = invoice_line.track_id
-- 	JOIN album ON album.album_id = track.album_id
-- 	JOIN artist ON artist.artist_id = album.artist_id
-- 	GROUP BY 1
-- 	ORDER BY 3 DESC
-- 	LIMIT 1
-- )

-- SELECT c.customer_id, c.first_name, c.last_name, bsa.artistName,
-- SUM(il.unit_price*il.quantity) AS amount_spent
-- FROM invoice i 
-- JOIN customer c ON c.customer_id = i.customer_id
-- JOIN invoice_line il ON il.invoice_id = i.invoice_id
-- JOIN track t ON t.track_id = il.track_id
-- JOIN album alb ON alb.album_id = t.album_id
-- JOIN best_selling_artist bsa ON bsa.artistId = alb.artist_id
-- GROUP BY 1,2,3,4
-- ORDER BY 5 DESC;

-- Q2: We want to find out the most popular music Genre for each country.
-- We determine the most popular genre as the genre with the highest
-- amount of purchases. Write a query that returns each country along with
-- the top Genre. For countries where the maximum number of
-- is shared return all Genres.

WITH pupular_genre AS(
	SELECT COUNT(invoice_line.quantity) AS purchases, invoice.billing_country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN track ON invoice_line.track_id = track.track_id
	JOIN genre ON track.genre_id = genre.genre_id 
	GROUP BY 2, 3, 4
	ORDER BY 2 ASC, 1 DESC
)

SELECT * FROM pupular_genre WHERE RowNo <=1


















