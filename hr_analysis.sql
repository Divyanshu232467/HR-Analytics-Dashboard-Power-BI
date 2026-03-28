-- ===================================================================================
-- PROJECT: HR Analytics - Employee Attrition Analysis
-- TOOLS: SQL Server / MySQL
-- DATASET: 1,470 Employees
-- ===================================================================================

-- ---------------------------------------------------------
-- STEP 1: DATA SETUP
-- import data with iport wizard
-- ---------------------------------------------------------

-- Q1: Renameing the Table Name
-- EXEC sp_rename '[dbo].[HR_Analytics (1)]', 'HR_Data';

-- ---------------------------------------------------------
-- STEP 2: KEY PERFORMANCE INDICATORS (KPIs)
-- ---------------------------------------------------------

-- Q2: What is the overall employee count and attrition rate?
SELECT 
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) AS Attrition_Count,
    ROUND((COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0 / COUNT(*)), 2) AS Attrition_Rate
FROM HR_Data;

-- Insight: The company has a 16.08% attrition rate, with 237 employees leaving out of 1,470.

-- Q3: What is the average age and average monthly income of employees?
SELECT 
    CAST(AVG(CAST(Age AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Age,
    CAST(AVG(CAST(MonthlyIncome AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Salary
FROM HR_Data;

-- Insight: The average employee is 37 years old with a monthly salary of around 6.5K.

-- ---------------------------------------------------------
-- STEP 3: ATTRITION BY DEMOGRAPHICS
-- ---------------------------------------------------------

-- Q4: Which age group has the highest attrition?
SELECT AgeGroup, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY AgeGroup
ORDER BY Attrition_Count DESC;

-- Insight: The '26-35' age group has the highest turnover (116 employees), indicating early-career instability.

-- Q5: Does marital status affect attrition?
SELECT MaritalStatus, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY MaritalStatus
ORDER BY Attrition_Count DESC;

-- Insight: Single employees are significantly more likely to leave compared to married or divorced staff.

-- ---------------------------------------------------------
-- STEP 4: JOB & DEPARTMENTAL ANALYSIS
-- ---------------------------------------------------------

-- Q6: Which department has the most attrition?
SELECT Department, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY Attrition_Count DESC;

-- Insight: R&D and Sales are the most affected departments, while HR has the lowest attrition count.

-- Q7: What are the top 5 Job Roles with the highest attrition?
SELECT TOP 5 JobRole, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY Attrition_Count DESC;

-- Insight: Laboratory Technicians and Sales Executives are the most high-risk roles in the company.

-- ---------------------------------------------------------
-- STEP 5: WORK-LIFE & SATISFACTION IMPACT
-- ---------------------------------------------------------

-- Q8: How does 'Overtime' impact employee attrition?
SELECT OverTime, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY OverTime;

-- Insight: Employees who work Overtime have a much higher likelihood of leaving, likely due to burnout.

-- Q9: Is 'Distance From Home' a major reason for leaving?
SELECT 
    CASE WHEN DistanceFromHome <= 10 THEN 'Close' ELSE 'Far' END AS Distance_Status,
    COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY CASE WHEN DistanceFromHome <= 10 THEN 'Close' ELSE 'Far' END;

-- Insight: Employees living further away (10+ miles) show a noticeable trend of leaving the company.

-- Q10: How does 'Job Satisfaction' (Rating 1-4) relate to attrition?
SELECT JobSatisfaction, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Insight: Low satisfaction (Rating 1) is a direct trigger for employees to resign.

-- ---------------------------------------------------------
-- STEP 6: FINANCIALS & PERFORMANCE
-- ---------------------------------------------------------

-- Q11: Which Salary Slab has the highest turnover?
SELECT SalarySlab, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY SalarySlab
ORDER BY Attrition_Count DESC;

-- Insight: Most employees leaving are from the 'Upto 5k' salary bracket, showing a need for better compensation.

-- Q12: Are high performers getting higher salary hikes?
SELECT PerformanceRating, CAST(AVG(CAST(PercentSalaryHike AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Hike
FROM HR_Data
GROUP BY PerformanceRating;

-- Insight: Performance Rating 4 recipients get a higher average hike (20%+) compared to Rating 3 (14%).

-- Q13: How many years do employees stay before leaving?
SELECT 
    CASE WHEN YearsAtCompany <= 2 THEN '0-2 Years' 
         WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 Years'
         ELSE '5+ Years' END AS Tenure,
    COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY CASE WHEN YearsAtCompany <= 2 THEN '0-2 Years' 
              WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 Years'
              ELSE '5+ Years' END
ORDER BY Attrition_Count DESC;

-- Insight: Most attrition happens within the first 2 years (Onboarding/Early retention issue).

-- Q14: Are we losing our top performers? (Performance Rating 3 & 4)
SELECT PerformanceRating, COUNT(*) AS High_Performer_Attrition
FROM HR_Data
WHERE Attrition = 'Yes' AND PerformanceRating >= 3
GROUP BY PerformanceRating;

--Insight: "If a large number of high performers are leaving, it indicates a problem with the company's growth opportunities or rewards system."

-- Q15: Attrition based on years with current manager.
SELECT YearsWithCurrManager, COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY YearsWithCurrManager
ORDER BY YearsWithCurrManager;

--Insight: "High attrition in the first 0-11 year with a manager suggests a gap in manager-employee relationship or onboarding."