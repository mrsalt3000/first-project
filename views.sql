CREATE  OR REPLACE VIEW analysis.users
AS
SELECT
*
FROM production.users;

CREATE  OR REPLACE VIEW analysis.OrderItems
AS
SELECT
*
FROM production.OrderItems;

CREATE  OR REPLACE VIEW analysis.OrderStatuses
AS
SELECT
*
FROM production.OrderStatuses;

CREATE  OR REPLACE VIEW analysis.Products
AS
SELECT
*
FROM production.Products;

CREATE  OR REPLACE VIEW analysis.Orders
AS
SELECT
*
FROM production.Orders;