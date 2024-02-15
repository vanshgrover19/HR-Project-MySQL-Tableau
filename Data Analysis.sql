
-- QUESTIONS --

 -- 1. What is the gender breakdown of employees in the company?
 
SELECT gender, COUNT(*) AS number_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT race, COUNT(*) AS employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?

SELECT MIN(age) AS youngest_age,
	   MAX(age) AS oldest_age
FROM hr
WHERE age >= 18 AND termdate IS NULL;

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
		ELSE '54+'
	END AS age_group, COUNT(*) AS no_of_emp
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;
        
-- 4. How many employees work at headquarters versus remote locations?

SELECT location, COUNT(*) AS no_of_employees
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location
ORDER BY no_of_employees DESC;

-- 5. What is the average length of employment for employees who have been terminated?

SELECT ROUND(AVG(datediff(termdate, hire_date))/365, 2) AS avg_length_emp
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?

SELECT department, gender, COUNT(*) AS emp_count
FROM portfolio.hr
WHERE age >= '18' AND termdate IS NULL
GROUP BY department, gender
ORDER BY emp_count DESC;

-- 7. What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM (
SELECT department,
COUNT(*) AS total_count,
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr
WHERE age >= 18
GROUP BY department)
AS subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?

SELECT location_city, location_state, COUNT(*) AS total_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_city, location_state
ORDER BY total_count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT year,
hires,
terminations,
hires - terminations AS net_change,
round((hires - terminations)/hires * 100, 2) AS net_change_percent
FROM(
	SELECT YEAR(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age>= 18
    GROUP BY YEAR(hire_date)
    ) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?

SELECT department, ROUND(AVG(datediff(termdate, hire_date)/365), 0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18
GROUP BY department;




