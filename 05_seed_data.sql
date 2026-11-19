-- AutoServiceDB | Step 5: Seed test data
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

INSERT INTO Clients (last_name, first_name, phone, email) VALUES
(N'Петренко', N'Олег',    '+380671234501', 'oleg.petrenko@example.com'),
(N'Коваль',   N'Ірина',   '+380501234502', 'iryna.koval@example.com'),
(N'Мороз',    N'Андрій',  '+380931234503', NULL),
(N'Савченко', N'Наталія', '+380631234504', 'n.savchenko@example.com'),
(N'Лисенко',  N'Віталій', '+380981234505', 'v.lysenko@example.com'),
(N'Гончар',   N'Світлана','+380661234506', NULL);
GO
INSERT INTO Vehicles (client_id, vin, license_plate, make, model, production_year) VALUES
(1, 'WVWZZZ1KZBW123456', 'AA1234KB', N'Volkswagen', N'Golf',    2011),
(1, 'WBA3A5C50DF123457', 'AA5678KH', N'BMW',        N'320i',    2013),
(2, 'TMBJJ7NE5E0123458', 'KA4321BC', N'Skoda',      N'Octavia', 2014),
(3, 'JTDKB20U093123459', 'BC9087AX', N'Toyota',     N'Prius',   2009),
(4, 'KMHJ3813BFU123460', 'AI2468CO', N'Hyundai',    N'Tucson',  2015),
(5, 'VF1LM1B0H12345678', 'AX1357EE', N'Renault',    N'Megane',  2012),
(6, 'ZFA31200003123461', 'AA7777MM', N'Fiat',       N'Doblo',   2018);
GO
INSERT INTO Employees (full_name, [position], phone, hire_date, is_active) VALUES
(N'Коваленко Андрій Петрович',    N'Старший механік',  '+380501112233', '2019-03-01', 1),
(N'Мельник Ігор Олегович',        N'Механік-діагност', '+380671112234', '2020-06-15', 1),
(N'Шевчук Олександр Васильович',  N'Механік',          '+380931112235', '2021-09-01', 1),
(N'Бондаренко Дмитро Сергійович', N'Механік',          '+380631112236', '2022-02-10', 1),
(N'Ткаченко Марина Іванівна',     N'Механік',          '+380991112237', '2018-05-20', 0);
GO
INSERT INTO Services (service_name, base_price, norm_hours) VALUES
(N'Заміна моторної оливи',          450.00, 0.5),
(N'Заміна оливного фільтра',        150.00, 0.3),
(N'Заміна гальмівних колодок',      800.00, 1.0),
(N'Діагностика ходової частини',    400.00, 0.8),
(N'Діагностика двигуна (сканер)',   600.00, 1.0),
(N'Заміна свічок запалювання',      350.00, 0.6),
(N'Розвал-сходження',               900.00, 1.5),
(N'Заміна ременя ГРМ',             2500.00, 3.5);
GO
INSERT INTO Parts (part_name, article, price, stock_qty, min_stock_qty) VALUES
(N'Моторна олива 5W-30, 4 л',        'OIL-5W30-4L', 980.00,  24, 5),
(N'Оливний фільтр',                  'FLT-OIL-001', 180.00,  30, 10),
(N'Повітряний фільтр',               'FLT-AIR-002', 250.00,  15, 5),
(N'Гальмівні колодки передні',       'BRK-PAD-F01', 1100.00, 10, 4),
(N'Гальмівний диск передній',        'BRK-DSK-F01', 1600.00,  6, 2),
(N'Свічка запалювання',              'SPK-PLG-004', 220.00,  40, 12),
(N'Комплект ременя ГРМ',             'TMB-KIT-007', 3200.00,  3, 2),
(N'Гальмівна рідина DOT4, 1 л',      'BRK-FLD-DT4', 210.00,  12, 4);
GO
INSERT INTO Appointments (vehicle_id, scheduled_at, status, [comment]) VALUES
(1, '2026-10-06 09:00', 'Completed', N'Планове ТО'),
(3, '2026-10-08 10:00', 'Completed', N'Скрипить гальмо'),
(2, '2026-10-20 09:00', 'Completed', N'Заміна ременя ГРМ'),
(4, '2026-11-09 09:30', 'Completed', N'Нестабільні оберти двигуна'),
(5, '2026-11-09 10:00', 'Completed', N'Знос гальмівних дисків'),
(6, '2026-11-10 08:30', 'Completed', N'Розвал-сходження'),
(7, '2026-11-14 11:00', 'Confirmed', NULL),
(1, '2026-11-12 15:00', 'Cancelled', N'Клієнт скасував запис'),
(3, '2026-11-05 12:00', 'NoShow',    NULL),
(2, '2026-11-18 10:30', 'Created',   NULL);
GO
INSERT INTO WorkOrders (appointment_id, employee_id, opened_at, closed_at, status) VALUES
(1, 1, '2026-10-06 09:10', '2026-10-06 11:30', 'Closed'),
(2, 2, '2026-10-08 10:00', '2026-10-08 13:15', 'Closed'),
(3, 1, '2026-10-20 09:00', NULL,                'Done'),
(4, 3, '2026-11-09 09:30', NULL,                'InProgress'),
(5, 2, '2026-11-09 10:15', NULL,                'WaitingParts'),
(6, 4, '2026-11-10 08:45', NULL,                'InProgress');
GO
INSERT INTO WorkOrderServices (order_id, service_id, quantity, price_at_order) VALUES
(1, 1, 1, 450.00), (1, 2, 1, 150.00),
(2, 3, 1, 800.00), (2, 4, 1, 400.00),
(3, 8, 1, 2500.00),(3, 1, 1, 450.00),
(4, 5, 1, 600.00), (4, 6, 1, 350.00),
(5, 3, 1, 800.00),
(6, 7, 1, 900.00), (6, 4, 1, 400.00);
GO
INSERT INTO WorkOrderParts (order_id, part_id, quantity, price_at_order) VALUES
(1, 1, 1, 980.00),  (1, 2, 1, 180.00),
(2, 4, 1, 1100.00), (2, 8, 1, 210.00),
(3, 7, 1, 3200.00), (3, 1, 1, 980.00),
(4, 6, 4, 220.00),
(5, 5, 2, 1600.00);
GO
INSERT INTO Payments (order_id, paid_at, amount, method) VALUES
(1, '2026-10-06 11:35', 1760.00, 'Card'),
(2, '2026-10-08 13:10', 1500.00, 'Cash'),
(2, '2026-10-08 13:15', 1010.00, 'Card'),
(3, '2026-10-21 10:00', 5000.00, 'Transfer');   -- часткова оплата
GO
SELECT * FROM Clients;
SELECT * FROM Vehicles;
SELECT * FROM Employees;
SELECT * FROM Services;
SELECT * FROM Parts;
SELECT * FROM Appointments;
SELECT * FROM WorkOrders;
SELECT * FROM WorkOrderServices;
SELECT * FROM WorkOrderParts;
SELECT * FROM Payments;
