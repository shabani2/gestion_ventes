IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'fournisseurs' AND schema_id = SCHEMA_ID('gestion_ventes'))
BEGIN
    CREATE TABLE gestion_ventes.fournisseurs (
        fournisseur_id INT IDENTITY PRIMARY KEY,
        full_name NVARCHAR(150) NOT NULL,
        company_name NVARCHAR(150) NOT NULL,
        phone NVARCHAR(30),
        email NVARCHAR(150),
        city_id INT NOT NULL,
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        status NVARCHAR(20) CHECK (status IN ('ACTIVE','INACTIVE')) DEFAULT 'ACTIVE',
        CONSTRAINT FK_fournisseurs_cities FOREIGN KEY (city_id)
            REFERENCES gestion_ventes.cities(city_id)
    );
END;
GO
