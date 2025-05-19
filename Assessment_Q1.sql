SELECT 
	p.owner_id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE 
		WHEN p.is_regular_savings = 1  AND s.confirmed_amount > 0 THEN s.id END) AS savings_count,
    COUNT(DISTINCT CASE 
		WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN s.id END) AS investment_count,
    ROUND(SUM(CASE
		WHEN s.confirmed_amount > 0 THEN s.confirmed_amount
        ELSE 0
	END) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE s.transaction_status = 'success'
GROUP BY p.owner_id, name
HAVING
	savings_count > 0 AND
    investment_count > 0
    ORDER BY total_deposits DESC;