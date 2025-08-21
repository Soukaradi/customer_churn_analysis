📊 StreamVerse Customer Churn Analysis & Retention Strategy
Welcome to the StreamVerse Customer Churn Analysis project! This repository dives deep into why customers leave a fictional subscription-based streaming service, "StreamVerse," and proposes data-driven strategies to keep them happy and subscribed.

🚀 About This Project: Keeping Our Customers Hooked!
Have you ever wondered why some people cancel their streaming subscriptions while others stay loyal for years? That's the core question this project aims to answer! For any subscription business like StreamVerse, customer churn (when customers leave) is a major challenge. It directly impacts revenue and growth. My goal here is to dig into customer behavior data, spot the early warning signs of churn, and come up with smart, proactive ways to retain our valuable customers. It's all about turning data into actionable insights to boost customer lifetime value!

🎯 Project Scope: Our Data Detective Work
This project is a full end-to-end journey in data analytics, focusing on customer data from StreamVerse. Here's what we covered:

Generating Realistic Data: Crafting synthetic, yet realistic, data covering customer demographics, subscription history, usage patterns, and even support interactions. We made sure this data had built-in "clues" about churn!

Database Design: Setting up a structured relational database to store all this rich information efficiently.

SQL Power: Using SQL queries to clean, transform, and analyze the data, unearthing the key indicators that signal churn.

KPI Tracking: Calculating vital metrics like overall churn rate, average subscription duration, and feature usage.

Strategic Solutions: Developing concrete business recommendations and a retention strategy based on our findings.

🧪 Data Generation: Bringing StreamVerse to Life with Python
To kick things off, I used Python's pandas for data handling and Faker to generate synthetic, interconnected datasets. The trick here was to build in realistic variations and correlations right from the start. For example, customers on the 'Premium' plan were given a higher likelihood of churning, and those with unresolved support tickets were more prone to leave. This ensures our analysis reveals genuine, actionable insights rather than uniform results.

Key Data Points Generated:

CUSTOMERS: Demographics (age, country, gender), join date, and crucial is_churned/churn_date flags, with churn probability linked to their plan.

SUBSCRIPTIONS: Details on subscription plans (Basic, Standard, Premium), monthly cost, and start/end dates.

USAGE_HISTORY: Minutes watched, favorite genres, and devices used, with lower usage correlating with churn.

SUPPORT_TICKETS: Information on customer issues, resolution times, and whether the issue was resolved, with unresolved/long-resolution tickets correlating with churn.

All this data is saved into CSV files, ready for database import!

💾 Database Setup: PostgreSQL Powerhouse
The generated data needs a home! I designed a relational database schema in PostgreSQL to meticulously track every aspect of a customer's journey.

Tables Created:

CUSTOMERS

SUBSCRIPTIONS

USAGE_HISTORY

SUPPORT_TICKETS

To Replicate the Database Setup:

Install PostgreSQL: Ensure you have PostgreSQL installed and running.

Create Database: Connect to psql and run: CREATE DATABASE project_1;

Connect to Database: \c project_1;

Create Tables: Execute the CREATE TABLE statements (provided in the project notebook/files) for CUSTOMERS, SUBSCRIPTIONS, USAGE_HISTORY, and SUPPORT_TICKETS.

Import Data: Run the Python data generation script to get the CSVs. Then, use the COPY command (remember to replace /path/to/your/csv_files/ with your actual path):

TRUNCATE TABLE customers CASCADE; -- Clear existing data safely
COPY customers FROM 'C:/Users/Dell/SQL project/customers.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');
COPY subscriptions FROM 'C:/Users/Dell/SQL project/subscriptions.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');
COPY usage_history FROM 'C:/Users/Dell/SQL project/usage_history.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');
COPY support_tickets FROM 'C:/Users/Dell/SQL project/support_tickets.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

🔍 Key Analyses & Insights: What the Data is Whispering
Here are some of the critical SQL queries used and the sample varied outputs they produced, showcasing the deep insights uncovered by our refined data generation.

1. Overall Churn Rate
Purpose: A foundational KPI to understand the overall health of our customer base.

SQL Query:

SELECT
    CAST(SUM(CASE WHEN is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(customer_id) AS overall_churn_rate
FROM
    CUSTOMERS;

Sample Output:
| overall_churn_rate |
|--------------------|
| 0.2655             |

2. Churn Rate by Subscription Plan
Purpose: To identify if certain subscription plans are more susceptible to churn.

SQL Query:

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

Sample Output:
| plan_type | total_customers | churned_customers | churn_rate_by_plan |
|-----------|-----------------|-------------------|--------------------|
| Premium   | 3350            | 1206              | 0.3600             |
| Standard  | 3300            | 825               | 0.2500             |
| Basic     | 3350            | 502               | 0.1500             |
Insight: Clearly, Premium plan users churn at a significantly higher rate (36%) compared to Basic (15%) and Standard (25%). This suggests a major issue with the Premium plan's value proposition.

3. Average Minutes Watched for Churned vs. Active Customers
Purpose: To uncover behavioral patterns related to content engagement among different customer groups.

SQL Query:

SELECT
    c.is_churned,
    AVG(uh.minutes_watched) AS avg_minutes_watched
FROM
    CUSTOMERS c
JOIN
    USAGE_HISTORY uh ON c.customer_id = uh.customer_id
GROUP BY
    c.is_churned;

Sample Output:
| is_churned | avg_minutes_watched |
|------------|---------------------|
| FALSE      | 350.12              |
| TRUE       | 125.89              |
Insight: Churned customers watch significantly fewer minutes (avg 125.89) than active customers (avg 350.12). This is a strong indicator that disengagement precedes churn.

4. Churn Rate by Customer Demographics (Age Group)
Purpose: To understand if certain age groups are more prone to churn.

SQL Query:

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
WHERE age IS NOT NULL -- Exclude customers with missing age data
GROUP BY
    age_group
ORDER BY
    churn_rate DESC;

Sample Output:
| age_group | total_customers | churn_rate |
|-----------|-----------------|------------|
| 55+       | 1500            | 0.32       |
| 45-54     | 2000            | 0.27       |
| 35-44     | 2500            | 0.25       |
| 25-34     | 2000            | 0.23       |
| 18-24     | 1800            | 0.20       |
Insight: The 55+ age group exhibits a slightly higher churn rate, suggesting potential challenges in catering to older demographics (e.g., content preferences, ease of use).

5. Most Watched Genres by Churned Customers (vs. Overall)
Purpose: To identify if content preferences or gaps correlate with churn.

SQL Query:

SELECT
    uh.genre,
    AVG(uh.minutes_watched) AS avg_minutes_watched,
    COUNT(uh.customer_id) AS total_sessions_churned
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

Sample Output (for Churned Customers):
| genre       | avg_minutes_watched | total_sessions_churned |
|-------------|---------------------|------------------------|
| Action      | 135.2               | 2500                   |
| Comedy      | 130.5               | 2200                   |
| Sci-Fi      | 128.0               | 1800                   |
| Drama       | 120.1               | 2000                   |
| Documentary | 95.0                | 500                    |
Insight: While churned customers watch less overall, their engagement with Documentary content is notably lower compared to other genres. This could indicate a content gap or dissatisfaction within this specific genre for those who decide to leave.

6. Churn Based on Device Usage
Purpose: To see if a particular device type is associated with higher churn rates, pointing to potential UX/performance issues.

SQL Query:

SELECT
    uh.device,
    COUNT(uh.customer_id) AS total_sessions,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(DISTINCT uh.customer_id) AS churn_rate_by_device
FROM
    USAGE_HISTORY uh
JOIN
    CUSTOMERS c ON uh.customer_id = c.customer_id
GROUP BY
    uh.device
ORDER BY
    churn_rate_by_device DESC;

Sample Output:
| device    | total_sessions | churn_rate_by_device |
|-----------|----------------|----------------------|
| Tablet    | 12000          | 0.35                 |
| Mobile    | 15000          | 0.28                 |
| Laptop    | 10000          | 0.24                 |
| Smart TV  | 13000          | 0.20                 |
Insight: Users primarily watching on Tablet devices have a noticeably higher churn rate. This strongly suggests a potentially suboptimal user experience or technical issues specifically on the tablet platform.

7. Churn Rate Based on Support Ticket Resolution Time
Purpose: To understand the impact of customer service efficiency on churn.

SQL Query:

SELECT
    CASE
        WHEN st.resolution_time_days <= 2 THEN 'Quickly Resolved (<3 days)'
        WHEN st.resolution_time_days > 2 AND st.resolution_time_days <= 7 THEN 'Average Resolution (3-7 days)'
        ELSE 'Slow Resolution (>7 days)'
    END AS resolution_category,
    COUNT(c.customer_id) AS total_customers_with_tickets,
    CAST(SUM(CASE WHEN c.is_churned = TRUE THEN 1 ELSE 0 END) AS REAL) / COUNT(c.customer_id) AS churn_rate
FROM
    CUSTOMERS c
JOIN
    SUPPORT_TICKETS st ON c.customer_id = st.customer_id
WHERE
    st.is_resolved = TRUE -- Focusing on resolved tickets to see impact of resolution time
GROUP BY
    resolution_category
ORDER BY
    churn_rate DESC;

Sample Output:
| resolution_category    | total_customers_with_tickets | churn_rate |
|------------------------|------------------------------|------------|
| Slow Resolution (>7 days) | 1000                         | 0.45       |
| Average Resolution (3-7 days) | 2500                         | 0.28       |
| Quickly Resolved (<3 days) | 1500                         | 0.18       |
Insight: Customers whose issues take longer to resolve (>7 days) have a significantly higher churn rate. This directly links poor customer service response times to customer attrition.

💡 Driving Insights: What Our Data is Truly Telling Us
Our deep dive into StreamVerse's customer data paints a clear picture: churn isn't a mystery; it's a direct response to specific pain points. The data reveals that our churn problem stems from a blend of:

Value Perception Mismatch: Especially for our Premium users, the perceived value isn't matching the higher cost, leading to dissatisfaction.

Disengagement: Customers who stop actively using the service, especially watching content, are highly likely to leave.

Customer Service Failures: Slow or unresolved issues create immense frustration, pushing customers away.

Platform & Content Gaps: Specific device experiences (Tablets) and certain content genres (Documentary) might be underperforming, impacting retention.

By understanding these interconnected factors, we can move from reactive churn management to proactive retention strategies.

🛠️ Actionable Solutions: Turning Insights into Strategy
Here's how StreamVerse can leverage these insights to reduce churn and build a more loyal customer base:

Revamp the Premium Plan's Value (and Pricing!):

Offer a "Premium Lite": Introduce a mid-tier option for Premium users who might be price-sensitive but still desire some enhanced features, giving them an alternative to outright cancellation.

Exclusive Content & Perks: Invest in unique content or benefits truly exclusive to Premium subscribers. Think early access to new releases or special interactive features.

Proactive Engagement: Re-onboard new Premium users and regularly remind existing ones of the full suite of their benefits to ensure they're maximizing their value.

Ignite Re-engagement with Personalization:

Automated "We Miss You" Campaigns: Set up intelligent triggers. If a customer's watch time drops by a significant percentage (e.g., 50% in a month), automatically send personalized email or in-app recommendations based on their past viewing history.

Smart Notifications: Use push notifications for new episodes of their favorite shows, personalized genre suggestions, or even alerts about expiring content they might like.

Dynamic Homepages: Continuously optimize the user's homepage based on their real-time engagement, prominently featuring content likely to grab their attention.

Supercharge Customer Support:

Priority for At-Risk Customers: Implement a system to identify high-value or churn-prone customers with open tickets and route them to dedicated, faster-response support agents.

Empower Agents with Data: Provide support staff with a 360-degree view of the customer (plan, usage, past issues) to enable quicker, more informed resolutions, reducing customer frustration.

Closed-Loop Feedback: Implement automated follow-ups after ticket resolution to confirm satisfaction and identify any lingering issues.

Polish Platform Experience & Fill Content Voids:

Tablet UX Audit: Collaborate with product and engineering teams to thoroughly investigate the Tablet app's performance and user experience. User testing and bug reports should be prioritized.

Strategic Content Investment: Based on the lower engagement with Documentary content among churned users, evaluate the existing library and invest in acquiring or producing new, high-quality titles in that genre to better satisfy that segment and reduce churn.

🌱 Lessons Learned: My Growth Journey
This project was an incredible learning experience that solidified my understanding of the data analytics lifecycle. I gained hands-on expertise in:

Realistic Data Simulation: Moving beyond static datasets by building complex, interconnected data with intentional biases, a crucial skill for real-world scenarios.

Advanced SQL for Business Insights: I deepened my SQL proficiency, using sophisticated queries with CASE statements and JOIN operations to extract nuanced business intelligence, not just raw numbers.

Connecting Data to Strategy: The most rewarding part was translating analytical findings into clear, actionable business recommendations. It's about telling a compelling story with data that drives tangible impact.

Problem-Solving Mindset: This project reinforced the importance of iteratively refining data and analysis based on preliminary results, constantly asking "why" to uncover the true underlying issues.

This project has reinforced my passion for leveraging data to solve complex business challenges and ultimately help companies grow by building stronger customer relationships.
