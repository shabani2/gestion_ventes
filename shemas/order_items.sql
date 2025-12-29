IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'order_items'
      AND schema_id = SCHEMA_ID('oltp')
)
BEGIN
    CREATE TABLE oltp.order_items (
        order_item_id INT IDENTITY PRIMARY KEY,
        order_id INT NOT NULL,
        product_id INT NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price > 0),

        CONSTRAINT FK_order_items_orders
            FOREIGN KEY (order_id)
            REFERENCES oltp.orders(order_id),

        CONSTRAINT FK_order_items_products
            FOREIGN KEY (product_id)
            REFERENCES oltp.products(product_id),

        -- Empêche le même produit deux fois dans la même commande
        CONSTRAINT UQ_order_product UNIQUE (order_id, product_id)
    );
END;
GO


-- insertion de contenu des commandes

SET NOCOUNT ON;

INSERT INTO oltp.order_items
(
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    ABS(CHECKSUM(NEWID())) % 10 + 1 AS quantity,   -- 1 à 10
    CAST(
        (ABS(CHECKSUM(NEWID())) % 45000 + 5000) AS DECIMAL(12,2)
    ) AS unit_price
FROM oltp.orders o
CROSS APPLY (
    -- 2 à 6 produits différents par commande
    SELECT TOP (ABS(CHECKSUM(NEWID())) % 5 + 2) product_id
    FROM oltp.products
    ORDER BY NEWID()
) p;
GO

