-- AutoServiceDB | Step 4: CHECK constraints
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

-- Клієнти: формат телефону +380XXXXXXXXX, коректний e-mail
ALTER TABLE Clients ADD
    CONSTRAINT CN_Clients_Phone CHECK
        (phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CN_Clients_Email CHECK
        (email IS NULL OR email LIKE '_%@_%._%');
-- Автомобілі: VIN рівно 17 символів, розумний рік випуску
ALTER TABLE Vehicles ADD
    CONSTRAINT CN_Vehicles_Vin  CHECK (LEN(vin) = 17),
    CONSTRAINT CN_Vehicles_Year CHECK (production_year BETWEEN 1950 AND 2100);
-- Працівники: формат телефону, дата прийому не в майбутньому
ALTER TABLE Employees ADD
    CONSTRAINT CN_Employees_Phone CHECK
        (phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CN_Employees_HireDate CHECK (hire_date <= GETDATE());
-- Послуги: ціна невід’ємна, норма-години додатні
ALTER TABLE Services ADD
    CONSTRAINT CN_Services_Price CHECK (base_price >= 0),
    CONSTRAINT CN_Services_NormHours CHECK (norm_hours > 0);
-- Запчастини: залишок, мінімальний залишок і ціна не можуть бути від’ємними
ALTER TABLE Parts ADD
    CONSTRAINT CN_Parts_Price CHECK (price >= 0),
    CONSTRAINT CN_Parts_Stock CHECK (stock_qty >= 0),
    CONSTRAINT CN_Parts_MinStock CHECK (min_stock_qty >= 0);
-- Статуси записів і нарядів (життєві цикли з розділу 5 РГР)
ALTER TABLE Appointments ADD CONSTRAINT CN_Appointments_Status CHECK
    (status IN ('Created','Confirmed','Completed','Cancelled','NoShow'));
ALTER TABLE WorkOrders ADD
    CONSTRAINT CN_WorkOrders_Status CHECK
        (status IN ('Open','InProgress','WaitingParts','Done','Closed')),
    CONSTRAINT CN_WorkOrders_Dates CHECK
        (closed_at IS NULL OR closed_at >= opened_at);
-- Позиції наряду
ALTER TABLE WorkOrderServices ADD
    CONSTRAINT CN_WOS_Quantity CHECK (quantity > 0),
    CONSTRAINT CN_WOS_Price CHECK (price_at_order >= 0);
ALTER TABLE WorkOrderParts ADD
    CONSTRAINT CN_WOP_Quantity CHECK (quantity > 0),
    CONSTRAINT CN_WOP_Price CHECK (price_at_order >= 0);
-- Платежі: сума додатна, спосіб оплати зі списку
ALTER TABLE Payments ADD
    CONSTRAINT CN_Payments_Amount CHECK (amount > 0),
    CONSTRAINT CN_Payments_Method CHECK (method IN ('Cash','Card','Transfer'));
GO
