-- AutoServiceDB | Step 3: Primary, unique and foreign keys
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

-- Первинні ключі та обмеження унікальності
ALTER TABLE Clients ADD
    CONSTRAINT PK_Clients PRIMARY KEY (client_id),
    CONSTRAINT UQ_Clients_Phone UNIQUE (phone);
ALTER TABLE Vehicles ADD
    CONSTRAINT PK_Vehicles PRIMARY KEY (vehicle_id),
    CONSTRAINT UQ_Vehicles_Vin UNIQUE (vin);
ALTER TABLE Employees ADD
    CONSTRAINT PK_Employees PRIMARY KEY (employee_id);
ALTER TABLE Services ADD
    CONSTRAINT PK_Services PRIMARY KEY (service_id),
    CONSTRAINT UQ_Services_Name UNIQUE (service_name);
ALTER TABLE Parts ADD
    CONSTRAINT PK_Parts PRIMARY KEY (part_id),
    CONSTRAINT UQ_Parts_Article UNIQUE (article);
ALTER TABLE Appointments ADD
    CONSTRAINT PK_Appointments PRIMARY KEY (appointment_id);
ALTER TABLE WorkOrders ADD
    CONSTRAINT PK_WorkOrders PRIMARY KEY (order_id),
    CONSTRAINT UQ_WorkOrders_Appointment UNIQUE (appointment_id);
ALTER TABLE WorkOrderServices ADD
    CONSTRAINT PK_WorkOrderServices PRIMARY KEY (order_id, service_id);
ALTER TABLE WorkOrderParts ADD
    CONSTRAINT PK_WorkOrderParts PRIMARY KEY (order_id, part_id);
ALTER TABLE Payments ADD
    CONSTRAINT PK_Payments PRIMARY KEY (payment_id);
GO
-- Зовнішні ключі
ALTER TABLE Vehicles ADD CONSTRAINT FK_Vehicles_Clients
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE NO ACTION;
ALTER TABLE Appointments ADD CONSTRAINT FK_Appointments_Vehicles
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE NO ACTION;
ALTER TABLE WorkOrders ADD CONSTRAINT FK_WorkOrders_Appointments
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE NO ACTION;
ALTER TABLE WorkOrders ADD CONSTRAINT FK_WorkOrders_Employees
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE NO ACTION;
ALTER TABLE WorkOrderServices ADD CONSTRAINT FK_WOS_WorkOrders
    FOREIGN KEY (order_id) REFERENCES WorkOrders(order_id) ON DELETE CASCADE;
ALTER TABLE WorkOrderServices ADD CONSTRAINT FK_WOS_Services
    FOREIGN KEY (service_id) REFERENCES Services(service_id) ON DELETE NO ACTION;
ALTER TABLE WorkOrderParts ADD CONSTRAINT FK_WOP_WorkOrders
    FOREIGN KEY (order_id) REFERENCES WorkOrders(order_id) ON DELETE CASCADE;
ALTER TABLE WorkOrderParts ADD CONSTRAINT FK_WOP_Parts
    FOREIGN KEY (part_id) REFERENCES Parts(part_id) ON DELETE NO ACTION;
ALTER TABLE Payments ADD CONSTRAINT FK_Payments_WorkOrders
    FOREIGN KEY (order_id) REFERENCES WorkOrders(order_id) ON DELETE NO ACTION;
GO
