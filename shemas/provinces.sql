IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'provinces' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.provinces (
        province_id INT IDENTITY PRIMARY KEY,
        name NVARCHAR(100) NOT NULL UNIQUE
    );
END;
GO


INSERT INTO oltp.provinces (name)
SELECT v.name
FROM (VALUES
 ('Kinshasa'),('Kongo-Central'),('Kwango'),('Kwilu'),('Mai-Ndombe'),
 ('Equateur'),('Mongala'),('Nord-Ubangi'),('Sud-Ubangi'),('Tshuapa'),
 ('Tshopo'),('Bas-Uele'),('Haut-Uele'),('Ituri'),
 ('Nord-Kivu'),('Sud-Kivu'),('Maniema'),
 ('Haut-Lomami'),('Haut-Katanga'),('Lualaba'),
 ('Kasai'),('Kasai-Central'),('Kasai-Oriental'),
 ('Lomami'),('Sankuru'),('Tanganyika')
) v(name)
WHERE NOT EXISTS (
    SELECT 1 FROM oltp.provinces p WHERE p.name = v.name
);
GO

