-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

SELECT emp_no, first_name, last_name
FROM employees

SELECT title, from_date, to_date
FROM titles

-- Create new table using INTO clause
SELECT emp_no, first_name, last_name
INTO retiring_info
FROM employees
;

SELECT title, from_date, to_date
INTO titles_info
FROM titles
;

SELECT * FROM retiring_info;

SELECT retiring_info.emp_no,
    retiring_info.first_name,
retiring_info.last_name,
       titles.title,
	titles.to_date,
	titles.from_date
INTO retiring_titles
FROM retiring_info
JOIN titles
ON retiring_info.emp_no = titles.emp_no
ORDER BY emp_no;

SELECT * FROM retiring_titles; 

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_tables
FROM retiring_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Employees about to retire, job title
SELECT COUNT(title), title
INTO retired_titles
FROM unique_tables
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Deliverable 2
SELECT emp_no, first_name, last_name, birth_date
FROM employees

SELECT from_date, to_date
FROM dept_emp

SELECT title
FROM titles

SELECT DISTINCT ON(e.emp_no) e.emp_no, 
    e.first_name, 
    e.last_name, 
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_eligibilty
FROM employees as e
Left outer Join dept_emp as de
ON (e.emp_no = de.emp_no)
Left outer Join titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibilty;
