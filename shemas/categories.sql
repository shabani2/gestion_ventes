IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'product_categories' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.product_categories (
        category_id INT IDENTITY PRIMARY KEY,
        code NVARCHAR(10) NOT NULL UNIQUE,
        name NVARCHAR(100) NOT NULL
    );
END;
GO



INSERT INTO oltp.product_categories (code, name)
SELECT v.code, v.name
FROM (VALUES
 ('CER','Céréales'),
 ('HUI','Huiles'),
 ('LAI','Produits laitiers'),
 ('CON','Condiments')
) v(code, name)
WHERE NOT EXISTS (
    SELECT 1 FROM oltp.product_categories c WHERE c.code = v.code
);
GO
