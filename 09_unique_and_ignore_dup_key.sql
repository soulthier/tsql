-- AutoServiceDB | Step 9: Unique indexes and IGNORE_DUP_KEY
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

-- Прибираємо тестовий дублікат, доданий у кроці 7
DELETE FROM ClientsDemo WHERE last_name = N'Дублікат';
GO
-- 9.1 Кластеризований індекс: видалити та створити як UNIQUE
DROP INDEX CIX_ClientsDemo_ClientId ON ClientsDemo;
GO
CREATE UNIQUE CLUSTERED INDEX CIX_ClientsDemo_ClientId
    ON ClientsDemo (client_id);
GO
BEGIN TRY   -- дублікат client_id тепер заборонено
    INSERT INTO ClientsDemo (client_id, last_name, first_name, phone, registered_at)
    VALUES (1, N'Дублікат', N'Тест', '+380670000001', CAST(GETDATE() AS date));
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;   -- помилка 2601
END CATCH;
GO
-- 9.2 Некластеризований індекс за телефоном: UNIQUE + IGNORE_DUP_KEY = ON
DROP INDEX IX_ClientsDemo_Phone ON ClientsDemo;
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_ClientsDemo_Phone
    ON ClientsDemo (phone)
    WITH (IGNORE_DUP_KEY = ON);
GO
-- Другий рядок дублює телефон клієнта №1: він пропускається, інші два вставляються
INSERT INTO ClientsDemo (client_id, last_name, first_name, phone, registered_at) VALUES
(101, N'Новак',   N'Роман', '+380671110001', CAST(GETDATE() AS date)),
(102, N'Дубенко', N'Павло', '+380671234501', CAST(GETDATE() AS date)),
(103, N'Руденко', N'Анна',  '+380671110003', CAST(GETDATE() AS date));
GO
-- Повідомлення: «Duplicate key was ignored.» (2 row(s) affected)
SELECT * FROM ClientsDemo WHERE client_id >= 100;   -- 2 рядки: 101 і 103
-- 9.3 Зміна параметра без перестворення індексу: IGNORE_DUP_KEY = OFF
ALTER INDEX IX_ClientsDemo_Phone ON ClientsDemo
    REBUILD WITH (IGNORE_DUP_KEY = OFF);
GO
BEGIN TRY   -- тепер дублікат телефону скасовує весь INSERT
    INSERT INTO ClientsDemo (client_id, last_name, first_name, phone, registered_at) VALUES
    (104, N'Мельник', N'Юрій',  '+380671110004', CAST(GETDATE() AS date)),
    (105, N'Дубенко', N'Павло', '+380671234501', CAST(GETDATE() AS date));
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;   -- помилка 2601
END CATCH;
GO
SELECT * FROM ClientsDemo WHERE client_id >= 100;   -- як і раніше 2 рядки: 104 не вставлено
-- Підсумкова перевірка властивостей індексів
SELECT name, type_desc, is_unique, ignore_dup_key
FROM sys.indexes WHERE object_id = OBJECT_ID('ClientsDemo');
