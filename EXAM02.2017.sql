CREATE DATABASE Bakery
GO
USE Bakery
-- DDL
CREATE TABLE Customers
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Customers PRIMARY KEY,
FirstName nvarchar(25),
LastName nvarchar(25),
Gender char(1),
Age int,
PhoneNumber char(10),
CountryId int NOT NULL)

ALTER TABLE Customers
ADD CONSTRAINT CK_Customers_Gender CHECK (Gender = 'M' OR Gender = 'F')

ALTER TABLE Customers
ADD CONSTRAINT CK_Customers_PhoneNumber CHECK(LEN(PhoneNumber) = 10)

CREATE TABLE Countries
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Countries PRIMARY KEY,
Name nvarchar(50) NOT NULL UNIQUE)

ALTER TABLE Customers
ADD CONSTRAINT FK_Customers_Countries FOREIGN KEY (CountryId)
REFERENCES Countries (Id)
ON DELETE CASCADE
ON UPDATE CASCADE

CREATE TABLE Feedbacks
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Feedbacks PRIMARY KEY,
Description nvarchar(255),
Rate decimal(4, 2),
ProductId int NOT NULL,
CustomerId int NOT NULL)

ALTER TABLE Feedbacks
ADD CONSTRAINT CK_Rate CHECK (Rate BETWEEN 0 AND 10)

CREATE TABLE Products
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Products PRIMARY KEY,
Name nvarchar(25) NOT NULL,
Description nvarchar(250),
Recipe nvarchar(MAX),
Price money)

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (Name)

ALTER TABLE Products
ADD CONSTRAINT CK_Price CHECK (Price >= 0)

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Feedbacks_Products FOREIGN KEY (ProductId)
REFERENCES Products (Id)

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Feedbacks_Customers FOREIGN KEY (CustomerId)
REFERENCES Customers (Id)

CREATE TABLE Ingredients
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Ingredients PRIMARY KEY,
Name nvarchar(30),
Description nvarchar(200),
OriginCountryId int NOT NULL,
DistributorId int NOT NULL)

CREATE TABLE ProductsIngredients
(ProductId int NOT NULL,
IngredientId int NOT NULL)

ALTER TABLE ProductsIngredients
ADD CONSTRAINT PK_ProductsIngredients PRIMARY KEY (ProductId, IngredientId) 

ALTER TABLE ProductsIngredients
ADD CONSTRAINT FK_ProductsIngredients_Products FOREIGN KEY (ProductId)
REFERENCES Products (Id)

ALTER TABLE ProductsIngredients
ADD CONSTRAINT FK_ProductsIngredients_Ingredients FOREIGN KEY (IngredientId)
REFERENCES Ingredients (Id)

CREATE TABLE Distributors
(Id int NOT NULL IDENTITY
CONSTRAINT PK_Distributors PRIMARY KEY,
Name nvarchar(25) NOT NULL UNIQUE,
AddressText nvarchar(30),
Summary nvarchar(200),
CountryId int NOT NULL)

ALTER TABLE Distributors
ADD CONSTRAINT FK_Distributors_Countries FOREIGN KEY (CountryId)
REFERENCES Countries (Id)

ALTER TABLE Ingredients
ADD CONSTRAINT FK_Ingredients_Countries FOREIGN KEY (OriginCountryId)
REFERENCES Countries (Id)

ALTER TABLE Ingredients
ADD CONSTRAINT FK_Ingredients_Distributors FOREIGN KEY (DistributorId)
REFERENCES Distributors (Id)

-- INSERT
INSERT INTO Distributors (Name, CountryId, AddressText, Summary)
VALUES 
('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')


INSERT INTO Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
VALUES
('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
('Kendra', 'Loud', 22, 'F', '0063631526', 11),
('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
('Tom', 'Loeza', 31, 'M', '0144876096', 23),
('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

--UPDATE
UPDATE Ingredients
SET DistributorId = 35
WHERE Name IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8


-- DELETE
DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5

-- 08. Best Rated Products
SELECT TOP 10
       p.Name, 
	   p.Description, 
	   AVG(F.Rate) AS AverageRate, 
	   COUNT(*) AS FeedbacksAmount
FROM Products AS p
JOIN Feedbacks AS f ON f.ProductId = P.Id
GROUP BY p.Name, p.Description
ORDER BY AverageRate DESC, FeedbacksAmount DESC

-- 09. Negative Feedback
SELECT f.ProductId, f.Rate, f.Description,
       f.CustomerId, c.Age, c.Gender
FROM Feedbacks AS f
JOIN Customers AS c ON c.Id = f.CustomerId
WHERE f.Rate < 5
ORDER BY f.ProductId DESC, f.Rate

-- 10. Customers without Feedback
