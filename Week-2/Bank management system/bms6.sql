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

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    InterestRate DECIMAL(5,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Statements (
    StatementID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Name VARCHAR(100),
    Amount DECIMAL(10,2),
    TransactionType ENUM('Deposit', 'Withdrawal'),
    TransactionDate DATE
);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) VALUES
(1, 'Alice Johnson', '1980-12-15', 1500.00, CURDATE()),
(2, 'Bob Smith', '1975-05-20', 2000.00, CURDATE());

INSERT INTO Transactions (AccountID, Amount, TransactionType, TransactionDate) VALUES
(1, 500.00, 'Deposit', CURDATE()),
(1, 200.00, 'Withdrawal', CURDATE()),
(2, 1000.00, 'Deposit', CURDATE());

INSERT INTO Loans (CustomerID, InterestRate) VALUES
(1, 5.00),
(2, 4.00);

DELIMITER //

CREATE PROCEDURE GenerateMonthlyStatements()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cust_id INT;
    DECLARE cust_name VARCHAR(100);
    DECLARE amt DECIMAL(10,2);
    DECLARE tran_type ENUM('Deposit', 'Withdrawal');
    DECLARE tran_date DATE;
    
    DECLARE cur CURSOR FOR
        SELECT c.CustomerID, c.Name, t.Amount, t.TransactionType, t.TransactionDate
        FROM Customers c
        JOIN Transactions t ON c.CustomerID = t.AccountID
        WHERE t.TransactionDate BETWEEN DATE_FORMAT(CURDATE(),'%Y-%m-01') AND LAST_DAY(CURDATE());
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cust_id, cust_name, amt, tran_type, tran_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO Statements (CustomerID, Name, Amount, TransactionType, TransactionDate)
        VALUES (cust_id, cust_name, amt, tran_type, tran_date);
    END LOOP;
    CLOSE cur;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ApplyAnnualFee()
BEGIN
    DECLARE v_fee DECIMAL(10,2) DEFAULT 50.00;
    DECLARE done INT DEFAULT 0;
    DECLARE cust_id INT;
    DECLARE cust_balance DECIMAL(10,2);
    
    DECLARE cur CURSOR FOR
        SELECT CustomerID, Balance
        FROM Customers;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cust_id, cust_balance;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE Customers
        SET Balance = cust_balance - v_fee
        WHERE CustomerID = cust_id;
    END LOOP;
    CLOSE cur;

    COMMIT;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateLoanInterestRates()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE loan_id INT;
    DECLARE curr_interest DECIMAL(5,2);
    DECLARE new_interest DECIMAL(5,2);
    
    DECLARE cur CURSOR FOR
        SELECT LoanID, InterestRate
        FROM Loans;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO loan_id, curr_interest;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET new_interest = curr_interest + 0.50;
        
        UPDATE Loans
        SET InterestRate = new_interest
        WHERE LoanID = loan_id;
    END LOOP;
    CLOSE cur;

    COMMIT;
END //

DELIMITER ;
SELECT * FROM Statements;
SELECT * FROM Customers;
SELECT * FROM Loans;

CALL GenerateMonthlyStatements();
CALL ApplyAnnualFee();
CALL UpdateLoanInterestRates();

SELECT * FROM Statements;
SELECT * FROM Customers;
SELECT * FROM Loans;
