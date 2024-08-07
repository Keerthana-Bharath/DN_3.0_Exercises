CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Balance DECIMAL(10, 2),
    IsVIP BOOLEAN DEFAULT FALSE
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    InterestRate DECIMAL(5, 2),
    DueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers (Name, Age, Balance) VALUES 
('John Doe', 65, 12000),
('Jane Smith', 58, 8000),
('Alice Johnson', 72, 15000),
('Bob Brown', 45, 9500);

INSERT INTO Loans (CustomerID, InterestRate, DueDate) VALUES 
(1, 5.0, CURDATE() + INTERVAL 20 DAY),
(2, 4.5, CURDATE() + INTERVAL 40 DAY),
(3, 6.0, CURDATE() + INTERVAL 10 DAY),
(4, 5.5, CURDATE() + INTERVAL 15 DAY);

DELIMITER $$

CREATE PROCEDURE ApplyDiscount()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cust_id INT;
    DECLARE loan_id INT;
    DECLARE interest_rate DECIMAL(5, 2);

    DECLARE customer_cursor CURSOR FOR
        SELECT c.CustomerID, l.LoanID, l.InterestRate
        FROM Customers c
        JOIN Loans l ON c.CustomerID = l.CustomerID
        WHERE c.Age > 60;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN customer_cursor;
    read_loop: LOOP
        FETCH customer_cursor INTO cust_id, loan_id, interest_rate;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Loans
        SET InterestRate = InterestRate - 1
        WHERE LoanID = loan_id;

    END LOOP;

    CLOSE customer_cursor;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE PromoteToVIP()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cust_id INT;

    DECLARE balance_cursor CURSOR FOR
        SELECT CustomerID
        FROM Customers
        WHERE Balance > 10000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN balance_cursor;
    read_loop: LOOP
        FETCH balance_cursor INTO cust_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Customers
        SET IsVIP = TRUE
        WHERE CustomerID = cust_id;

    END LOOP;

    CLOSE balance_cursor;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE SendLoanReminders()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cust_id INT;
    DECLARE cust_name VARCHAR(100);
    DECLARE due_date DATE;

    DECLARE loan_cursor CURSOR FOR
        SELECT c.CustomerID, c.Name, l.DueDate
        FROM Customers c
        JOIN Loans l ON c.CustomerID = l.CustomerID
        WHERE l.DueDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 30 DAY;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN loan_cursor;
    read_loop: LOOP
        FETCH loan_cursor INTO cust_id, cust_name, due_date;
        IF done THEN
            LEAVE read_loop;
        END IF;

    END LOOP;

    CLOSE loan_cursor;
END $$

DELIMITER ;
SELECT * FROM Loans;
SELECT * FROM Customers;

CALL ApplyDiscount();
CALL PromoteToVIP();
CALL SendLoanReminders();

SELECT * FROM Loans;
SELECT * FROM Customers;
