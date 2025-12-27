IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'gestion_ventes')
BEGIN
    EXEC('CREATE SCHEMA [gestion_ventes]');
END