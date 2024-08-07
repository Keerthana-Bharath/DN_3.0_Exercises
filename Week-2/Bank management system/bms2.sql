CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Balance DECIMAL(10, 2)
);

INSERT INTO Accounts (CustomerID, Balance) VALUES (1, 5000);
INSERT INTO Accounts (CustomerID, Balance) VALUES (2, 3000);
INSERT INTO Accounts (CustomerID, Balance) VALUES (3, 8000);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (Name, Salary) VALUES ('John Smith', 50000);
INSERT INTO Employees (Name, Salary) VALUES ('Jane Doe', 60000);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Balance DECIMAL(10, 2),
    IsVIP BOOLEAN DEFAULT FALSE
);

INSERT INTO Customers (CustomerID, Name, Age, Balance) VALUES (1, 'John Doe', 65, 12000);
INSERT INTO Customers (CustomerID, Name, Age, Balance) VALUES (2, 'Jane Smith', 58, 8000);
INSERT INTO Customers (CustomerID, Name, Age, Balance) VALUES (3, 'Alice Johnson', 72, 15000);

DELIMITER $$

CREATE PROCEDURE SafeTransferFunds(
    IN fromAccountID INT,
    IN toAccountID INT,
    IN amount DECIMAL(10, 2)
)
BEGIN
    DECLARE insufficient_funds CONDITION FOR SQLSTATE '45000';
    DECLARE from_balance DECIMAL(10, 2);

    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed, rollback successful.';
    END;

    START TRANSACTION;

    
    SELECT Balance INTO from_balance FROM Accounts WHERE AccountID = fromAccountID;

    IF from_balance < amount THEN
        SIGNAL insufficient_funds SET MESSAGE_TEXT = 'Insufficient funds in the source account.';
    END IF;

    UPDATE Accounts SET Balance = Balance - amount WHERE AccountID = fromAccountID;

    UPDATE Accounts SET Balance = Balance + amount WHERE AccountID = toAccountID;

    COMMIT;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE UpdateSalary(
    IN empID INT,
    IN percentage DECIMAL(5, 2)
)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error updating salary: Employee ID not found.';
    END;

    UPDATE Employees
    SET Salary = Salary + (Salary * percentage / 100)
    WHERE EmployeeID = empID;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID not found.';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddNewCustomer(
    IN custID INT,
    IN custName VARCHAR(100),
    IN custAge INT,
    IN custBalance DECIMAL(10, 2)
)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error adding new customer: Customer ID already exists.';
    END;

    INSERT INTO Customers (CustomerID, Name, Age, Balance)
    VALUES (custID, custName, custAge, custBalance);

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID already exists.';
    END IF;
END $$

DELIMITER ;

-- output
SELECT * FROM Accounts;
SELECT * FROM Employees;
CALL SafeTransferFunds(1, 2, 1000);
CALL UpdateSalary(1, 10);
CALL AddNewCustomer(4, 'New Customer', 30, 5000);
SELECT * FROM Accounts;
SELECT * FROM Employees;
