
-- Create the database
CREATE DATABASE ShipmentDelayDB;
GO

-- Select the database
USE ShipmentDelayDB;
GO

-- 1. Customers table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    City VARCHAR(50)
);
GO

INSERT INTO Customers (Customer_ID, Customer_Name, City)
VALUES
(1, 'Ravi', 'Hyderabad'),
(2, 'Priya', 'Chennai'),
(3, 'Arjun', 'Bengaluru'),
(4, 'Sneha', 'Vijayawada'),
(5, 'Kiran', 'Hyderabad'),
(6, 'Divya', 'Chennai'),
(7, 'Rahul', 'Warangal'),
(8, 'Anu', 'Bengaluru'),
(9, 'Manoj', 'Guntur'),
(10, 'Kavya', 'Hyderabad');

SELECT*FROM Customers;

-- 2. Delivery Partners table
CREATE TABLE Delivery_Partners (
    Partner_ID INT PRIMARY KEY,
    Partner_Name VARCHAR(50),
    Partner_Type VARCHAR(30)
);
GO

INSERT INTO Delivery_Partners
    (Partner_ID, Partner_Name, Partner_Type)
VALUES
(1, 'FastTrack Logistics', 'Express'),
(2, 'SafeMove Couriers', 'Standard'),
(3, 'QuickShip', 'Express'),
(4, 'CityLine Delivery', 'Standard'),
(5, 'Reliable Transport', 'Economy');

SELECT*FROM Delivery_Partners;

-- 3. Locations table
CREATE TABLE Locations (
    Location_ID INT PRIMARY KEY,
    City VARCHAR(50),
    Region VARCHAR(30)
);
GO

INSERT INTO Locations (Location_ID, City, Region)
VALUES
(1, 'Hyderabad', 'South'),
(2, 'Chennai', 'South'),
(3, 'Bengaluru', 'South'),
(4, 'Mumbai', 'West'),
(5, 'Delhi', 'North');

SELECT*FROM Locations;

-- 4. Shipments table
CREATE TABLE Shipments (
    Shipment_ID INT PRIMARY KEY,
    Customer_ID INT,
    Partner_ID INT,
    Location_ID INT,
    Ship_Date DATE,
    Expected_Date DATE,
    Actual_Date DATE,

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),

    FOREIGN KEY (Partner_ID)
        REFERENCES DeliveryPartners(Partner_ID),

    FOREIGN KEY (Location_ID)
        REFERENCES Locations(Location_ID)
);
GO

INSERT INTO Shipments
(Shipment_ID, Customer_ID, Partner_ID, Location_ID,
 Ship_Date, Expected_Date, Actual_Date)
VALUES
(101, 1, 1, 1, '2026-10-01', '2026-10-03', '2026-10-03'),
(102, 2, 2, 2, '2026-10-01', '2026-10-04', '2026-10-06'),
(103, 3, 3, 3, '2026-10-02', '2026-10-05', '2026-10-05'),
(104, 4, 4, 4, '2026-10-02', '2026-10-05', '2026-10-09'),
(105, 5, 1, 1, '2026-10-03', '2026-10-06', '2026-10-06'),
(106, 6, 5, 2, '2026-10-03', '2026-10-07', '2026-10-12'),
(107, 7, 3, 3, '2026-10-04', '2026-10-07', '2026-10-08'),
(108, 8, 2, 4, '2026-10-04', '2026-10-08', '2026-10-08'),
(109, 9, 4, 5, '2026-10-05', '2026-10-09', '2026-10-13'),
(110, 10, 1, 1, '2026-10-05', '2026-10-08', '2026-10-07'),
(111, 1, 5, 2, '2026-10-06', '2026-10-10', '2026-10-15'),
(112, 2, 3, 3, '2026-10-06', '2026-10-09', '2026-10-09'),
(113, 3, 2, 4, '2026-10-07', '2026-10-11', '2026-10-14'),
(114, 4, 4, 5, '2026-10-07', '2026-10-10', '2026-10-10'),
(115, 5, 1, 1, '2026-10-08', '2026-10-11', '2026-10-14'),
(116, 6, 5, 2, '2026-10-08', '2026-10-12', '2026-10-12'),
(117, 7, 3, 3, '2026-10-09', '2026-10-12', '2026-10-16'),
(118, 8, 2, 4, '2026-10-09', '2026-10-13', '2026-10-12'),
(119, 9, 4, 5, '2026-10-10', '2026-10-14', '2026-10-17'),
(120, 10, 1, 1, '2026-10-10', '2026-10-13', '2026-10-13');

SELECT*FROM Shipments;


--Which shipments were delayed the most?

SELECT
    Shipment_ID,
    Expected_Date,
    Actual_Date,
    DATEDIFF(DAY, Expected_Date, Actual_Date)
        AS Delay_Days
FROM Shipments
WHERE Actual_Date > Expected_Date
ORDER BY Delay_Days DESC;

--Which delivery partner has the most delayed shipments?

SELECT
    dp.Partner_Name,
    COUNT(s.Shipment_ID) AS Total_Delayed_Shipments
FROM Shipments AS s
 INNER JOIN DeliveryPartners AS dp
    ON s.Partner_ID = dp.Partner_ID
WHERE s.Actual_Date > s.Expected_Date
GROUP BY dp.Partner_Name
ORDER BY Total_Delayed_Shipments DESC;


--How severe are the delivery delays?

SELECT
    Shipment_ID,
    DATEDIFF(DAY, Expected_Date, Actual_Date) AS Delay_Days,
    CASE
        WHEN Actual_Date <= Expected_Date
            THEN 'On Time'
        WHEN DATEDIFF(DAY, Expected_Date, Actual_Date) <= 2
            THEN 'Slightly Delayed'
        ELSE 'Highly Delayed'
    END AS Delivery_Status
FROM Shipments
ORDER BY Shipment_ID;

--Find shipments delayed by more than two days

SELECT Shipment_ID,
       DATEDIFF(DAY, Expected_Date, Actual_Date) AS Delay_Days
FROM Shipments
WHERE DATEDIFF(DAY, Expected_Date, Actual_Date) > 2;

--Display shipment and customer names — INNER JOIN

SELECT s.Shipment_ID, c.Customer_Name, s.Expected_Date, s.Actual_Date
FROM Shipments s
INNER JOIN Customers c
ON s.Customer_ID = c.Customer_ID;

--Count shipments for each delivery partner

SELECT dp.Partner_Name,
       COUNT(s.Shipment_ID) AS Total_Shipments
FROM Shipments s
INNER JOIN DeliveryPartners dp
    ON s.Partner_ID = dp.Partner_ID
GROUP BY dp.Partner_Name;

SELECT MAX(Actual_Date) AS latest_Delivery_Date
FROM Shipments;

--What percentage of shipments arrived late?

SELECT
    COUNT(*) AS Total_Shipments,
    SUM(CASE
        WHEN Actual_Date > Expected_Date THEN 1
        ELSE 0
    END) AS Delayed_Shipments,
    CAST(
        100.0 * SUM(CASE
            WHEN Actual_Date > Expected_Date THEN 1
            ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Delay_Percentage
FROM Shipments;
