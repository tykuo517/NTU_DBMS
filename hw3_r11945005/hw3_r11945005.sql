/* drop database */
DROP DATABASE IF EXISTS ShoppingDB;

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

/***** table creation and insertion *****/
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


CREATE TABLE Person (
	personID int NOT NULL,
    Name varchar(40) NOT NULL,
    Gender ENUM('F','M') DEFAULT 'M',
    PRIMARY KEY (personID),
    FOREIGN KEY (personID) REFERENCES Producer(personID)
);


INSERT INTO Person
VALUES 
(1, 'Allen', 'M'),
(2, 'Jackson', 'M'),
(3, 'Zoey', 'F'),
(4, 'Candy', 'F'),
(5, 'Sally', 'F'),
(6, 'Super', 'M');


CREATE TABLE Account (
	accountID int NOT NULL,
	Username varchar(40) NOT NULL,
    Email varchar(40) NOT NULL,
    Age int DEFAULT 20 CHECK (Age>0),
    PRIMARY KEY (accountID),
    UNIQUE (Username),
    UNIQUE (Email),
    FOREIGN KEY (accountID) REFERENCES Person(personID)
);


INSERT INTO Account
VALUES 
(1, 'Allen1021', 'allen1021@gmail.com', 30),
(2, 'Jackson0328', 'jackson0328@gmail.com', 28),
(3, 'Zoey0517', 'zoeyy@gmail.com', 22),
(4, 'Candy0715', 'Candy0715@gmail.com', 25),
(5, 'Sally0801', 'Sally0801@gmail.com', 40),
(6, 'Super1113', 'Super@gmail.com', 50);


CREATE TABLE Follow (
	AccountID_1 int NOT NULL,
    AccountID_2 int NOT NULL,
    Relation ENUM('Follow','Be_Followed') NOT NULL DEFAULT 'Follow',
    PRIMARY KEY (AccountID_1, AccountID_2),
	FOREIGN KEY (AccountID_1) REFERENCES Account(accountID),
    FOREIGN KEY (AccountID_2) REFERENCES Account(accountID)
);


INSERT INTO Follow
VALUES 
(1, 2, 'Follow'),
(2, 3, 'Follow'),
(3, 2, 'Be_Followed');


CREATE TABLE Company (
	companyID int NOT NULL,
    companyName varchar(40) NOT NULL,
    Address varchar(40) DEFAULT 'Taipei, Taiwan',
    PRIMARY KEY (companyID),
    FOREIGN KEY (companyID) REFERENCES Producer(companyID)
);


INSERT INTO Company
VALUES 
(1, '7-11', 'Taipei, Taiwan'),
(2, 'Hi-Life', 'Tokyo, Japan'),
(3, 'Family Mart', 'California, USA');


CREATE TABLE Product (
	productName varchar(40) NOT NULL,
    Price int NOT NULL DEFAULT 0 CHECK (Price>=0),
    orderID int,
    companyID int NOT NULL,
    PRIMARY KEY (productName, companyID),
	FOREIGN KEY (orderID) REFERENCES Person(personID),
    FOREIGN KEY (companyID) REFERENCES Company(companyID)
);


INSERT INTO Product
VALUES 
('apple', 20, '1','1'),
('banana', 10, '2','2'),
('papaya', 40, NULL,'2');


CREATE TABLE Produce (
	companyID int NOT NULL,
    produceDate Date DEFAULT '1000-01-01', 
    productName varchar(40) NOT NULL,
    PRIMARY KEY (companyID, productName),
    FOREIGN KEY (companyID) REFERENCES Company(companyID),
    FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);


INSERT INTO Produce
VALUES 
(1, '2023-03-08', 'apple'),
(2, '2023-02-07', 'banana'),
(2, '2023-01-08', 'papaya');


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


INSERT INTO Review
VALUES 
(1, 'Allen1021', 1, 'apple', '4', 'Nice seller'),
(2, 'Jackson0328', 2, 'banana', '5', 'Good products'),
(3, 'Zoey0517', 2, 'banana', '1', 'Poor package');


CREATE TABLE OrderList (
	orderID int NOT NULL,
    personID int NOT NULL,
	Nation varchar(40) DEFAULT 'Taiwan',
    City varchar(40) DEFAULT 'Taipei',
    PRIMARY KEY (orderID),
	FOREIGN KEY (personID) REFERENCES Person(personID)
);  


INSERT INTO OrderList
VALUES 
(1, 1, 'Taiwan','Taipei'),
(2, 1, 'USA','California'),
(3, 2, 'Japan','Tokyo'),
(4, 3, 'Taiwan','Hsinchu'),
(5, 1, 'Taiwan','Taichung'),
(6, 2, 'Japan','Tokyo');

CREATE TABLE OrderDetails (
	orderID int NOT NULL,
	productName varchar(40),
    companyID int,
    Quantity int DEFAULT 1 CHECK (Quantity>=1),
    PRIMARY KEY (orderID, productName),
	FOREIGN KEY (orderID) REFERENCES OrderList(orderID),
    FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);  


INSERT INTO OrderDetails
VALUES 
(1, 'banana', 2, 2),
(1, 'apple', 1, 3),
(2, 'papaya', 2, 1),
(4, 'banana', 2, 2),
(3, 'banana', 2, 2),
(1, 'papaya', 2, 2);


CREATE TABLE ShoppingCart (
	cartID int NOT NULL,
    productName varchar(40) NOT NULL,
    companyID int NOT NULL, 
	Quantity int DEFAULT 1, 
    PRIMARY KEY (cartID),
	FOREIGN KEY (cartID) REFERENCES Person(personID),
	FOREIGN KEY (productName, companyID) REFERENCES Product(productName, companyID)
);  


INSERT INTO ShoppingCart
VALUES 
(1, 'banana', 2, 1),
(2, 'apple', 1, 2),
(3, 'papaya', 2, 3);


/* create first views (Each view should be based on two tables.)*/
CREATE VIEW GOOD_PRODUCTS AS
SELECT Product.productName, Company.companyName, Review.Stars, Review.Messages
FROM Product, Review, Company
WHERE Company.companyID=Product.companyID and Review.companyID=Product.companyID and Review.productName=Product.productName and Review.Stars in ('4','5');
SELECT * FROM GOOD_PRODUCTS;

CREATE VIEW User_OLDER_THAN_25 AS
SELECT Person.Name, Account.Age
FROM Person, Account
WHERE Person.personID=Account.accountID AND Account.Age > 25;
SELECT * FROM User_OLDER_THAN_25;


/***** homework 3 commands *****/
/* basic select */
SELECT * FROM OrderList WHERE personID=1 AND (Nation='Taiwan' OR Nation='USA') AND NOT City='Taichung';

/* basic projection */
SELECT Username, Email FROM Account;

/* basic rename */
SELECT R.Username AS Commenter, R.productName AS Product, R.Stars, R.Messages AS Comment FROM Review AS R;

/* union */
CREATE TABLE Product_unlisted (
	productName varchar(40) NOT NULL,
    Price int NOT NULL DEFAULT 0 CHECK (Price>=0),
    orderID int DEFAULT NULL ,
    companyID int NOT NULL,
    PRIMARY KEY (productName, companyID),
	FOREIGN KEY (orderID) REFERENCES Person(personID),
    FOREIGN KEY (companyID) REFERENCES Company(companyID)
);

INSERT INTO Product_unlisted
VALUES 
('Pants', 50, NULL, 1),
('T-shirts', 20, NULL, 3),
('Socks', 10, NULL, 1);

TABLE Product
UNION
TABLE Product_unlisted;

/* equijoin */
SELECT * FROM Person 
JOIN Account 
ON Person.personID = Account.accountID;

/* natural join */
SELECT * FROM Company 
NATURAL JOIN Product;

/* theta join */ 
SELECT * FROM Product
JOIN Review
ON Product.productName < Review.productName;

/* three table join */
SELECT Company.companyName, Company.Address,OrderList.Nation,OrderList.City,OrderDetails.productName,OrderDetails.Quantity
FROM Company, OrderList, OrderDetails
WHERE Company.companyID=OrderDetails.companyID AND OrderDetails.orderID=OrderList.orderID;

/* aggregate */
SELECT Company.companyName,OrderDetails.productName,MAX(OrderDetails.Quantity),MIN(OrderDetails.Quantity),COUNT(*)
FROM Company, OrderDetails
WHERE Company.companyID=OrderDetails.companyID
GROUP BY Company.companyName,OrderDetails.productName;

/* aggregate 2 */
SELECT Company.companyName,OrderDetails.productName,AVG(OrderDetails.Quantity),SUM(OrderDetails.Quantity),COUNT(*)
FROM Company, OrderDetails
WHERE Company.companyID=OrderDetails.companyID
GROUP BY Company.companyName,OrderDetails.productName;

/* in */
SELECT *
From Account
WHERE Age IN (20, 25, 30);

/* in 2 */
SELECT *
FROM Account
WHERE Username IN (SELECT Username FROM Review);

/* correlated nested query */
SELECT C.companyName, P.Liscense, P.Startdate 
FROM Producer AS P, Company AS C
WHERE P.companyID IN (SELECT DISTINCT C.companyID FROM Company AS C, OrderDetails AS O WHERE  C.companyID=O.companyID) AND P.companyID=C.companyID;

/* correlated nested query 2 */
SELECT P.Name, P.gender
FROM Person AS P
WHERE EXISTS (SELECT * FROM OrderList AS O WHERE P.personID=O.personID);

/* bonus 1 */
SELECT P.Name, O.Nation AS Shipping_Nation, O.city AS Shipping_City
FROM Person AS P
LEFT JOIN OrderList AS O
ON P.personID=O.personID;

/* bonus 2 */
SELECT P.Name, P.gender
FROM Person AS P
WHERE NOT EXISTS (SELECT * FROM OrderList AS O WHERE P.personID=O.personID);


/* drop database */
DROP DATABASE ShoppingDB;