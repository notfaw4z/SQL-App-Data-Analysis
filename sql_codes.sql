CREATE TABLE appleStore_description_combined AS
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4


**E D A**

--check the number of uniqye apps in both tablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

--check for missing values in key fields

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL

--Find out the number of app per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of the apps ratins

SELECT MIN(user_rating) AS MinRating,
	   MAX(user_rating) AS MaxRating,
       AVG(user_rating) AS AvgRating
FROM AppleStore

** DATA ANALYSIS **

-- Determine whether paid apps have higher ratings than free apps

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

--Check if apps with more supported languages have higher ratings

SELECT CASE
			WHEN lang_num < 10 THEN '<10 Languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
            ELSE '>30 Languages'
       END AS language_bucket,
       AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

--Check genre with low ratings

SELECT prime_genre,
	   avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10


--Check if there is correlation between the length of the app description and the user rating

SELECT CASE
		WHEN length(b.app_desc) < 500 THEN 'Short'
        WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Long'
        END AS description_length_bucket,
        AVG(a.user_rating) AS Avg_Rating
FROM 
	AppleStore as a
JOIN
	appleStore_description_combined AS b
ON a.id = b.id
GROUP BY description_length_bucket
ORDER BY Avg_Rating DESC


--Check the top-rated apps for each genre 

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
  		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
        FROM
        AppleStore
      ) AS a     
WHERE a.rank = 1


/* FINAL RECOMMENDATIONS 

1. Paid apps have better ratings
2. Apps supporting between 10 and 30 languages have better ratings
3. Finance and book apps have low ratings > shows good market opportunity here
4. Apps with a longer description have better ratings
5. A new app should aim for an average rating above 3.5
6. Games and entertainment have high competition 

*/
