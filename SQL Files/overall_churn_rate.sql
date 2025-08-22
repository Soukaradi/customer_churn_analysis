SELECT
    CAST(SUM(CASE WHEN is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(customer_id) AS overall_churn_rate
FROM
    CUSTOMERS;
