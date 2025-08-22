CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY,
    age INT,
    country VARCHAR(255),
    gender VARCHAR(50),
    is_churned BOOLEAN,
    join_date DATE,
    churn_date DATE
);


CREATE TABLE SUBSCRIPTIONS (
    subscription_id VARCHAR(255) PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_type VARCHAR(100),
    monthly_cost DECIMAL(10, 2),
    subscription_start_date DATE,
    subscription_end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);


CREATE TABLE USAGE_HISTORY (
    usage_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    minutes_watched INT,
    genre VARCHAR(100),
    device VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);


CREATE TABLE SUPPORT_TICKETS (
    ticket_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    ticket_date DATE,
    issue_type VARCHAR(100),
    resolution_time_days INT,
    is_resolved BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);

