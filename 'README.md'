# Museum Database SQL Queries

This repository contains SQL scripts for querying a museum database to extract various insights.

## Tables

### dbo.museum$
- `museum_id`: Unique identifier.
- `name`: Museum name.
- `city`: City.
- `state`: State.
- `country`: Country.

### dbo.museum_hours$
- `museum_id`: Unique identifier.
- `day`: Day of the week.
- `open`: Opening time.
- `close`: Closing time.

## SQL Queries

### 1. Overview of All Data in Tables

```sql
SELECT * FROM dbo.museum$;
SELECT * FROM dbo.museum_hours$;
```

### 2. Museums Open on Both Sunday and Monday

```sql
SELECT dbm.name, dbm.city
FROM dbo.museum$ dbm
JOIN dbo.museum_hours$ dbmh ON dbm.museum_id = dbmh.museum_id
WHERE dbmh.day LIKE 'Sunday'
AND EXISTS (
    SELECT 1 FROM dbo.museum_hours$ dbmh2
    WHERE dbmh2.museum_id = dbmh.museum_id
    AND dbmh2.day LIKE 'Monday'
);
```

### 3. Museum Open for the Longest Duration in a Day

```sql
WITH high_ranked AS (
    SELECT TOP 1 *,
        TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([open], ':AM', ' AM')) AS open_datetime,
        TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([close], ':PM', ' PM')) AS close_datetime,
        DATEDIFF(HOUR, 
            TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([open], ':AM', ' AM')), 
            TRY_CONVERT(DATETIME, '2023-01-01 ' + REPLACE([close], ':PM', ' PM'))
        ) AS hour_diff
    FROM dbo.museum_hours$
    ORDER BY hour_diff DESC
)
SELECT hrm.hour_diff, hrm.day, ms.name, ms.state 
FROM high_ranked hrm
JOIN dbo.museum$ ms ON hrm.museum_id = ms.museum_id;
```

### 4. Country and City with the Most Museums

```sql
WITH countryhighest AS (
    SELECT country, COUNT(*) AS country_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS RNK
    FROM dbo.museum$
    GROUP BY country
),
cityhighest AS (
    SELECT city, COUNT(*) AS city_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS RNK
    FROM dbo.museum$
    GROUP BY city
)
SELECT country, city
FROM countryhighest 
CROSS JOIN cityhighest
WHERE countryhighest.RNK = 1 AND cityhighest.RNK = 1;
```

## Usage

1. **Overview Queries**: Get all data from `dbo.museum$` and `dbo.museum_hours$`.
2. **Museums Open on Specific Days**: Identify museums open on both Sunday and Monday.
3. **Longest Open Museum**: Find the museum open the longest in a single day.
4. **Top Locations**: Find the country and city with the most museums.

## Conclusion

These queries provide key insights into the museum database. Modify and extend as needed for further analysis.
