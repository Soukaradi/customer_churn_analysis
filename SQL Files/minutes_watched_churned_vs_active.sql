SELECT
    c.is_churned,
    AVG(uh.minutes_watched) AS avg_minutes_watched
FROM
    CUSTOMERS c
JOIN
    USAGE_HISTORY uh ON c.customer_id = uh.customer_id
GROUP BY
    c.is_churned;
