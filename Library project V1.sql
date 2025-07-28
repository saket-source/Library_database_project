SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM members
SELECT * FROM issued_status
SELECT * FROM return_status

--Project on library

--Task 1. Create a New Book Record  
-- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES (
		'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
		)

--Task 2: Update an Existing Member's Address

SELECT * FROM members;

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101'

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121'

--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'

SELECT * FROM issued_status

SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101'

--Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find employee who have issued more than one book.

SELECT issued_emp_id, COUNT(issued_emp_id)
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_emp_id)>1

--CTAS
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS
SELECT 
	b.isbn, 
	b.book_title,
	count(ist.issued_id) as no_issued
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1,2

SELECT * FROM book_cnts;

--Task 7. Retrieve All Books where publisher is "Penguin Books" and the author is "George Orwell":

SELECT *
FROM books
WHERE publisher = 'Penguin Books' AND author = 'George Orwell'

--Task 8: Find Total Rental Income by Category:

SELECT 
	b.category, 
	SUM(rental_price),
	COUNT(*)
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

--Task 9: List Members Who Registered in the Last 180 Days:

SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'

--Insert these values to check for the current date
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
  ('C120', 'sam', '145 Main St', '2025-06-01'),
  ('C121', 'john', '133 Main St', '2025-07-09');

--Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT 
	e.*,
	b.manager_id,
	e1.emp_name AS manager
FROM branch AS b
JOIN employees AS e
ON b.branch_id = e.branch_id
JOIN employees AS e1
ON e1.emp_id = b.manager_id

--Task 11: Retrieve the List of Books Not Yet Returned

SELECT DISTINCT ist.issued_book_name AS books_not_returned
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL



