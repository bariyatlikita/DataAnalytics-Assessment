WITH user_transaction_summary AS (
	SELECT
		u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(s.id) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) +1 AS active_months,
        ROUND(COUNT(s.id) / (TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) +1), 2) AS avg_tx_per_month
	FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.transaction_status = 'success' 
		AND s.confirmed_amount > 0
    GROUP BY u.id
  )  
  
SELECT
	CASE
		WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
        WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
	END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM user_transaction_summary
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;