
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
-- EDA

SELECT * FROM spotify;
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT COUNT(DISTINCT track) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SET SQL_SAFE_UPDATES = 0;

SELECT DISTINCT channel FROM spotify;
SELECT DISTINCT most_playedon FROM spotify;

-- Easy Level
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track, Stream FROM spotify
WHERE Stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT album, artist
FROM spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_comments FROM spotify
WHERE licensed = 'TRUE';

-- 4. Find all tracks that belong to the album type single.
SELECT track, album FROM spotify
WHERE album_type = 'Single';

-- 5. Count the total number of tracks by each artist.

SELECT artist, COUNT(track) AS total_number_of_songs FROM spotify
GROUP BY artist
ORDER BY total_number_of_songs;
------------------------------- 
-- Medium Level
-- 6. Calculate the average danceability of tracks in each album.
SELECT album, ROUND(AVG(danceability),2) AS average_danceability FROM spotify
GROUP BY album
ORDER BY average_danceability DESC;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT track, energy FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY track
;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT album, track, SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
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
 
 -- Advanced Level
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
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

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT track, album, artist, liveness FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT track, album, energyLiveness FROM spotify
WHERE ROUND(energyLiveness,2) > 1.20
ORDER BY energyLiveness;

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT track, views, likes,
SUM(likes) OVER (ORDER BY views DESC) AS total_likes
FROM spotify
ORDER BY views DESC;



