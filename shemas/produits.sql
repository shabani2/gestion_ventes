IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'products' AND schema_id = SCHEMA_ID('gestion_ventes'))
BEGIN
    CREATE TABLE gestion_ventes.products (
        product_id INT IDENTITY PRIMARY KEY,
        category_id INT NOT NULL,
        name NVARCHAR(150) NOT NULL,
        unit NVARCHAR(50) NOT NULL,
        is_active BIT DEFAULT 1,
        CONSTRAINT FK_products_categories FOREIGN KEY (category_id)
            REFERENCES gestion_ventes.product_categories(category_id)
    );
END;
GO



INSERT INTO gestion_ventes.products (category_id, name, unit)
SELECT c.category_id, v.name, v.unit
FROM (VALUES
    -- CÉRÉALES (CER)
    ('CER','Riz blanc','Sac 25kg'),
    ('CER','Riz local','Sac 25kg'),
    ('CER','Farine de maïs blanche','Sac 25kg'),
    ('CER','Farine de maïs jaune','Sac 25kg'),
    ('CER','Farine de manioc','Sac 25kg'),

    -- HUILES (HUI)
    ('HUI','Huile végétale raffinée','Bidon 20L'),
    ('HUI','Huile de palme rouge','Bidon 20L'),
    ('HUI','Huile végétale raffinée','Bidon 5L'),
    ('HUI','Huile de soja','Bidon 20L'),

    -- PRODUITS LAITIERS (LAI)
    ('LAI','Lait en poudre entier','Boîte 1kg'),
    ('LAI','Lait en poudre demi-écrémé','Boîte 1kg'),
    ('LAI','Lait concentré sucré','Boîte 400g'),

    -- CONDIMENTS (CON)
    ('CON','Sucre blanc','Sac 50kg'),
    ('CON','Sucre brun','Sac 50kg'),
    ('CON','Sel iodé fin','Sac 25kg'),
    ('CON','Sel iodé gros','Sac 25kg'),
    ('CON','Bouillon alimentaire','Carton 100 cubes')

) v(code, name, unit)
JOIN gestion_ventes.product_categories c 
    ON c.code = v.code
WHERE NOT EXISTS (
    SELECT 1
    FROM gestion_ventes.products p
    WHERE p.name = v.name
);
GO

