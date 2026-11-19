-- AutoServiceDB | Step 1: Create the database
-- Run in SSMS against SQL Server. Execute scripts in numeric order.

USE master;
GO
IF DB_ID(N'AutoServiceDB') IS NOT NULL
BEGIN
    ALTER DATABASE AutoServiceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoServiceDB;
END
GO
CREATE DATABASE AutoServiceDB
ON
(
    NAME = 'AutoServiceDB',
    FILENAME = 'D:\AutoServiceDB.mdf',   -- каталог повинен існувати
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = 'AutoServiceDB_log',
    FILENAME = 'D:\AutoServiceDB.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
COLLATE Cyrillic_General_CI_AS;        -- мовний регіон і правила порівняння тексту
GO
EXEC sp_helpdb AutoServiceDB;          -- інформація про створену БД
