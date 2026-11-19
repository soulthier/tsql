-- AutoServiceDB | Step 6: Integrity tests (TRY...CATCH)
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

-- 6.1 Доменна цілісність: неправильний формат телефону (CHECK)
BEGIN TRY
    INSERT INTO Clients (last_name, first_name, phone) VALUES (N'Тестов', N'Тест', '0671234567');
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
-- 6.2 Цілісність сутностей: повторний VIN (UNIQUE, помилка 2627)
BEGIN TRY
    INSERT INTO Vehicles (client_id, vin, license_plate, make, model, production_year)
    VALUES (2, 'WVWZZZ1KZBW123456', 'KA0001AA', N'Audi', N'A4', 2016);
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
-- 6.3 Посилальна цілісність: видалення клієнта, що має автомобілі (FK, помилка 547)
BEGIN TRY
    DELETE FROM Clients WHERE client_id = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
-- 6.4 Некоректний статус запису (CHECK)
BEGIN TRY
    UPDATE Appointments SET status = 'Unknown' WHERE appointment_id = 10;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;
-- 6.5 Каскадне видалення рядків наряду (в транзакції з відкатом)
BEGIN TRAN;
    SELECT COUNT(*) AS PartsBefore FROM WorkOrderParts WHERE order_id = 5;
    DELETE FROM WorkOrders WHERE order_id = 5;      -- платежів за нарядом немає
    SELECT COUNT(*) AS PartsAfter FROM WorkOrderParts WHERE order_id = 5;       -- 0
    SELECT COUNT(*) AS ServicesAfter FROM WorkOrderServices WHERE order_id = 5; -- 0
ROLLBACK TRAN;
