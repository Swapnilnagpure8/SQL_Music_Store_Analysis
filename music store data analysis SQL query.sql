Q1. Who is the senior most employee based on job title? *

select first_name , last_name
from employee
order by levels desc 
limit 1;

Q2. Which countries have the most Invoices ?

select billing_country, count(*) as count_of_biiling_country
from Invoice 
group by billing_country
order by 2  desc
limit 1;

Q3. What are top 3 values of total invoice?

select total from invoice
order by 1 desc
limit 3;

Q4. Which city has the best customers? 
	We would like to throw a promotional music festiveal in the city we made the most money.
	write a query that returns one city that has the highest sum of invoice totals.
	return both the city name and sum of all invoice totals.

select sum(total) as invoice_total , billing_city 
from  invoice 
group by 2
order by 1 desc
limit 1;

Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
	write a query that returns the person who has spent the most money.

select customer.customer_id , first_name, last_name , sum(invoice.total) as total
from customer 
join invoice  
on customer.customer_id = invoice .customer_id
group by customer.customer_id
order by total desc
limit 1;

Q6. Write a query to return the email,first name , last name , and genre of all rock music listeners.
	Return your list ordered alphabetically by email starting with A. 

select distinct(customer.email) as Email,customer.first_name,customer.last_name
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on track.track_id= invoice_line.track_id
join genre on genre.genre_id= track.genre_id
where genre.name like 'Rock'
order by 1;

select distinct(email) as Email , first_name , last_name 
from customer 
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in (
				select track_id from track 
				join genre on track.genre_id = genre.genre_id
				where genre.name like 'Rock'
				)
order by 1 ;


Q7. Let's invite the artists who have written the most rock music in our dataset. 
write a query that returns the artist name and total track count of the top 10 rock bands.

select artist.artist_id, artist.name , count(artist.artist_id) as Number_of_songs
from track 
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by 1 
order by 3 desc
limit 10;

Q8. Return all the track names that have a song length longer than the average song length.
	Return the name all milliseconds for each track. Order by the song length with the longest
	song listed first. 

select name , milliseconds 
from track 
where milliseconds > (select avg(milliseconds) as track_ave_length
					from track )
order by 2 desc;

Q9. Find ow much amount spent by each customer on artists ? Write a query to return customer name , 
	artist name and total spent.
	
with best_selling_artist as ( 	
	select artist.artist_id as Artist_id , artist.name as Artist_name , 
	sum(invoice_line.unit_price*invoice_line.quantity)
	from invoice_line 
	join track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	group by 1
	order by 3 desc 
	limit 1
)
select customer.customer_id , customer.first_name , customer.last_name , best_selling_artist.artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as Amount_spent
from invoice
join customer on customer.customer_id = invoice.customer_id
join invoice_line on invoice. invoice_id = invoice_line.invoice_id
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join best_selling_artist on best_selling_artist.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc ;

Q10. We want to find out the most popular music genre for each country .
	we determine the most popular genre as the genre with the highest amount of purchases . 
	Write a query that returns each country along with the top genre. 
	For countries where the maximum number of purchased is shared return all genres.
	
with popular_genre as (
	select count(invoice_line.quantity) as purchase , customer.country , genre.name , genre. genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as row_num
	from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line. track_id
	join  genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc , 1 desc 
	)
select * from popular_genre where row_num =1;

	
Q11. Write a query that determines the customer that has spent the most on music for each country.
	Write a query that returns the country along with the top customer and how much they spent .
	For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,
		SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS row_num 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE row_num = 1;


