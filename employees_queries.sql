-- 1.feladat
select employees.employees.gender, employees.dept_emp.dept_no, avg(employees.salaries.salary)
from employees.employees
inner join employees.dept_emp using(emp_no)
inner join employees.salaries using(emp_no)
group by employees.employees.gender, employees.dept_emp.dept_no;

-- 2.feladat
select min(dept_no)
from employees.dept_emp;

select max(dept_no)
from employees.dept_emp;

-- 3.feladat
select employees.employees.emp_no, employees.dept_emp.dept_no,
case
when employees.employees.emp_no <= 10020 then 110022
when employees.employees.emp_no between 10021 and 10040 then 110039
end
as manager
from employees.employees
inner join employees.dept_emp using(emp_no)
where (employees.emp_no <= 10040);

-- 4.feladat
select first_name, last_name
from employees.employees
where hire_date between '2000-01-01' and '2000-12-31';

-- 5.feladat
select employees.employees.first_name, employees.employees.last_name, employees.titles.title
from employees.employees
inner join employees.titles using(emp_no)
where employees.titles.title = 'Engineer';

select employees.employees.first_name, employees.employees.last_name, employees.titles.title
from employees.employees
inner join employees.titles using(emp_no)
where employees.titles.title = 'Senior Engineer';

-- 6.feladat
use employees;
drop procedure if exists last_dept;
delimiter $$
create procedure last_dept(in p_emp_no integer)
begin
select departments.dept_no, departments.dept_name
from departments
inner join employees.dept_emp using(dept_no) 
where dept_emp.to_date = '9999-01-01' and dept_emp.emp_no = p_emp_no;
end$$
delimiter ;

call employees.last_dept(10010);

-- 7.feladat
select count(emp_no) 
from employees.salaries
where salary > 100000 and datediff(to_date, from_date) > 365;

-- 8.feladat
use employees;
delimiter $$
create trigger employees.before_hire_date_insert
before insert on employees
for each row
begin 
	if new.hire_date > date_format(sysdate(), "%y-%m-%d") then 
		set new.hire_date = sysdate(); 
	end if; 
end $$

delimiter ;

use employees;
insert employees values('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');
select * from employees order by emp_no desc limit 10;

-- 9.feladat
use employees;
drop function if exists f_emp_max_salary;

delimiter $$
create function f_emp_max_salary(p_emp_no integer) returns integer deterministic
begin
  declare v_max_salary integer;
  select max(salaries.salary)
  into v_max_salary
  from employees
  inner join salaries using(emp_no)
  where emp_no = p_emp_no;
  return v_max_salary;
end$$

delimiter ;

select employees.f_emp_max_salary(11356);

use employees;
drop function if exists f_emp_min_salary;

delimiter $$
create function f_emp_min_salary(p_emp_no integer) returns integer deterministic
begin
  declare v_min_salary integer;
  select min(salaries.salary)
  into v_min_salary
  from employees
  inner join salaries using(emp_no)
  where emp_no = p_emp_no;
  return v_min_salary;
end$$

delimiter ;

select employees.f_emp_min_salary(11356);