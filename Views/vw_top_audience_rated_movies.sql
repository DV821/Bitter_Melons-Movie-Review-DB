CREATE OR REPLACE VIEW vw_top_audience_rated_movies AS
SELECT
    m.movie_title,
    ar.sweetness_index,
    ar.audience_count
FROM
    movies m
INNER JOIN
    audience_ratings ar ON m.movies_id = ar.movies_id
WHERE
    ar.sweetness_index IS NOT NULL
ORDER BY
    ar.sweetness_index DESC
LIMIT 20;
