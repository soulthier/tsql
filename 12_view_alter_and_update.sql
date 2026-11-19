-- AutoServiceDB | Step 12: Alter view query, update base tables
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

ALTER VIEW dbo.vw_VehicleOwners
WITH SCHEMABINDING
AS
SELECT v.vehicle_id, v.vin, v.license_plate, v.make, v.model, v.production_year,
       c.last_name, c.first_name, c.phone, c.email
FROM dbo.Vehicles AS v
JOIN dbo.Clients  AS c ON c.client_id = v.client_id
WHERE v.production_year >= 2012;
GO
-- Стан ДО змін: 5 рядків (Golf 2011 і Prius 2009 відсутні)
SELECT * FROM dbo.vw_VehicleOwners ORDER BY vehicle_id;
GO
-- Оновлюємо дані в БАЗОВИХ таблицях
UPDATE dbo.Clients  SET phone = '+380671234599' WHERE client_id = 2;     -- новий телефон власника Skoda
UPDATE dbo.Vehicles SET production_year = 2012 WHERE vehicle_id = 1;      -- Golf потрапляє у вибірку
UPDATE dbo.Vehicles SET production_year = 2010 WHERE vehicle_id = 5;      -- Tucson зникає з вибірки
GO
-- Стан ПІСЛЯ змін: змінений телефон, Golf додано, Tucson більше немає
SELECT * FROM dbo.vw_VehicleOwners ORDER BY vehicle_id;
-- Для порівняння – дані в базових таблицях
SELECT client_id, last_name, phone FROM dbo.Clients WHERE client_id = 2;
SELECT vehicle_id, make, model, production_year FROM dbo.Vehicles WHERE vehicle_id IN (1, 5);
