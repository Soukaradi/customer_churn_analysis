SELECT
    s.plan_type,
    COUNT(c.customer_id) AS total_customers,
    SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(c.customer_id) AS churn_rate_by_plan
FROM
    CUSTOMERS c
JOIN
    SUBSCRIPTIONS s ON c.customer_id = s.customer_id
GROUP BY
    s.plan_type
ORDER BY
    churn_rate_by_plan DESC;