--overview of all the the table
--
SELECT *
FROM dbo.museum$
--
SELECT *
FROM dbo.museum_hours$


---identify the museums which are open on both sunday and monday. Display museum name and city
SELECT dbm.name, dbm.city
FROM dbo.museum$ dbm
JOIN dbo.museum_hours$ dbmh
on dbm.museum_id = dbmh.museum_id
WHERE day LIKE 'Sunday'
AND EXISTS (SELECT 1 
FROM dbo.museum_hours$ dbmh2
WHERE dbmh2.museum_id = dbmh.museum_id
AND dbmh2.day LIKE 'Monday')

--Which museum is open for the longest during a day. display museum name, state and hours open and which day
WITH high_ranked AS (
  SELECT TOP 1
    *,
    TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([open], ':AM', ' AM')) AS open_datetime,
    TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([close], ':PM', ' PM')) AS close_datetime,
    DATEDIFF(HOUR, TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([open], ':AM', ' AM')), TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([close], ':PM', ' PM'))) AS hour_diff
FROM dbo.museum_hours$
ORDER BY hour_diff DESC
)

SELECT hrm.hour_diff, hrm.day, ms.name, ms.state 
FROM high_ranked hrm
JOIN dbo.museum$ ms
on hrm.museum_id = ms.museum_id

--Display the country and the city with most no. of museums.Output 2 separate columns to mention the city and country if there 
---are multiple values, separate with a coma
WITH countryhighest  AS
(
SELECT country, COUNT(*) AS country_count, RANK() OVER(ORDER BY COUNT(*) DESC) AS RNK
FROM dbo.museum$
GROUP BY country
),
 cityhighest AS
(
SELECT city, COUNT(*) AS city_count, RANK() OVER(ORDER BY COUNT(*) DESC) AS RNK
FROM dbo.museum$
GROUP BY city
)

SELECT country, city
FROM countryhighest 
CROSS JOIN cityhighest
WHERE countryhighest.RNK=1
AND cityhighest.RNK=1
