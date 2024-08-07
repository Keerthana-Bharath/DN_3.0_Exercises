CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE,
    Balance DECIMAL(10,2),
    LastModified DATE
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    Amount DECIMAL(10,2),
    TransactionType ENUM('Deposit', 'Withdrawal'),
    TransactionDate DATE
);

CREATE TABLE AuditLog (
    AuditID INT PRIMARY KEY AUTO_INCREMENT,
    TransactionID INT,
    AccountID INT,
    Amount DECIMAL(10,2),
    TransactionType ENUM('Deposit', 'Withdrawal'),
    TransactionDate DATE,
    LogTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    SET NEW.LastModified = CURDATE();
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        TransactionID, 
        AccountID, 
        Amount, 
        TransactionType, 
        TransactionDate
    )
    VALUES (
        NEW.TransactionID, 
        NEW.AccountID, 
        NEW.Amount, 
        NEW.TransactionType, 
        NEW.TransactionDate
    );
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE current_balance DECIMAL(10,2);

    IF NEW.TransactionType = 'Withdrawal' THEN
        SELECT Balance INTO current_balance 
        FROM Customers 
        WHERE CustomerID = NEW.AccountID 
        FOR UPDATE;

        IF NEW.Amount > current_balance THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Withdrawal amount exceeds current balance.';
        END IF;

    ELSEIF NEW.TransactionType = 'Deposit' THEN
    
        IF NEW.Amount <= 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Deposit amount must be positive.';
        END IF;
    END IF;
END //

DELIMITER ;

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(1, 'Alice Johnson', '1980-12-15', 1500.00, CURDATE()),
(2, 'Bob Smith', '1975-05-20', 2000.00, CURDATE());

INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate) VALUES
(1, 500.00, 'Deposit', CURDATE()),
(1, 200.00, 'Withdrawal', CURDATE()),
(2, 1000.00, 'Deposit', CURDATE());

SELECT * FROM Customers;
SELECT * FROM Transactions;
SELECT * FROM AuditLog;
