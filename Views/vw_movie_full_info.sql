CREATE OR REPLACE VIEW vw_movie_full_info AS
SELECT
    m.movies_id,
    m.movie_title,
    m.movie_link,
    mi.original_release_dt,
    mi.streaming_release_dt,
    mi.runtime,
    d.directors,
    a.authors,
    p.production_company,
    ac.actors,
    g.genres,
    ar.rating AS age_rating
FROM
    movies m
INNER JOIN
    movie_info mi ON m.movies_id = mi.movies_id
LEFT JOIN
    directors d ON mi.directors_id = d.directors_id
LEFT JOIN
    authors a ON mi.authors_id = a.authors_id
LEFT JOIN
    production p ON mi.production_id = p.production_id
LEFT JOIN
    actors ac ON mi.actors_id = ac.actors_id
LEFT JOIN
    genres g ON mi.genres_id = g.genres_id
LEFT JOIN
    age_rating ar ON mi.rating_id = ar.rating_id;
