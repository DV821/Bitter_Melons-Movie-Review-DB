CREATE OR REPLACE VIEW vw_critic_audience_rating_summary AS
SELECT
    m.movie_title,    cr.sweetness_index AS critics_sweetness_index,
    (SELECT rating from ratings where rating_id = cr.melon_certification) AS critics_certification,
    ar.sweetness_index as audience_sweetness_index,
    (SELECT rating from ratings where rating_id = ar.melon_certification) as melon_certification
FROM
    movies m
LEFT JOIN
    critic_ratings cr ON m.movies_id = cr.movies_id
LEFT JOIN
    audience_ratings ar ON m.movies_id = ar.movies_id;
