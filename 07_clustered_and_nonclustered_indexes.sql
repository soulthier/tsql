-- AutoServiceDB | Step 7: Clustered and nonclustered indexes
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

CREATE TABLE ClientsDemo
(
    client_id     int           NOT NULL,
    last_name     nvarchar(50)  NOT NULL,
    first_name    nvarchar(50)  NOT NULL,
    phone         varchar(20)   NOT NULL,
    email         varchar(100)  NULL,
    registered_at date          NOT NULL
);
GO
INSERT INTO ClientsDemo (client_id, last_name, first_name, phone, email, registered_at)
SELECT client_id, last_name, first_name, phone, email, registered_at
FROM Clients;
GO
-- Таблиця без індексів: type_desc = HEAP
SELECT name, type_desc FROM sys.indexes WHERE object_id = OBJECT_ID('ClientsDemo');
GO
-- Кластеризований індекс: визначає фізичний порядок рядків (може бути лише один)
CREATE CLUSTERED INDEX CIX_ClientsDemo_ClientId
    ON ClientsDemo (client_id);
GO
-- Некластеризований індекс: окрема B-дерево структура з покажчиками на рядки
CREATE NONCLUSTERED INDEX IX_ClientsDemo_Phone
    ON ClientsDemo (phone);
GO
-- Індекси не унікальні, тому дублікати дозволені (client_id = 1 і телефон повторюються)
INSERT INTO ClientsDemo (client_id, last_name, first_name, phone, registered_at)
VALUES (1, N'Дублікат', N'Тест', '+380671234501', CAST(GETDATE() AS date));
GO
-- Перевірка використання індексів (Ctrl+M – Include Actual Execution Plan)
SELECT * FROM ClientsDemo ORDER BY client_id;               -- Clustered Index Scan
SELECT * FROM ClientsDemo WHERE phone = '+380671234501';    -- пошук за телефоном
-- На малій таблиці оптимізатор може обрати скан кластеризованого індексу,
-- тому для демонстрації некластеризованого індексу вказуємо підказку:
SELECT * FROM ClientsDemo WITH (INDEX(IX_ClientsDemo_Phone))
WHERE phone = '+380671234501';                              -- Index Seek + Key Lookup
-- Перелік індексів таблиці
SELECT name, type_desc, is_unique, ignore_dup_key
FROM sys.indexes WHERE object_id = OBJECT_ID('ClientsDemo');
