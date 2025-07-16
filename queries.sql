CREATE DATABASE IF NOT EXISTS ElectricityBilling; 
USE ElectricityBilling; 
 
DROP TABLE IF EXISTS Bills; 
DROP TABLE IF EXISTS ElectricityRates; 
DROP TABLE IF EXISTS Users; 
 
CREATE TABLE Users ( 
    UserID INT PRIMARY KEY AUTO_INCREMENT, 
    UserName VARCHAR(50), 
    Address VARCHAR(100) 
); 
 
CREATE TABLE ElectricityRates ( 
    RateID INT PRIMARY KEY, 
    RatePerUnit DECIMAL(10, 2) 
); 
 
CREATE TABLE Bills ( 
    BillID INT PRIMARY KEY AUTO_INCREMENT, 
    UserID INT, 
    MeterReading INT, 
    BillAmount DECIMAL(10, 2), 
    BillDate DATE, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
INSERT INTO ElectricityRates (RateID, RatePerUnit) VALUES 
(1, 0.15); 
 
DELIMITER // 
CREATE PROCEDURE GenerateBill() 
BEGIN 
    DECLARE v_userID INT; 
    DECLARE v_userName VARCHAR(50); 
    DECLARE v_userAddress VARCHAR(100); 
    DECLARE v_meterReading INT; 
    DECLARE v_ratePerUnit DECIMAL(10, 2); 
    DECLARE v_billAmount DECIMAL(10, 2); 
 
    SET v_userName = (SELECT UserName FROM  
   (SELECT @input_userName AS UserName) AS temp); 
    SET v_userAddress = (SELECT Address FROM  
   (SELECT @input_userAddress AS Address) AS temp); 
    SET v_meterReading = (SELECT MeterReading FROM (SELECT 
@input_meterReading AS MeterReading) AS temp); 
 
    SET v_userID = (SELECT IFNULL(MAX(UserID), 0) + 1 FROM Users);  
 
    INSERT INTO Users (UserName, Address) VALUES (v_userName, 
v_userAddress); 

  SELECT RatePerUnit INTO v_ratePerUnit FROM ElectricityRates  
    WHERE RateID = 1; 
 
    SET v_billAmount = v_meterReading * v_ratePerUnit; 
 
    INSERT INTO Bills (UserID, MeterReading, BillAmount, BillDate) 
    VALUES (v_userID, v_meterReading, v_billAmount, CURDATE()); 
 
    SELECT 'Bill generated successfully!' AS Message, 
           v_userID AS UserID, 
           v_userName AS UserName, 
           v_meterReading AS MeterReading, 
           v_billAmount AS BillAmount, 
           CURDATE() AS BillDate;
END // 
DELIMITER ; 
 
SET @input_userName = 'Alice Smith'; 
SET @input_userAddress = '123 Main St'; 
SET @input_meterReading = 100; 
 
CALL GenerateBill();