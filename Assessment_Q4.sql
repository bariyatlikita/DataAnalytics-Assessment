SELECT 
	u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
		(COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) * 12 * (0.001 * AVG(s.confirmed_amount / 100)), 
        2
	) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id 
WHERE s.transaction_status = 'success' 
	AND s.confirmed_amount > 0
GROUP BY u.id, name, tenure_months
ORDER BY estimated_clv DESC;