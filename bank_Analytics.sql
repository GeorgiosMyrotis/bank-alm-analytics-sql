
-- BANK ANALYTICS & ALM PROJECT - COMPLETE SCRIPT


-- 1. Δημιουργία Βάσης 
CREATE DATABASE bank_analytics;
use bank_analytics;


-- 2. Δημιουργία Πινάκων 
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2),
    transaction_type VARCHAR(50),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 3. Εισαγωγή τυχαίων δεδομένων
INSERT INTO Customers (first_name, last_name, city) VALUES
('Georgios', 'Papadopoulos', 'Patra'),
('Nikos', 'Dimitropoulos', 'Ioannina'),
('Maria', 'Papadimitriou', 'Thessaloniki'),
('Nikolaos', 'Dimitriadis', 'Larisa'),
('Nikoleta', 'Anastasiadou', 'Larisa'),
('Ioanna', 'Gkolema', 'Katerini'),
('Eleni', 'Antonopoulou', 'Kozani'),
('Georgios', 'Tzimopoulos', 'Xania'),
('Maria', 'Kapanidou', 'Patra');

INSERT INTO Accounts (customer_id, account_type, balance) VALUES
(1, 'Savings', 12500.00),
(2, 'Checking', 1500.50),
(3, 'Savings', 45000.00),
(4, 'Checking', 800.00),
(5, 'Savings', 3200.00),
(6, 'Checking', 14200.00),
(7, 'Savings', 23000.00),
(8, 'Checking', 5400.00),
(9, 'Savings', 18900.00);


-- 4. ANALYTICAL QUERIES (Deposit & ALM Reporting)

-- Βήμα Α: Σύνδεση πελατών και λογαριασμών 
SELECT c.first_name, c.last_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

-- Βήμα Β: Άθροισμα και ομαδοποίηση 
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(a.balance) AS total_balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Βήμα Γ: Κατηγοροποίηση πελατών 
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(a.balance) AS total_balance,
    CASE 
        WHEN SUM(a.balance) >= 20000 THEN 'VIP Customer (Stable Funding)'
        WHEN SUM(a.balance) BETWEEN 5000 AND 19999 THEN 'Regular Customer'
        ELSE 'Retail / Low Balance'
    END AS customer_tier
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_balance DESC;