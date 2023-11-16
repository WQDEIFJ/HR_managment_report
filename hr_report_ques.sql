-- QUESTIONS

-- 1. WHAT IS THE GENDER BREAKDOWN OF EMPLOYEES IN THE COMPANY?

select gender, count('gender') as count
from hr
where age >= 18 and termdate = ''
group by gender;

-- 2. WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES IN THE COMPANY?

select 
min(age) as youngest,
max(age) as oldest
from hr
where age >= 18 and termdate = '';

select 
case 
when age >= 18 and age <= 24 then '18-24'
when age >= 25 and age <= 34 then '25-34'
when age >= 35 and age <= 44 then '35-44'
when age >= 45 and age <= 54 then '45-54'
when age >= 55 and age <= 64 then '55-64'
else '65+'
end as age_group,
count(*) as count
from hr
where age >= 18 and termdate = ''
group by age_group
order by age_group;

select 
case 
when age >= 18 and age <= 24 then '18-24'
when age >= 25 and age <= 34 then '25-34'
when age >= 35 and age <= 44 then '35-44'
when age >= 45 and age <= 54 then '45-54'
when age >= 55 and age <= 64 then '55-64'
else '65+'
end as age_group,
count(age) as count, gender
from hr
where age >= 18 and termdate = ''
group by age_group, gender
order by age_group, gender;

-- 3. WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES IN THE COMPANY?
select location, count(*) as count
from hr
where age >= 18 and termdate= ''
group by location;

-- 4. what is the average length of employment for employees who have been terminated?

select 
round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employment
from hr
where termdate <= curdate() and termdate <> '' and age >= 18;

-- 5. how does the gender distribution vary across department and job titles?

select department, gender, count(*) as count
from hr
where termdate = '' and age >= 18
group by department, gender
order by department;

-- 6. what is the distribution of job titles across the company?
select jobtitle, count(*) as count
from hr
where age>= 18 and termdate = ''
group by jobtitle 
order by jobtitle desc;

-- 7. Which department has the highest turnover rate?

select department, 
total_count,
terminated_count,
terminated_count/total_count as termination_rate
from(select department, count(*) as total_count,
sum(case when termdate<> '' and termdate<= curdate() then 1 else 0 end) as terminated_count
from hr
where age>= 18
group by department
) as subquery 
order by termination_rate desc;

-- 8. What is the distribution of employees across location by city and states?
select location_state, count(*) as count
from hr
where age >= 18 and termdate = ''
group by location_state
order by count desc;
-- 9. how has the compnay's employee count changed over time based on hire and term dates?

select 
year, hires, terminations, hires - terminations as net_change,
round((hires- termination)/hires* 100, 2) as net_change_percent
from (select YEAR(hire_date) as year,
count(*) as hires,
sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as termination
from hr
where age>= 18 
group by year(hire_date)
) as subquery
order by year asc;