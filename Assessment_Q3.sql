SELECT 
	p.id AS plan_id,
    p.owner_id,
    CASE
		WHEN p.is_a_fund = 1 THEN 'Investment'
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        ELSE 'Other'
	END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE s.transaction_status = 'success' 
	AND s.confirmed_amount > 0
GROUP BY p.id, p.owner_id, type
HAVING DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365
ORDER BY inactivity_days DESC;