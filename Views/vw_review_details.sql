CREATE OR REPLACE VIEW vw_review_details AS
SELECT
    r.review_id,
    m.movie_title,
    c.critic_name,
    p.publisher_name,
    (SELECT rating from ratings where rating_id = r.review_type) as review_type,
    r.review_date,
    r.review_content
FROM
    reviews r
INNER JOIN
    movies m ON r.movies_id = m.movies_id
INNER JOIN
    critics c ON r.critic_id = c.critic_id
INNER JOIN
    publishers p ON r.publisher_id = p.publisher_id;