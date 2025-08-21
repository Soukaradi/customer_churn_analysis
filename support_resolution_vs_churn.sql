SELECT
    st.is_resolved,
    COUNT(c.customer_id) AS total_customers,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(c.customer_id) AS churn_rate
FROM
    CUSTOMERS c
JOIN
    SUPPORT_TICKETS st ON c.customer_id = st.customer_id
GROUP BY
    st.is_resolved;