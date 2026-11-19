-- AutoServiceDB | Step 2: Create tables
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

USE AutoServiceDB;
GO
CREATE TABLE Clients
(
    client_id     int IDENTITY(1,1) NOT NULL,
    last_name     nvarchar(50)  NOT NULL,
    first_name    nvarchar(50)  NOT NULL,
    phone         varchar(20)   NOT NULL,
    email         varchar(100)  NULL,
    registered_at date          NOT NULL
        CONSTRAINT DF_Clients_RegisteredAt DEFAULT (CAST(GETDATE() AS date))
);
GO
CREATE TABLE Vehicles
(
    vehicle_id      int IDENTITY(1,1) NOT NULL,
    client_id       int           NOT NULL,
    vin             char(17)      NOT NULL,
    license_plate   nvarchar(15)  NOT NULL,
    make            nvarchar(40)  NOT NULL,
    model           nvarchar(40)  NOT NULL,
    production_year smallint      NULL
);
GO
CREATE TABLE Employees
(
    employee_id int IDENTITY(1,1) NOT NULL,
    full_name   nvarchar(100) NOT NULL,
    [position]  nvarchar(50)  NOT NULL,
    phone       varchar(20)   NOT NULL,
    hire_date   date          NOT NULL,
    is_active   bit           NOT NULL
        CONSTRAINT DF_Employees_IsActive DEFAULT (1)
);
GO
CREATE TABLE Services
(
    service_id   int IDENTITY(1,1) NOT NULL,
    service_name nvarchar(100) NOT NULL,
    base_price   decimal(10,2) NOT NULL,
    norm_hours   decimal(4,1)  NOT NULL
);
GO
CREATE TABLE Parts
(
    part_id       int IDENTITY(1,1) NOT NULL,
    part_name     nvarchar(100) NOT NULL,
    article       varchar(30)   NOT NULL,
    price         decimal(10,2) NOT NULL,
    stock_qty     int           NOT NULL CONSTRAINT DF_Parts_StockQty DEFAULT (0),
    min_stock_qty int           NOT NULL CONSTRAINT DF_Parts_MinStockQty DEFAULT (0)
);
GO
CREATE TABLE Appointments
(
    appointment_id int IDENTITY(1,1) NOT NULL,
    vehicle_id     int           NOT NULL,
    scheduled_at   datetime2(0)  NOT NULL,
    status         varchar(15)   NOT NULL CONSTRAINT DF_Appointments_Status DEFAULT ('Created'),
    [comment]      nvarchar(255) NULL,
    created_at     datetime2(0)  NOT NULL CONSTRAINT DF_Appointments_CreatedAt DEFAULT (SYSDATETIME())
);
GO
CREATE TABLE WorkOrders
(
    order_id       int IDENTITY(1,1) NOT NULL,
    appointment_id int          NOT NULL,
    employee_id    int          NOT NULL,
    opened_at      datetime2(0) NOT NULL CONSTRAINT DF_WorkOrders_OpenedAt DEFAULT (SYSDATETIME()),
    closed_at      datetime2(0) NULL,
    status         varchar(15)  NOT NULL CONSTRAINT DF_WorkOrders_Status DEFAULT ('Open')
);
GO
CREATE TABLE WorkOrderServices
(
    order_id       int           NOT NULL,
    service_id     int           NOT NULL,
    quantity       smallint      NOT NULL CONSTRAINT DF_WOS_Quantity DEFAULT (1),
    price_at_order decimal(10,2) NOT NULL
);
GO
CREATE TABLE WorkOrderParts
(
    order_id       int           NOT NULL,
    part_id        int           NOT NULL,
    quantity       int           NOT NULL CONSTRAINT DF_WOP_Quantity DEFAULT (1),
    price_at_order decimal(10,2) NOT NULL
);
GO
CREATE TABLE Payments
(
    payment_id int IDENTITY(1,1) NOT NULL,
    order_id   int           NOT NULL,
    paid_at    datetime2(0)  NOT NULL CONSTRAINT DF_Payments_PaidAt DEFAULT (SYSDATETIME()),
    amount     decimal(10,2) NOT NULL,
    method     varchar(10)   NOT NULL
);
GO
