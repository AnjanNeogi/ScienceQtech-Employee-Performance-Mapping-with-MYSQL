Create database if not exists ScienceQtech_Employee;
Use ScienceQtech_Employee;
Select database();

## To fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table
Create View emp_record_table_view1 as
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;

select * from emp_record_table_view1;

##To fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is 
##less than 2
Create View emp_record_table_view2 as
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT,EMP_RATING
from emp_record_table
where EMP_RATING <2;

select * from emp_record_table_view2;

##greater than four 
Create View emp_record_table_view3 as
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING > 4;

select * from emp_record_table_view3;

## Between two and four
Create View emp_record_table_view4 as
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING
between 2
and 4;

select * from emp_record_table_view4;

##concatenate FIRST_NAME and the LAST_NAME of employees in the Finance department
select concat(FIRST_NAME," ",LAST_NAME) as Name
from emp_record_table
Where DEPT = 'FINANCE';

#list only those employees who have someone reporting to them
SELECT MANAGER_ID, COUNT(EMP_ID) as EMP_COUNT 
FROM emp_record_table  
GROUP BY MANAGER_ID 
ORDER BY EMP_COUNT DESC;

##list down all the employees from the healthcare and finance departments using union
select e.EMP_ID,
concat(e.FIRST_NAME," ",e.LAST_NAME) As Full_Name,
e.DEPT
from emp_record_table e
Where (e.DEPT = 'HEALTHCARE' or e.DEPT = 'FINANCE')
UNION
select p.EMP_ID,
concat(p.FIRST_NAME," ",p.LAST_NAME) As Full_Name,
p.DEPT
From data_science_team p;

##list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING 
##grouped by dept
##include the respective employee rating along with the max emp rating for the department
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING, 
max(EMP_RATING) As Max_Emp_Ratting
from emp_record_table
group by DEPT;

##calculate the minimum and the maximum salary of the employees in each role.
select ROLE,SALARY, max(SALARY) As max_salary, min(SALARY) As min_salary
from emp_record_table
group by ROLE;

##assign ranks to each employee based on their experience. Take data from the employee record table
select EMP_ID, FIRST_NAME, LAST_NAME,EXP,
rank() Over (order by EXP desc)
From emp_record_table;

##create a view that displays employees in various countries whose salary is more than six thousand
Create View Salary_View1 as
select EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
from emp_record_table
where SALARY >6000;

select * from Salary_View1;

##Nested query to find employees with experience of more than ten years
select e.FIRST_NAME, e.LAST_NAME, e.EXP,
(select count(distinct p.EMP_ID) from emp_record_table p ) as EXP1
From emp_record_table e
where e.EXP > 10;

##create a stored procedure to retrieve the details of the employees whose experience is 
##more than three years
DELIMITER &&
Create procedure Get_Exp()
begin
select * from emp_record_table where EXP > 3;
end &&
call Get_Exp;

##stored functions in the project table to check whether the job profile assigned to each employee 
## experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST'
DELIMITER &&
Create procedure Job_Profile()
begin
select * from data_science_team 
Where EXP <= 2 and
ROLE = "JUNIOR DATA SCIENTIST";
end &&
call Job_Profile

## experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
##experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
##experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
##experience of 12 to 16 years assign 'MANAGER'.
DELIMITER &&
create procedure Job_Profile1()
begin
select * from data_science_team
Where EXP between 2 and 5
or EXP between 5 and 10
or EXP between 10 and 12
or EXP between 12 and 16;
end &&

call Job_Profile1

##index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ 
##in the employee table after checking the execution plan..

create index idx_word on emp_record_table(FIRST_NAME);
select *from emp_record_table where FIRST_NAME ='Eric';

##calculate the bonus for all the employees, based on their ratings and salaries
##Use the formula: 5% of salary * employee rating

select EMP_ID, FIRST_NAME, SALARY, LAST_NAME, EMP_RATING,
(SALARY * 5/100)*(EMP_RATING) as BONUS
from emp_record_table;

##to calculate the average salary distribution based on the continent and country.

Select COUNTRY, CONTINENT,
avg(SALARY) as Avg_salary
from emp_record_table
group by CONTINENT;

