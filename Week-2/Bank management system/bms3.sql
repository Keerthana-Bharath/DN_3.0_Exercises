CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    balance DECIMAL(10, 2),
    IsVIP BOOLEAN DEFAULT FALSE
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO Customers (customer_id, name, age, balance) VALUES 
(1, 'John Doe', 65, 15000.00),
(2, 'Jane Smith', 58, 8000.00),
(3, 'George Brown', 62, 12000.00),
(4, 'Emily White', 45, 2000.00);

INSERT INTO Accounts (customer_id, account_type, balance) VALUES 
(1, 'Savings', 5000.00),
(2, 'Savings', 3000.00),
(3, 'Checking', 1500.00),
(1, 'Checking', 2000.00);

INSERT INTO Employees (name, department, salary) VALUES 
('John Smith', 'Sales', 50000.00),
('Jane Doe', 'Marketing', 60000.00),
('Emily White', 'Sales', 55000.00),
('George Brown', 'IT', 70000.00);

DELIMITER //

CREATE PROCEDURE ProcessMonthlyInterest()
BEGIN
    UPDATE Accounts
    SET balance = balance * 1.01
    WHERE account_type = 'Savings';
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateEmployeeBonus(
    IN dept VARCHAR(50),
    IN bonus_percentage DECIMAL(5, 2)
)
BEGIN
    UPDATE Employees
    SET salary = salary + (salary * bonus_percentage / 100)
    WHERE department = dept;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN fromAccountID INT,
    IN toAccountID INT,
    IN transfer_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE from_balance DECIMAL(10, 2);

    DECLARE insufficient_funds CONDITION FOR SQLSTATE '45000';
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed, rollback successful.';
    END;

    START TRANSACTION;

    SELECT balance INTO from_balance FROM Accounts WHERE account_id = fromAccountID;

    IF from_balance < transfer_amount THEN
        SIGNAL insufficient_funds SET MESSAGE_TEXT = 'Insufficient funds in the source account.';
    END IF;

    UPDATE Accounts SET balance = balance - transfer_amount WHERE account_id = fromAccountID;

    UPDATE Accounts SET balance = balance + transfer_amount WHERE account_id = toAccountID;

    COMMIT;
END //

DELIMITER ;

SELECT * FROM Accounts;

SELECT * FROM Employees;

CALL ProcessMonthlyInterest();

CALL UpdateEmployeeBonus('Sales', 5.0);

CALL TransferFunds(1, 2, 500.00);

SELECT * FROM Accounts;

SELECT * FROM Employees;
