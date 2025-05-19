# Cowrywise Data Analytics Assessment
This project explored various businesses use cases through SQL queries using the provided data.


## Questions and Approaches

### Question 1: High-Value Customers with Multiple Products

***Scenario:*** 
The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).\

<ins>Objective:</ins>
Identify customers with both a funded savings plann and a funded investment plan, sorted by total deposits.\

**Approach:**
- Used the `users_customuser`, `plans_plan` and `savings_savingsaccount` tables.
- Grouped by `owner_id` and concatenated first/last names to get the full name as the fullname column was mostly NULLS
- Used a `CASE` statement to differentiate savings and investments plans
- Sorted by total deposits


### Question 2: Transaction Frequency Analysis

***Scenario:*** 
The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).\

<ins>Objective:</ins>
Segment customers into High, Medium or Low frequency users based on their average monthly transactions.\

**Approach:**
- Used only the `users_customuser` and `savings_savingsaccount` tables.
- Built a CTE to:
  - Count successful transactions
  - Calculate tenure in months using TIMESTAMPDIFF
  - Calculate avg_tx_oer_month
- In the main query, applied CASE to classify customers
- Used NULLIF to avoid division by zero
- Filtered where only the transaction status was 'success' to count only valid activities


### Question 3: Account Inactivity Alert

***Scenario:*** 
The ops team wants to flag accounts with no inflow transactions for over one year.\

<ins>Objective:</ins>
Find accounts (savings or investments) with no transactions in the last 365 days.\

**Approach:**
- Used only the `plans_plan` and `savings_savingsaccount` tables.
- Grouped by plan_id and checked the last transaction date using MAX(transaction_date)
- Calculated inactivity using `DATEDIFF`
- Flagged accounts where `inactivity > 365 days`
- Mapped account type
**Note: All plans were treated as active unless specified otherwise.**


### Question 4: Customer Lifetime Value (CLV) Estimation

***Scenario:*** 
Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).\

<ins>Objective:</ins>
Esimate CLV using a simplified model:\
-     CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction\
Where profit is 0.1% of the transaction value.

**Approach:**
- Used only the `users_user` and `savings_savingsaccount` tables.
- Calculated the average transaction size
- Rounded the results to 2 decimal places

> [!NOTE]
> The confirmed_amount was converted to naira (vaues were given in kobo).


## Challenges and Solutions
| Challenge | SOlution |
| --- | --- |
| SQL Syntax Errors (especially in `CASE` + `COUNT` | Carefully reviewed SQL logic and ensured parentheses and all aliases were correct |
| Dealing with zero-month tenures (division by zero) | Used `NULLIF()` to handle zero-month scenarios |
| Kobo vs. Naira conversion | Standardized all monetary fields by dividing by 100 in all aggregations |
| JOIN confusion between savings and investments accounts | Applied hints: `is_a_fund = 1` for investments, `is_regular_savings = 1` for savings |
| Missplelled columns | Double checked column named and corrected typos |

