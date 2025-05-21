CREATE OR REPLACE VIEW vw_genre_audience_sweetness_avg AS
SELECT
    g.genres,
    ROUND(AVG(ar.sweetness_index), 2) AS avg_audience_sweetness,
    COUNT(m.movies_id) AS movie_count
FROM
    movies m
JOIN
    movie_info mi ON m.movies_id = mi.movies_id
JOIN
    genres g ON mi.genres_id = g.genres_id
JOIN
    audience_ratings ar ON m.movies_id = ar.movies_id
GROUP BY
    g.genres
ORDER BY
    avg_audience_sweetness DESC;
