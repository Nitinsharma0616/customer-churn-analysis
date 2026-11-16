create database sale;
use sale;
Show tables;

rename table chur_analysis_dataset to customer_churn;

-- Churn analysis project

/* Q1. What is the total number of records in our customer churn dataset?
*/
select  count(*)
from customer_churn;

/* Q2. Count the number of unique customers.
*/
select count(distinct customerID)
from customer_churn;

/* Q4. Are there any missing or blank customer IDs?
*/
select count(*) as missing_customer_ids
from customer_churn
where customerId is null
or trim(customerID) = '';

/* Q5. Check missing values in TotalCharges.
*/
select count(*) as missing_total_charges
from customer_churn
where TotalCharges is null;

/* Q6. Check both NULL and blank values in TotalCharges.
*/
select count(*) as missing_total_charges
from customer_churn
where TotalCharges is null
or trim(TotalCharges) = '';

/*Q7. Check for non-numeric values in TotalCharges.
*/
SELECT COUNT(*) AS non_numeric_total_charges
FROM customer_churn
WHERE TRIM(TotalCharges) <> ''
  AND TotalCharges IS NOT NULL
  AND TRIM(TotalCharges) NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
  
/* Q8. Check consistency in categorical columns.
*/
select distinct Contract
from customer_churn;

/* Q9. Check the distribution of customers across categories.
*/
select 
contract,
count(Contract) as Total_customers
from customer_churn
group by Contract
order by Total_customers desc;

/* Q10. Calculate the percentage of customers in each contract category.
*/
select
contract,
count(customerID) as total_customers,
round(
	count(customerID) * 100.0 / sum(count(customerID)) over(),2) as percentage
from customer_churn
group by contract
order by total_customers desc;

/* Q11. Which contract type has the highest churn rate?
*/
select
contract,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by contract
order by churn_rate desc;

/* Q12. Which Internet Service category has the highest churn rate?
*/
select
InternetService,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by InternetService
order by churn_rate desc;

/* Q13. Do senior citizens have a higher churn rate than non-senior citizens? */
select
SeniorCitizen,
case
	when SeniorCitizen = 1 then 'Senior citizen'
    else 'Non-senior citizens'
end as citizen_category,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by SeniorCitizen 
order by churn_rate desc;

/* Q14 — Churn by Partner Status */
select
Partner,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by Partner 
order by churn_rate desc;

/* Q15. Do customers without dependents have a higher churn rate? */
select
Dependents,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by Dependents 
order by churn_rate desc;

/* Q16. Which payment method has the highest customer churn rate? */	
select
PaymentMethod,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by PaymentMethod 
order by churn_rate desc;

/* Q18. Which customer tenure group has the highest churn rate? */
SELECT
    CASE
        WHEN tenure <= 12 THEN 'New'
        WHEN tenure <= 24 THEN 'Early'
        WHEN tenure <= 48 THEN 'Mid-term'
        ELSE 'Long-term'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;

/* Q19 Are customers without Online Security more likely to churn? */
select
OnlineSecurity,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by OnlineSecurity
order by churn_rate desc;

/* Q20 Are customers without Tech Support more likely to churn? */
select
TechSupport,
count(customerID) as total_customers,
sum(case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by TechSupport
order by churn_rate desc;

/* Q21. Do customers using paperless billing have a higher churn rate than customers not using it?
*/
select
PaperlessBilling,
count(customerID) as total_customers,
sum(
	case
    when churn = 'Yes' then 1
    else 0
end) as churned_customers,
round(
	sum(
	case
    when churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by PaperlessBilling
order by churn_rate desc;

/* Q22. Are customers using Streaming TV more or less likely to churn?
*/
select
StreamingTV,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by StreamingTV
order by churn_rate desc;
	
/* Q23. Are customers who use Streaming Movies more likely to churn? */
select
StreamingMovies,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by StreamingMovies
order by churn_rate desc;

/* Q24. Are customers without Online Backup more likely to churn?
*/
select
OnlineBackup,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by OnlineBackup
order by churn_rate desc;

/* Q25. Are customers without Device Protection more likely to churn?
*/
select
DeviceProtection,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by DeviceProtection
order by churn_rate desc;
	
/* Q26. Does having Phone Service relate to customer churn?
*/
select
PhoneService,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by PhoneService
order by churn_rate desc;

/* Q27. Are customers with Multiple Lines more likely to churn than customers with a single line or no phone service?
*/
select
MultipleLines,
count(customerID) as total_customers,
sum( case
	when Churn = 'Yes' then 1
    else 0
end) as churned_customer,
round(
	sum( case
	when Churn = 'Yes' then 1
    else 0
end) * 100.0 / count(customerID), 2) as Churn_rate
from customer_churn
group by MultipleLines
order by churn_rate desc;

# Next: Section 4 — Customer Behaviour & Revenue Exposure 

# Q28. Do churned customers have higher average monthly charges than retained customers?

select
case
	when churn = 'Yes' then 'Churned'
    else 'Retained'
end as customer_status,
count(customerID) as total_customers,
round(avg(MonthlyCharges),2) as avg_monthly_charges
from customer_churn
group by case
	when churn = 'Yes' then 'Churned'
    else 'Retained'
end
order by avg_monthly_charges desc;

# Q29. How much monthly recurring revenue is currently associated with customers who have churned?
select
sum(case
	when churn = 'yes' then 1
    else 0
end ) as churned_customers,
sum(case
	when churn = 'yes' then MonthlyCharges
    else 0
end )as monthly_revenue_lost
from customer_churn;

# Q30. Which contract type contributes the highest monthly revenue at risk due to churn?
select
Contract,
sum(case
	when churn = 'yes' then 1
    else 0
end ) as churned_customers,
sum(case
	when churn = 'yes' then MonthlyCharges
    else 0
end )as monthly_revenue_lost
from customer_churn
group by Contract;

# Q31. Do customers who churn have shorter average tenure than customers who stay?
select
case
	when Churn = 'yes' then 'churned'
    else 'retained'
end as customer_status,
count(customerID) as total_customers,
round(avg(tenure),2) as avg_tenure
from customer_churn
group by case
	when Churn = 'yes' then 'churned'
    else 'retained'
end
order by avg_tenure desc;

# Q32. How much total revenue has been generated by churned customers compared with retained customers?
select
case
	when Churn = 'yes' then 'Churned'
    else 'Retained'
end as customer_status,
count(customerID) as total_customers,
sum(TotalCharges) as total_revenue
from customer_churn
group by case
	when Churn = 'yes' then 'Churned'
    else 'Retained'
end
order by total_revenue desc;

# Q33. Which combination of contract type and customer tenure has the highest churn rate?
select
Contract,
CASE
    WHEN tenure <= 12 THEN 'New Customers'
    WHEN tenure <= 24 THEN 'Early Customers'
    WHEN tenure <= 48 THEN 'Mid-term Customers'
    WHEN tenure <= 72 THEN 'Long-term Customers'
END AS tenure_group,
count(customerID) as total_customers,
sum(case 
	when Churn = 'Yes' then 1
    else 0
end ) as churned_customers,
round(sum(case 
	when Churn = 'Yes' then 1
    else 0
end ) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by Contract,CASE
    WHEN tenure <= 12 THEN 'New Customers'
    WHEN tenure <= 24 THEN 'Early Customers'
    WHEN tenure <= 48 THEN 'Mid-term Customers'
    WHEN tenure <= 72 THEN 'Long-term Customers'
END
order by churn_rate desc;

# Q34. Which customer segment contributes the highest monthly revenue at risk based on Internet Service and Contract?
select
InternetService,
Contract,
sum(case
		when Churn = 'Yes' then 1
        else 0
	end ) as churned_customers,
sum(case
		when Churn = 'Yes' then MonthlyCharges
        else 0
	end ) as Monthly_revnue_lost
from customer_churn
group by InternetService,Contract
order by Monthly_revnue_lost desc;

# Q35. Identify the Top 5 Customer Segments with the Highest Churn Rate.

select
concat(Contract,'-',InternetService) as customer_segment,
Count(customerID) as total_customers,
sum(case
		when Churn = 'Yes' then 1
        else 0
	end ) as churned_customers,
round(sum(case
		when Churn = 'Yes' then 1
        else 0
	end ) * 100.0 / count(customerID), 2) as churn_rate
from customer_churn
group by Contract,InternetService
order by churn_rate desc
Limit 5;

# Q36. Identify the segment contributing the highest monthly revenue at risk.
select
concat(Contract,'-',InternetService) as customer_segment,
Count(customerID) as total_customers,
sum(case
		when Churn = 'Yes' then 1
        else 0
	end ) as churned_customers,
sum(case
		when Churn = 'Yes' then MonthlyCharges
        else 0
	end) as Monthly_revenue_risk
from customer_churn
group by Contract,InternetService
order by Monthly_revenue_risk desc;

# Identify the overall top churn drivers.

# Write a query to find the churn rate for each payment method.
select
PaymentMethod,
count(customerID) as total_customers,
sum(
	case
		when Churn ='Yes' then 1
		else 0
	end) as Churned_customers,
round(sum(case
			when Churn ='Yes' then 1
            else 0
		end) * 100.0 / count(customerID), 2) as churn_rate 
from customer_churn
group by PaymentMethod
order by churn_rate desc;

#  Contract-wise churn analysis
select
Contract,
count(customerID) as total_customers,
sum(
	case
		when Churn ='Yes' then 1
		else 0
	end) as Churned_customers,
round(sum(case
			when Churn ='Yes' then 1
            else 0
		end) * 100.0 / count(customerID), 2) as churn_rate 
from customer_churn
group by Contract
order by churn_rate desc;

# InternetService analysis
select
InternetService,
count(customerID) as total_customers,
sum(
	case
		when Churn ='Yes' then 1
		else 0
	end) as Churned_customers,
round(sum(case
			when Churn ='Yes' then 1
            else 0
		end) * 100.0 / count(customerID), 2) as churn_rate 
from customer_churn
group by InternetService
order by churn_rate desc;

# Row count
select count(*) 
from customer_churn;

# distinct count
SELECT COUNT(DISTINCT customerID)
FROM customer_churn;

# blank totalCharges
SELECT COUNT(*)
FROM customer_churn
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = '';
   
# missing values across all columns:
SELECT
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS missing_contract,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS missing_churn
FROM customer_churn;

# Is TotalCharges contains valid numeric values?
SELECT COUNT(*) AS invalid_total_charges
FROM customer_churn
WHERE TRIM(TotalCharges) NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

# analysis
select
count(customerId) as Total_Customers,
sum(case
	when Churn = 'Yes' then 1
    else 0 
end ) as Churned_Customers,
round(sum(case
	when Churn = 'Yes' then 1
    else 0 
end ) * 100.0 / count(customerID), 2) as Churned_Rate,
round(sum(case
	when Churn = 'Yes' then MonthlyCharges
    else 0
end ),2) as Monthly_revenue_at_risk
from customer_churn;

# DONUT CHART
SELECT
    Churn,
    COUNT(*) AS Customers
FROM customer_churn
GROUP BY Churn;
