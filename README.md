Advanced SQL Project and Query Optimization P
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- Advanced SQL Project using Spotify Dataset
USE advanced_sql;
-- Creating Table
CREATE TABLE spotify(
artist VARCHAR(150),
track VARCHAR(150),
album VARCHAR(155),
album_type VARCHAR(75),
danceability FLOAT,
energy FLOAT,
loudness FLOAT,
speechiness FLOAT,
acousticness FLOAT,
instrumentalness FLOAT,
liveness FLOAT,
valence	FLOAT,
tempo FLOAT,
duration_min FLOAT,
title VARCHAR(155),
channel VARCHAR(155),
views FLOAT,
likes BIGINT,
comments BIGINT,
licensed BOOLEAN,
official_video BOOLEAN,
Stream BIGINT,
energyLiveness FLOAT,
most_playedon VARCHAR(75)
);
SELECT * FROM spotify;

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/janan/Documents/Spotify-Data-Analysis-using-SQL/cleaned_dataset.csv'
INTO TABLE spotify
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @artist,
    @track,
    @album,
    @album_type,
    @danceability,
    @energy,
    @loudness,
    @speechiness,
    @acousticness,
    @instrumentalness,
    @liveness,
    @valence,
    @tempo,
    @duration_min,
    @title,
    @channel,
    @views,
    @likes,
    @comments,
    @licensed,
    @official_video,
    @Stream,
    @energyLiveness,
    @most_playedon
)
SET
    artist = NULLIF(@artist, ''),
    track = NULLIF(@track, ''),
    album = NULLIF(@album, ''),
    album_type = NULLIF(@album_type, ''),
    danceability = NULLIF(@danceability, ''),
    energy = NULLIF(@energy, ''),
    loudness = NULLIF(@loudness, ''),
    speechiness = NULLIF(@speechiness, ''),
    acousticness = NULLIF(@acousticness, ''),
    instrumentalness = NULLIF(@instrumentalness, ''),
    liveness = NULLIF(@liveness, ''),
    valence = NULLIF(@valence, ''),
    tempo = NULLIF(@tempo, ''),
    duration_min = NULLIF(@duration_min, ''),
    title = NULLIF(@title, ''),
    channel = NULLIF(@channel, ''),
    views = NULLIF(@views, ''),
    likes = NULLIF(@likes, ''),
    comments = NULLIF(@comments, ''),
    licensed = NULLIF(@licensed, ''),
    official_video = NULLIF(@official_video, ''),
    Stream = NULLIF(@Stream, ''),
    energyLiveness = NULLIF(@energyLiveness, ''),
    most_playedon = NULLIF(@most_playedon, '');
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.


**-- Easy Level**
**1. Retrieve the names of all tracks that have more than 1 billion streams.**
```sql
SELECT track, Stream FROM spotify
WHERE Stream > 1000000000;
```

**2. List all albums along with their respective artists.**
```sql
SELECT album, artist
FROM spotify;
```

**3. Get the total number of comments for tracks where licensed = TRUE.**
```sql
SELECT SUM(comments) AS total_comments FROM spotify
WHERE licensed = 'TRUE';
```

** 4. Find all tracks that belong to the album type single.**
```sql
SELECT track, album FROM spotify
WHERE album_type = 'Single';
```

**5. Count the total number of tracks by each artist.**
```sql
SELECT artist, COUNT(track) AS total_number_of_songs FROM spotify
GROUP BY artist
ORDER BY total_number_of_songs;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where `official_video = TRUE`.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

**Medium Level**
**6. Calculate the average danceability of tracks in each album.**
```sql
SELECT album, ROUND(AVG(danceability),2) AS average_danceability FROM spotify
GROUP BY album
ORDER BY average_danceability DESC;
```

**7. Find the top 5 tracks with the highest energy values.**
```sql
SELECT track, energy FROM spotify
ORDER BY energy DESC
LIMIT 5;
```

**8. List all tracks along with their views and likes where official_video = TRUE.**
```sql
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY track
;
```

**9. For each album, calculate the total views of all associated tracks.**
```sql
SELECT album, track, SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;
```

**10. Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
UPDATE spotify
SET most_playedon = TRIM(REPLACE(most_playedon, '\r', ''));

SELECT
    track,
    SUM(CASE WHEN most_playedon = 'Spotify'
             THEN Stream ELSE 0 END) AS spotify_streams,
    SUM(CASE WHEN most_playedon = 'Youtube'
             THEN Stream ELSE 0 END) AS youtube_streams
FROM spotify
GROUP BY track
HAVING spotify_streams > youtube_streams
 AND youtube_streams <> 0;
 ```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Write a query to find tracks where the liveness score is above the average.
3. Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.
4. Find tracks where the energy-to-liveness ratio is greater than 1.2. 
5. Find tracks where the energy-to-liveness ratio is greater than 1.2.
6. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

**Advanced Level**

**11. Find the top 3 most-viewed tracks for each artist using window functions.**
```sql
WITH ranking_artists
AS
(
SELECT artist, track, SUM(views) AS total_views,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS ranks
FROM spotify
GROUP BY artist, track
ORDER BY artist, total_views DESC
)
SELECT * FROM ranking_artists
WHERE ranks <=3;
```

**12. Write a query to find tracks where the liveness score is above the average.**
```sql
SELECT track, album, artist, liveness FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

**13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(
SELECT album, MAX(energy) as highest_energy_value, MIN(energy) AS lowest_energy_value
FROM spotify
GROUP BY album
)
SELECT album, (highest_energy_value-lowest_energy_value) AS energy_difference
FROM cte
WHERE (highest_energy_value-lowest_energy_value) <> 0;
```

**14. Find tracks where the energy-to-liveness ratio is greater than 1.2.**
```sql
SELECT track, album, energyLiveness FROM spotify
WHERE ROUND(energyLiveness,2) > 1.20
ORDER BY energyLiveness;
```

**15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.**
```sql
SELECT track, views, likes,
SUM(likes) OVER (ORDER BY views DESC) AS total_likes
FROM spotify
ORDER BY views DESC;
```

---



## Technology Stack
- **Database**: MySQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions


## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

