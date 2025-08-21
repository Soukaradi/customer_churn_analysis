import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import datetime, timedelta

# Initialize Faker
fake = Faker()

# --- 1. Generate CUSTOMERS Data with correlated churn ---
num_customers = 10000
customers_list = []

# Define churn probabilities based on a combination of factors
# Base churn rate for each plan
plan_churn_probs = {'Basic': 0.15, 'Standard': 0.25, 'Premium': 0.35}

for i in range(1, num_customers + 1):
    # Determine base churn probability based on plan
    plan_type = random.choice(['Basic', 'Standard', 'Premium'])
    base_churn_prob = plan_churn_probs[plan_type]

    # Adjust probability based on age group
    age = random.randint(18, 65)
    if age >= 55:
        base_churn_prob += 0.05  # Older customers slightly more likely to churn
    
    # Generate churn status based on adjusted probability
    is_churned = np.random.choice([0, 1], p=[1 - base_churn_prob, base_churn_prob])
    
    join_date = fake.date_between(start_date='-2y', end_date='-6M')
    churn_date = fake.date_between(start_date='-5M', end_date='-1M') if is_churned == 1 else None
    
    customers_list.append({
        'customer_id': i,
        'age': age,
        'country': fake.country(),
        'gender': random.choice(['Male', 'Female', 'Non-binary']),
        'is_churned': is_churned,
        'join_date': join_date,
        'churn_date': churn_date,
        'plan_type': plan_type  # Temporarily store plan for easier analysis below
    })
    
customers_df = pd.DataFrame(customers_list)
customers_df.loc[customers_df.sample(frac=0.02).index, 'age'] = None

# --- 2. Generate SUBSCRIPTIONS Data ---
subscriptions_data = {
    'subscription_id': [fake.uuid4() for _ in range(num_customers)],
    'customer_id': customers_df['customer_id'],
    'plan_type': customers_df['plan_type'],
    'monthly_cost': [
        {'Basic': 9.99, 'Standard': 14.99, 'Premium': 19.99}[p]
        for p in customers_df['plan_type']
    ],
    'subscription_start_date': customers_df['join_date'],
    'subscription_end_date': customers_df['churn_date']
}
subscriptions_df = pd.DataFrame(subscriptions_data)

# --- 3. Generate USAGE_HISTORY Data with correlated churn ---
num_usage_records = 50000
usage_list = []
for _ in range(num_usage_records):
    customer_id = random.choice(customers_df['customer_id'])
    customer_info = customers_df.loc[customers_df['customer_id'] == customer_id].iloc[0]
    
    # Correlate minutes watched with churn status
    if customer_info['is_churned'] == 1:
        minutes_watched = random.randint(10, 200)  # Lower range for churned users
    else:
        minutes_watched = random.randint(100, 500)  # Higher range for active users

    # Correlate device with churn status
    device = random.choice(['Mobile', 'Smart TV', 'Laptop', 'Tablet'])
    if customer_info['is_churned'] == 1 and random.random() < 0.4:
        device = 'Tablet' # More likely to be 'Tablet' for churned users
        
    # Correlate genre with churn status
    genre = random.choice(['Action', 'Comedy', 'Drama', 'Sci-Fi', 'Documentary'])
    if customer_info['is_churned'] == 1 and random.random() < 0.3:
        # Churned customers are less likely to be watching documentaries
        genre = random.choice(['Action', 'Comedy'])
        
    usage_list.append({
        'usage_id': _,
        'customer_id': customer_id,
        'minutes_watched': minutes_watched,
        'genre': genre,
        'device': device
    })
    
usage_df = pd.DataFrame(usage_list)

# --- 4. Generate SUPPORT_TICKETS Data with correlated churn ---
num_tickets = 5000
tickets_list = []
for _ in range(num_tickets):
    customer_id = random.choice(customers_df['customer_id'])
    customer_info = customers_df.loc[customers_df['customer_id'] == customer_id].iloc[0]

    ticket_date = fake.date_between(start_date='-1y', end_date='now')
    issue_type = random.choice(['Billing', 'Technical', 'Content', 'Account'])
    
    # Correlate resolution time and status with churn
    if customer_info['is_churned'] == 1:
        resolution_time_days = random.randint(5, 20)  # Longer resolution time for churned users
        is_resolved = np.random.choice([0, 1], p=[0.4, 0.6]) # Less likely to be resolved
    else:
        resolution_time_days = random.randint(1, 7)
        is_resolved = np.random.choice([0, 1], p=[0.1, 0.9])
        
    tickets_list.append({
        'ticket_id': _,
        'customer_id': customer_id,
        'ticket_date': ticket_date,
        'issue_type': issue_type,
        'resolution_time_days': resolution_time_days,
        'is_resolved': is_resolved
    })
    
tickets_df = pd.DataFrame(tickets_list)

# Drop the temporary 'plan_type' column from customers_df before saving
customers_df = customers_df.drop(columns=['plan_type'])

# Save to CSV files for easy SQL import
customers_df.to_csv('customers.csv', index=False)
subscriptions_df.to_csv('subscriptions.csv', index=False)
usage_df.to_csv('usage_history.csv', index=False)
tickets_df.to_csv('support_tickets.csv', index=False)

print("Data generation with correlated variations complete. New CSV files created.")