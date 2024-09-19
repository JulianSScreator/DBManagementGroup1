SELECT 
    mi.movie_title, 
    mi.worldwide_box_office,
	mi.international_box_office,
	mi.domestic_box_office,
    COUNT(er.id) AS total_expert_reviews, 
    AVG(CASE 
            WHEN er.individual_score ~ '^[0-9.]+$' THEN CAST(er.individual_score AS numeric) 
            ELSE NULL 
        END) AS avg_expert_score,
    AVG(CASE 
            WHEN er.positive_emotion ~ '^[0-9.]+$' THEN CAST(er.positive_emotion AS numeric) 
            ELSE NULL 
        END) AS avg_positive_emotion 
FROM 
    movie_info mi
JOIN 
    expert_reviews er ON mi.id = er.movie_id
GROUP BY 
    mi.id
ORDER BY 
    total_expert_reviews DESC;

