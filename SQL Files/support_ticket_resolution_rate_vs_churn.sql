SELECT
    CASE
        WHEN st.resolution_time_days <= 2 THEN 'Quickly Resolved'
        WHEN st.resolution_time_days > 2 AND st.resolution_time_days <= 7 THEN 'Average Resolution'
        ELSE 'Slow Resolution'
    END AS resolution_category,
    COUNT(c.customer_id) AS total_customers,
    SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(c.customer_id) AS churn_rate
FROM
    CUSTOMERS c
JOIN
    SUPPORT_TICKETS st ON c.customer_id = st.customer_id
WHERE
    st.is_resolved = TRUE
GROUP BY
    resolution_category;

