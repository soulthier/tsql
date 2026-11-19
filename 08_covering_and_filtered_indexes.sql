-- AutoServiceDB | Step 8: Covering and filtered indexes on a clustered table
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

-- Індекси, що вже існують на Vehicles: PK_Vehicles (CLUSTERED), UQ_Vehicles_Vin (NONCLUSTERED)
SELECT name, type_desc, is_unique, is_primary_key, is_unique_constraint
FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Vehicles');
GO
CREATE NONCLUSTERED INDEX IX_Vehicles_LicensePlate
    ON dbo.Vehicles (license_plate)
    INCLUDE (make, model);
GO
-- Пошук за держномером: Index Seek по IX_Vehicles_LicensePlate без звернення до таблиці
SELECT vehicle_id, license_plate, make, model
FROM dbo.Vehicles
WHERE license_plate = 'AA1234KB';
-- Пошук за VIN: Index Seek по UQ_Vehicles_Vin + Key Lookup по кластеризованому ключу
SELECT * FROM dbo.Vehicles WHERE vin = 'WBA3A5C50DF123457';
GO
-- Унікальний фільтрований індекс: один активний наряд на механіка
CREATE UNIQUE NONCLUSTERED INDEX UX_WorkOrders_Employee_InProgress
    ON dbo.WorkOrders (employee_id)
    WHERE status = 'InProgress';
GO
-- Перевірка: механік 3 уже виконує наряд №4, тож призначити йому наряд №6 не вдасться
BEGIN TRY
    UPDATE dbo.WorkOrders SET employee_id = 3 WHERE order_id = 6;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;   -- помилка 2601
END CATCH;
