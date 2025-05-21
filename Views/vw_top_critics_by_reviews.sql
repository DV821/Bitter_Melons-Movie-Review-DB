CREATE OR REPLACE VIEW vw_top_critics_by_reviews AS
SELECT
    c.critic_name,
    c.top_critic,
    COUNT(r.review_id) AS total_reviews
FROM
    critics c
JOIN
    reviews r ON c.critic_id = r.critic_id
GROUP BY
    c.critic_id, c.critic_name, c.top_critic
ORDER BY
    total_reviews DESC;
