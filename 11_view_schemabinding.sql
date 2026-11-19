-- AutoServiceDB | Step 11: Add WITH SCHEMABINDING
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

ALTER VIEW dbo.vw_VehicleOwners
WITH SCHEMABINDING
AS
SELECT v.vehicle_id, v.vin, v.license_plate, v.make, v.model,
       c.last_name, c.first_name, c.phone
FROM dbo.Vehicles AS v
JOIN dbo.Clients  AS c ON c.client_id = v.client_id;
GO
-- Перевірка: 1 означає, що представлення прив’язане до схеми
SELECT OBJECTPROPERTY(OBJECT_ID('dbo.vw_VehicleOwners'), 'IsSchemaBound') AS IsSchemaBound;
-- Спроби порушити схему завершуються помилкою
BEGIN TRY
    DROP TABLE dbo.Vehicles;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
BEGIN TRY
    ALTER TABLE dbo.Vehicles DROP COLUMN model;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
