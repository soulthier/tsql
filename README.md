# AutoServiceDB — relational database for a car service (T-SQL / SQL Server)

University project (Organization of Databases and Knowledge course, Igor Sikorsky Kyiv Polytechnic Institute, 2026).
A relational database for a car repair shop, implemented in **Microsoft SQL Server** with **T-SQL** and managed in **SSMS**.
The physical model was first designed for PostgreSQL 16 in a separate design project and then ported to T-SQL.

## What is inside

- **10 tables:** Clients, Vehicles, Employees, Services, Parts, Appointments, WorkOrders, WorkOrderServices, WorkOrderParts, Payments
- **Integrity:** primary, unique and foreign keys, `ON DELETE NO ACTION` / `CASCADE` where appropriate, DEFAULT and CHECK constraints (phone and e-mail format, VIN length, status lists, non-negative prices and stock, date ordering)
- **Indexes:** clustered and nonclustered, covering index with `INCLUDE`, unique filtered index (business rule: one `InProgress` work order per mechanic), unique indexes with `IGNORE_DUP_KEY = ON/OFF`
- **View:** `vw_VehicleOwners`, altered to add `WITH SCHEMABINDING`, then altered again and checked after updating base tables
- **DML trigger:** `trg_WorkOrderParts_Stock` handles INSERT, UPDATE and DELETE, keeps `Parts.stock_qty` in sync and rolls back if stock would go negative
- **Tests:** integrity violations wrapped in `TRY...CATCH`, trigger scenarios with expected results in comments

## ER diagram

![ER diagram](docs/er_diagram.png)

## How to run

1. Open SQL Server Management Studio.
2. In `scripts/01_create_database.sql` change the `FILENAME` paths (`D:\...`) to a folder that exists on your machine.
3. Run the scripts in numeric order, `01` to `13` (select a block and press F5). The seed data script (`05`) must be run on a freshly created database because IDs are generated automatically.

| Script | Content |
|---|---|
| `01_create_database.sql` | database with explicit data/log files and Cyrillic collation |
| `02_create_tables.sql` | tables, types, IDENTITY, defaults |
| `03_keys_and_relationships.sql` | PK, UNIQUE, FK |
| `04_check_constraints.sql` | CHECK constraints |
| `05_seed_data.sql` | consistent test data |
| `06_integrity_tests.sql` | constraint tests, cascade delete in a rolled-back transaction |
| `07_clustered_and_nonclustered_indexes.sql` | heap, clustered and nonclustered indexes, execution plans |
| `08_covering_and_filtered_indexes.sql` | covering index, unique filtered index |
| `09_unique_and_ignore_dup_key.sql` | drop/recreate as UNIQUE, `IGNORE_DUP_KEY` |
| `10_create_view.sql` | view |
| `11_view_schemabinding.sql` | `WITH SCHEMABINDING` and schema-protection checks |
| `12_view_alter_and_update.sql` | changed view query, updates of base tables |
| `13_dml_trigger.sql` | stock-control trigger and its tests |

Screenshots of results (query outputs, execution plans, error messages) are in `docs/screenshots/`.

## Skills demonstrated

T-SQL (DDL, DML, TRY...CATCH, transactions), database design and normalization, data integrity, indexing strategy and execution plans, views, triggers, SSMS.

## Notes

- Comments in the scripts are in Ukrainian (university submission language).
- The project was tested in SSMS on SQL Server.
