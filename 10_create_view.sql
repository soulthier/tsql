-- AutoServiceDB | Step 10: Create a view
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

CREATE VIEW dbo.vw_VehicleOwners
AS
SELECT v.vehicle_id, v.vin, v.license_plate, v.make, v.model,
       c.last_name, c.first_name, c.phone
FROM dbo.Vehicles AS v
JOIN dbo.Clients  AS c ON c.client_id = v.client_id;
GO
SELECT * FROM dbo.vw_VehicleOwners;
