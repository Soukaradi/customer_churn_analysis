SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(customer_id) AS total_customers,
    CAST(SUM(CASE WHEN is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(customer_id) AS churn_rate
FROM
    CUSTOMERS
GROUP BY
    age_group
ORDER BY
    churn_rate DESC;
