SELECT
    uh.genre,
    AVG(uh.minutes_watched) AS avg_minutes_watched,
    COUNT(uh.customer_id) AS total_sessions
FROM
    USAGE_HISTORY uh
JOIN
    CUSTOMERS c ON uh.customer_id = c.customer_id
WHERE
    c.is_churned = TRUE
GROUP BY
    uh.genre
ORDER BY
    avg_minutes_watched DESC;