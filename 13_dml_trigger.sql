-- AutoServiceDB | Step 13: DML trigger for stock control
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

CREATE TRIGGER dbo.trg_WorkOrderParts_Stock
ON dbo.WorkOrderParts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    -- Сумарна зміна залишку по кожній запчастині:
    -- нові значення списуються (мінус), старі повертаються на склад (плюс)
    DECLARE @delta TABLE (part_id int PRIMARY KEY, qty_change int NOT NULL);
    INSERT INTO @delta (part_id, qty_change)
    SELECT part_id, SUM(qty_change)
    FROM (
        SELECT part_id, -quantity AS qty_change FROM inserted
        UNION ALL
        SELECT part_id,  quantity AS qty_change FROM deleted
    ) AS x
    GROUP BY part_id;
    -- Списання понад залишок заборонено
    IF EXISTS (SELECT 1
               FROM dbo.Parts AS p
               JOIN @delta   AS d ON d.part_id = p.part_id
               WHERE p.stock_qty + d.qty_change < 0)
    BEGIN
        RAISERROR(N'Недостатньо запчастин на складі: списання понад залишок заборонено.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    UPDATE p
    SET    p.stock_qty = p.stock_qty + d.qty_change
    FROM   dbo.Parts AS p
    JOIN   @delta    AS d ON d.part_id = p.part_id;
END;
GO
-- Початковий стан
SELECT part_id, part_name, stock_qty FROM dbo.Parts WHERE part_id = 3;            -- 15
GO
-- 13.1 INSERT: списання 2 шт. -> залишок 13
INSERT INTO dbo.WorkOrderParts (order_id, part_id, quantity, price_at_order)
VALUES (4, 3, 2, 250.00);
SELECT part_id, stock_qty FROM dbo.Parts WHERE part_id = 3;                       -- 13
GO
-- 13.2 UPDATE: кількість у наряді збільшено з 2 до 5 -> залишок 10
UPDATE dbo.WorkOrderParts SET quantity = 5 WHERE order_id = 4 AND part_id = 3;
SELECT part_id, stock_qty FROM dbo.Parts WHERE part_id = 3;                       -- 10
GO
-- 13.3 DELETE: позицію вилучено з наряду -> запчастини повернуто, залишок 15
DELETE FROM dbo.WorkOrderParts WHERE order_id = 4 AND part_id = 3;
SELECT part_id, stock_qty FROM dbo.Parts WHERE part_id = 3;                       -- 15
GO
-- 13.4 Спроба списати понад залишок (20 > 15): помилка, операція скасована
INSERT INTO dbo.WorkOrderParts (order_id, part_id, quantity, price_at_order)
VALUES (4, 3, 20, 250.00);
GO
-- Повідомлення: «Недостатньо запчастин на складі…» та
-- «The transaction ended in the trigger. The batch has been aborted.»
-- Залишок не змінився, позиції в наряді немає
SELECT part_id, stock_qty FROM dbo.Parts WHERE part_id = 3;                       -- 15
SELECT COUNT(*) AS RowsInOrder FROM dbo.WorkOrderParts
WHERE order_id = 4 AND part_id = 3;                                               -- 0
