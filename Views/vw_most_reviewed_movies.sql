CREATE OR REPLACE VIEW vw_most_reviewed_movies AS
SELECT
    m.movie_title,
    COUNT(r.review_id) AS total_reviews
FROM
    movies m
JOIN
    reviews r ON m.movies_id = r.movies_id
GROUP BY
    m.movies_id, m.movie_title
ORDER BY
    total_reviews DESC;
