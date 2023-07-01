/* create and use database */
CREATE DATABASE ShoppingDB;
USE ShoppingDB;

/* info */
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r11945005', '生醫電資所', 1, '郭庭沂');

SELECT DATABASE();
SELECT * FROM self;


/* create table */
CREATE TABLE Producer (
	producerID int NOT NULL,
    personID int,
    companyID int,
    Startdate Date DEFAULT '1000-01-01',
    Liscense int,
    PRIMARY KEY (producerID),
    UNIQUE (personID),
    UNIQUE (companyID),
    UNIQUE (Liscense)
);  

/* insert */
INSERT INTO Producer
VALUES 
(1, NULL, 1, '2023-01-02', 1111222),
(2, NULL, 2, '2023-01-01', 3333444),
(3, NULL, 3, '2023-01-03', 5555666),
(4, 1, NULL, '2023-01-02', 1166422),
(5, 2, NULL, '2023-01-01', 3333884),
(6, 3, NULL, '2023-01-03', 5555886),
(7, 4, NULL, '2023-01-02', 1885999),
(8, 5, NULL, '2023-01-01', 3557899),
(9, 6, NULL, '2023-01-03', 8899886);
SELECT * FROM Producer;


/* create table */
CREATE TABLE Person (
	IDnum int NOT NULL,
    Name varchar(40) NOT NULL,
    Gender ENUM('F','M') DEFAULT 'M',
    PRIMARY KEY (IDnum),
    FOREIGN KEY (IDnum) REFERENCES Producer(personID)
);

/* insert */
INSERT INTO Person
VALUES 
(1, 'Allen', 'M'),
(2, 'Jackson', 'M'),
(3, 'Zoey', 'F'),
(4, 'Candy', 'F'),
(5, 'Sally', 'F'),
(6, 'Super', 'M');
SELECT * FROM Person;


/* create table */
CREATE TABLE Account (
	accountID int NOT NULL,
	Username varchar(40) NOT NULL,
    Email varchar(40) NOT NULL,
    Age int DEFAULT 20 CHECK (Age>0),
    PRIMARY KEY (accountID),
    UNIQUE (Username),
    UNIQUE (Email),
    FOREIGN KEY (accountID) REFERENCES Person(IDnum)
);

/* insert */
INSERT INTO Account
VALUES 
(1, 'Allen1021', 'allen1021@gmail.com', 30),
(2, 'Jackson0328', 'jackson0328@gmail.com', 28),
(3, 'Zoey0517', 'zoeyy@gmail.com', 22),
(4, 'Candy0715', 'Candy0715@gmail.com', 24),
(5, 'Sally0801', 'Sally0801@gmail.com', 40),
(6, 'Super1113', 'Super@gmail.com', 50);
SELECT * FROM Account;


/* create table */
CREATE TABLE Follow (
	AccountID_1 int NOT NULL,
    AccountID_2 int NOT NULL,
    Relation ENUM('Follow','Be_Followed') NOT NULL DEFAULT 'Follow',
    PRIMARY KEY (AccountID_1, AccountID_2),
	FOREIGN KEY (AccountID_1) REFERENCES Account(accountID),
    FOREIGN KEY (AccountID_2) REFERENCES Account(accountID)
);

/* insert */
INSERT INTO Follow
VALUES 
(1, 2, 'Follow'),
(2, 3, 'Follow'),
(3, 2, 'Be_Followed');
SELECT * FROM Follow;


/* create table */
CREATE TABLE Company (
	companyID int NOT NULL,
    companyName varchar(40) NOT NULL,
    Address varchar(40) DEFAULT 'Taipei, Taiwan',
    PRIMARY KEY (companyID),
    FOREIGN KEY (companyID) REFERENCES Producer(companyID)
);

/* insert */
INSERT INTO Company
VALUES 
(1, '7-11', 'Taipei, Taiwan'),
(2, 'Hi-Life', 'Tokyo, Japan'),
(3, 'Family Mart', 'California, USA');
SELECT * FROM Company;


/* create table */
CREATE TABLE Product (
	productName varchar(40) NOT NULL,
    Price int NOT NULL DEFAULT 0 CHECK (Price>=0),
    orderID int,
    companyID int NOT NULL,
    PRIMARY KEY (productName, companyID),
	FOREIGN KEY (orderID) REFERENCES Person(IDnum),
    FOREIGN KEY (companyID) REFERENCES Company(companyID)
);

/* insert */
INSERT INTO Product
VALUES 
('apple', 20, '1','1'),
('banana', 10, '2','2'),
('papaya', 40, NULL,'2');
SELECT * FROM Product;


/* create table */
CREATE TABLE Produce (
	companyID int NOT NULL,
    produceDate Date DEFAULT '1000-01-01', 
    productName varchar(40) NOT NULL,
    PRIMARY KEY (companyID, productName),
    FOREIGN KEY (companyID) REFERENCES Company(companyID),
    FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);

/* insert */
INSERT INTO Produce
VALUES 
(1, '2023-03-08', 'apple'),
(2, '2023-02-07', 'banana'),
(2, '2023-01-08', 'papaya');
SELECT * FROM Produce;


/* create table */
CREATE TABLE Review (
	reviewID int NOT NULL,
	Username varchar(40) DEFAULT 'Anonymous',
	companyID int NOT NULL,
    productName varchar(40) NOT NULL, 
    Stars ENUM ('1','2','3','4','5') NOT NULL,
    Messages varchar(40),
    PRIMARY KEY (reviewID),
    FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);

/* insert */
INSERT INTO Review
VALUES 
(1, 'Allen1021', 1, 'apple', '4', 'Nice seller'),
(2, 'Jackson0328', 2, 'banana', '5', 'Good products'),
(3, 'Zoey0517', 2, 'banana', '1', 'Poor package');
SELECT * FROM Review;


/* create table */
CREATE TABLE OrderList (
	orderID int NOT NULL,
    buyerID int NOT NULL,
    productName varchar(40),
    companyID int,
	Nation varchar(40) DEFAULT 'Taiwan',
    City varchar(40) DEFAULT 'Taipei',
    PRIMARY KEY (orderID),
	FOREIGN KEY (buyerID) REFERENCES Person(IDnum),
	FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);  

/* insert */
INSERT INTO OrderList
VALUES 
(1, 1, 'banana', 2, 'Taiwan','Taipei'),
(2, 1, 'apple', 1, 'USA','California'),
(3, 2, 'papaya', 2, 'Japan','Tokyo');
SELECT * FROM OrderList;


/* create table */
CREATE TABLE OrderDetails (
	orderID int NOT NULL,
	Product varchar(40) NOT NULL,
    Quantity int DEFAULT 1 CHECK (Quantity>=1),
    PRIMARY KEY (orderID, Product),
	FOREIGN KEY (orderID) REFERENCES OrderList(orderID)
);  

/* insert */
INSERT INTO OrderDetails
VALUES 
(1, 'apple', 2),
(1, 'banana', 3),
(2, 'apple', 1);
SELECT * FROM OrderDetails;


/* create table */
CREATE TABLE ShoppingCart (
	cartID int NOT NULL,
    productName varchar(40) NOT NULL,
    companyID int NOT NULL, 
	Quantity int DEFAULT 1, 
    PRIMARY KEY (cartID),
	FOREIGN KEY (cartID) REFERENCES Person(IDnum),
	FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);  

/* insert */
INSERT INTO ShoppingCart
VALUES 
(1, 'banana', 2, 1),
(2, 'apple', 1, 2),
(3, 'papaya', 2, 3);
SELECT * FROM ShoppingCart;


/* create first views (Each view should be based on two tables.)*/
CREATE VIEW GOOD_PRODUCTS AS
SELECT Product.productName, Company.companyName, Review.Stars, Review.Messages
FROM Product, Review, Company
WHERE Company.companyID=Product.companyID and Review.companyID=Product.companyID and Review.productName=Product.productName and Review.Stars in ('4','5');
SELECT * FROM GOOD_PRODUCTS;


/* create second views (Each view should be based on two tables.)*/
CREATE VIEW User_OLDER_THAN_25 AS
SELECT Person.Name, Account.Age
FROM Person, Account
WHERE Person.IDnum=Account.accountID AND Account.Age > 25;
SELECT * FROM User_OLDER_THAN_25;


/* drop database */
DROP DATABASE ShoppingDB;