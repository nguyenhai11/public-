USE master
DROP DATABASE SellingPoin

--1. Create a database as requested above.
CREATE DATABASE SellingPoin
GO
USE SellingPoin
GO

--2. Create table based on the above design.
CREATE TABLE Categories(
	CateID CHAR(6) PRIMARY KEY,
	CateName NVARCHAR(100) NOT NULL,
	Description NVARCHAR(200),
);

CREATE TABLE Parts(
	PartID INT PRIMARY KEY IDENTITY (1,1),     
	PartName NVARCHAR (100) NOT NULL,
	CateID CHAR(6),
	Description NVARCHAR(1000),
	Price MONEY NOT NULL,
	Quantity INT,
	Warranty INT,
	Photo NVARCHAR (200),
	CONSTRAINT P_C_FK FOREIGN KEY (CateID) REFERENCES Categories(CateID),
);

--3. Insert into each table at least three records.
INSERT INTO Categories VALUES ('ram','RAM',N'Bộ nhớ tạm của máy')
INSERT INTO Categories VALUES ('CSSD','SSD',N'ổ cứng máy tính')
INSERT INTO Categories VALUES ('CHDD','HDD',N'vẫn là ổ cứng nhưng nhanh hơn SSD')
INSERT INTO Categories VALUES ('CPU','CPU',N'Bộ xử lý trung tâm')


INSERT INTO Parts VALUES (N'Ram Laptop Patriot','ram',N'T8GB DDR4 3200MHz PSD48G320081S',340,50,36,'photo/nophoto.png')
INSERT INTO Parts VALUES (N'Ram Laptop Patriot','ram',N'8GB DDR4 3200MHz PSD48G320082S',340,50,36,'photo/nophoto.png')
INSERT INTO Parts VALUES (N'Ổ cứng SSD Silicon Power ','CSSD',N'A80 1TB M.2 2280 Gen3x4 NVMe PCle (SP001TBO34A80M28)',200,50,36,'photo/nophoto.png')
INSERT INTO Parts VALUES (N'Ổ cứng HDD Silicon Power','CHDD',N'Dung lượng lưu trữ: 18TB',700,25,60,'photo/nophoto.png')
INSERT INTO Parts VALUES (N'AMD Athlon 3000G ','CPU',' 5MB / 3.5GHz / 2 nhân 4 luồng / AM4',650,25,36,'photo/nophoto.png')
INSERT INTO Parts VALUES (N'AMD Ryzen 3 3200G','CPU',' 6MB / 4.0GHz / 4 nhân 4 luồng / AM4',700,75,36,'photo/nophoto.png')

--4. List all parts in the store with price > 100$.
SELECT * FROM Parts WHERE Price > 100

--5. List all parts of the category ‘CPU’.
SELECT PartName, Parts.Description, Price, Quantity, Warranty, Photo FROM Parts
JOIN Categories ON
Categories.CateID = Parts.CateID WHERE CateName = 'CPU'

--6. Create a view v_Parts contains the following information (PartID, PartName, CateName, Price, Quantity) from table Parts and Categories.
CREATE VIEW v_Parts 
AS
SELECT PartID, PartName, CateName, Price, Quantity FROM Parts
INNER JOIN Categories ON
Categories.CateID = Parts.CateID 
-- XEM BẢNG VIEW VỪA TẠO
SELECT * FROM v_Parts 

--7. Create a view v_TopParts about 5 parts with the most expensive price.
CREATE VIEW v_TopParts
AS
SELECT TOP(5) PartName, Price FROM Parts
ORDER BY Price DESC 
--XEM BẢNG VIEW VỪA TẠO
SELECT * FROM v_TopParts 

--8. Create a store called sp_SearchPartByCate with input parameter is the category code and retrieve parts of the category.
CREATE PROC sp_SearchPartByCate (@CateID CHAR(6))
AS
SELECT	PartName, Parts.Description, Price, Quantity, Warranty, Photo FROM Parts
		JOIN Categories ON
		Categories.CateID = Parts.CateID WHERE Categories.CateID = @CateID
----CHẠY THỬ
EXEC sp_SearchPartByCate 'ram'

--9. Create a store called sp_AddPart procedure input parameter is the part name, categoryid, description, price and insert this part into database.
CREATE PROC sp_AddPart ( @PartName NVARCHAR(100), @CateID CHAR(6), @Description NVARCHAR(1000), @Price MONEY, @Quantity INT, @Warranty INT, @Photo NVARCHAR (200))
AS
	INSERT INTO Parts VALUES (@PartName, @CateID, @Description, @Price, @Quantity, @Warranty, @Photo)
--CHẠY THỬ
EXEC sp_AddPart 'RAM 1','ram',null,100,12,36, 'photo/nophoto.png'
--XEM BẢNG PARTS
SELECT * FROM Parts

--10. Create a trigger tg_CheckPartName allows to update\add a part which has not name duplicate.
CREATE TRIGGER tg_CheckPartName ON Parts FOR INSERT
AS
	IF (SELECT COUNT(PartName) FROM Parts WHERE PartName = (SELECT PartName FROM inserted)) > 1
	BEGIN
		PRINT N'Tên bị trùng lặp'
		ROLLBACK TRANSACTION
END
--INSERT THỬ DỮ LIỆU TRÙNG LẶP
INSERT INTO Parts VALUES (N'AMD Ryzen 3 3200G','CPU',' 6MB / 4.0GHz / 4 nhân 4 luồng / AM4',700,75,36,'photo/nophoto.png')

