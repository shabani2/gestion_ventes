IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'orders'
      AND schema_id = SCHEMA_ID('oltp')
)
BEGIN
    CREATE TABLE oltp.orders (
        order_id INT IDENTITY PRIMARY KEY,
        customer_id INT NOT NULL,
        fournisseur_id INT NOT NULL,
        order_date DATE NOT NULL,
        order_status NVARCHAR(20)
            CHECK (order_status IN ('NEW','CONFIRMED','DELIVERED','CANCELLED')),
        total_amount DECIMAL(14,2),

        CONSTRAINT FK_orders_customers
            FOREIGN KEY (customer_id)
            REFERENCES oltp.customers(customer_id),

        CONSTRAINT FK_orders_fournisseurs
            FOREIGN KEY (fournisseur_id)
            REFERENCES oltp.fournisseurs(fournisseur_id)
    );
END;
GO


-- insertion de commandes

SET NOCOUNT ON;

DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate   DATE = '2024-12-31';
DECLARE @DaysRange INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;

;WITH Numbers AS (
    SELECT TOP (5000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO oltp.orders
(
    customer_id,
    fournisseur_id,
    order_date,
    order_status,
    total_amount
)
SELECT
    c.customer_id,
    f.fournisseur_id,
    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % @DaysRange,
        @StartDate
    ),
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'NEW'
        WHEN 1 THEN 'CONFIRMED'
        WHEN 2 THEN 'DELIVERED'
        ELSE 'CANCELLED'
    END,
    0 -- sera recalculé après insertion des lignes
FROM Numbers n
CROSS APPLY (
    SELECT TOP 1 customer_id
    FROM oltp.customers
    ORDER BY NEWID()
) c
CROSS APPLY (
    SELECT TOP 1 fournisseur_id
    FROM oltp.fournisseurs
    ORDER BY NEWID()
) f;
GO

