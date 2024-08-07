CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Balance DECIMAL(10, 2),
    IsVIP BOOLEAN DEFAULT FALSE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Balance DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

DELIMITER $$

CREATE PROCEDURE AddCustomer(
    IN p_Name VARCHAR(100),
    IN p_Age INT,
    IN p_Balance DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Customers (Name, Age, Balance)
    VALUES (p_Name, p_Age, p_Balance);
END $$

CREATE PROCEDURE UpdateCustomerDetails(
    IN p_CustomerID INT,
    IN p_Name VARCHAR(100),
    IN p_Age INT,
    IN p_Balance DECIMAL(10, 2)
)
BEGIN
    UPDATE Customers
    SET Name = p_Name, Age = p_Age, Balance = p_Balance
    WHERE CustomerID = p_CustomerID;
END $$

CREATE FUNCTION GetCustomerBalance(p_CustomerID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE balance DECIMAL(10, 2);
    SELECT Balance INTO balance
    FROM Customers
    WHERE CustomerID = p_CustomerID;
    RETURN balance;
END $$

CREATE PROCEDURE HireEmployee(
    IN p_Name VARCHAR(100),
    IN p_Salary DECIMAL(10, 2),
    IN p_DepartmentID INT
)
BEGIN
    INSERT INTO Employees (Name, Salary, DepartmentID)
    VALUES (p_Name, p_Salary, p_DepartmentID);
END $$

CREATE PROCEDURE UpdateEmployeeDetails(
    IN p_EmployeeID INT,
    IN p_Name VARCHAR(100),
    IN p_Salary DECIMAL(10, 2),
    IN p_DepartmentID INT
)
BEGIN
    UPDATE Employees
    SET Name = p_Name, Salary = p_Salary, DepartmentID = p_DepartmentID
    WHERE EmployeeID = p_EmployeeID;
END $$

CREATE FUNCTION CalculateAnnualSalary(p_EmployeeID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE annual_salary DECIMAL(10, 2);
    SELECT Salary * 12 INTO annual_salary
    FROM Employees
    WHERE EmployeeID = p_EmployeeID;
    RETURN annual_salary;
END $$

CREATE PROCEDURE OpenNewAccount(
    IN p_CustomerID INT,
    IN p_InitialBalance DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Accounts (CustomerID, Balance)
    VALUES (p_CustomerID, p_InitialBalance);
END $$

CREATE PROCEDURE CloseAccount(
    IN p_AccountID INT
)
BEGIN
    DELETE FROM Accounts
    WHERE AccountID = p_AccountID;
END $$

CREATE FUNCTION GetTotalBalance(p_CustomerID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_balance DECIMAL(10, 2);
    SELECT SUM(Balance) INTO total_balance
    FROM Accounts
    WHERE CustomerID = p_CustomerID;
    RETURN total_balance;
END $$

DELIMITER ;
