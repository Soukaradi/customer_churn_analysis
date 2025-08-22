SELECT
    uh.device,
    COUNT(uh.customer_id) AS total_sessions,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(c.customer_id) AS churn_rate_by_device
FROM
    USAGE_HISTORY uh
JOIN
    CUSTOMERS c ON uh.customer_id = c.customer_id
GROUP BY
    uh.device
ORDER BY
    churn_rate_by_device DESC;
