# Library Management System using SQL Project 

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_project_p2_db`

![Library](https://github.com/saket-source/Library_database_project/blob/main/Library%20scene.jpg)

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations. The goal is to showcase skills in database design, manipulation, and querying.


## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/saket-source/Library_database_project/blob/main/ERD)

- **Database Creation**: Created a database named `library_project_p2_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

-- Create table "branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(12) PRIMARY KEY,
            manager_id VARCHAR(12),
            branch_address VARCHAR(50),
            contact_no VARCHAR(15)
);

-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(	
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(25),
	position VARCHAR(15),
	salary INT,
	branch_id VARCHAR(12) --FK
);

-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(20) PRIMARY KEY,
	member_name VARCHAR(35),
	member_address VARCHAR(75),
	reg_date DATE
);

-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(20) PRIMARY KEY,
	book_title VARCHAR(80),
	category VARCHAR (25),
	ental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(35),
	publisher VARCHAR(55)
);

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
	issued_id VARCHAR(15) PRIMARY KEY,
	issued_member_id VARCHAR(15), --FK
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(25), --FK
	issued_emp_id VARCHAR(20) --FK
);

-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10),  --FK
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20) --FK
);

--FOREIGN KEY
ALTER TABLE issued_status
ADD	CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101'
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```

**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
     issued_emp_id,
     COUNT(issued_emp_id)
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_emp_id)>1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_cnts  -- we can use this table to retrieve this data anytime
AS
SELECT 
	b.isbn, 
	b.book_title,
	count(ist.issued_id) as no_issued
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1,2
```

### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books where publisher is "Penguin Books" and the author is "George Orwell":**

```sql
SELECT *
FROM books
WHERE publisher = 'Penguin Books' AND author = 'George Orwell'
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	b.category, 
	SUM(rental_price),
	COUNT(*)
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
	e.*,
	b.manager_id,
	e1.emp_name AS manager
FROM branch AS b
JOIN employees AS e
ON b.branch_id = e.branch_id
JOIN employees AS e1
ON e1.emp_id = b.manager_id

```

Task 11: **Retrieve the List of Books Not Yet Returned**

```sql
SELECT DISTINCT ist.issued_book_name AS books_not_returned
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

This project showcases SQL skills essential for database management and analysis.

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/saket-kumar-diwakar/)

Thank you for your interest in this project! and I look forward to connecting with you!
