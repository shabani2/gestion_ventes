IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'oltp')
BEGIN
    EXEC('CREATE SCHEMA [oltp]');
END

-- requete pour donner l'authorisation a l'admin 

ALTER AUTHORIZATION ON DATABASE::[gestion_ventes] TO [sa];
GO