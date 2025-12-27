IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'cities' AND schema_id = SCHEMA_ID('gestion_ventes'))
BEGIN
    CREATE TABLE gestion_ventes.cities (
        city_id INT IDENTITY PRIMARY KEY,
        province_id INT NOT NULL,
        name NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_cities_provinces FOREIGN KEY (province_id)
            REFERENCES gestion_ventes.provinces(province_id),
        CONSTRAINT UQ_city UNIQUE (province_id, name)
    );
END;
GO


INSERT INTO gestion_ventes.cities (province_id, name)
SELECT p.province_id, v.city
FROM (VALUES
    -- Kinshasa (ville-province)
    ('Kinshasa','Kinshasa'),

    -- Kongo-Central
    ('Kongo-Central','Matadi'),
    ('Kongo-Central','Boma'),
    ('Kongo-Central','Muanda'),

    -- Kwango
    ('Kwango','Kenge'),
    ('Kwango','Kasongo-Lunda'),

    -- Kwilu
    ('Kwilu','Kikwit'),
    ('Kwilu','Bandundu'),

    -- Mai-Ndombe
    ('Mai-Ndombe','Inongo'),
    ('Mai-Ndombe','Nioki'),

    -- Équateur
    ('Equateur','Mbandaka'),
    ('Equateur','Bikoro'),

    -- Mongala
    ('Mongala','Lisala'),
    ('Mongala','Bumba'),

    -- Nord-Ubangi
    ('Nord-Ubangi','Gbadolite'),
    ('Nord-Ubangi','Yakoma'),

    -- Sud-Ubangi
    ('Sud-Ubangi','Gemena'),
    ('Sud-Ubangi','Libenge'),

    -- Tshuapa
    ('Tshuapa','Boende'),
    ('Tshuapa','Ikela'),

    -- Tshopo
    ('Tshopo','Kisangani'),
    ('Tshopo','Banalia'),

    -- Bas-Uele
    ('Bas-Uele','Buta'),
    ('Bas-Uele','Aketi'),

    -- Haut-Uele
    ('Haut-Uele','Isiro'),
    ('Haut-Uele','Watsa'),

    -- Ituri
    ('Ituri','Bunia'),
    ('Ituri','Mahagi'),

    -- Nord-Kivu
    ('Nord-Kivu','Goma'),
    ('Nord-Kivu','Butembo'),

    -- Sud-Kivu
    ('Sud-Kivu','Bukavu'),
    ('Sud-Kivu','Uvira'),

    -- Maniema
    ('Maniema','Kindu'),
    ('Maniema','Kibombo'),

    -- Haut-Lomami
    ('Haut-Lomami','Kamina'),
    ('Haut-Lomami','Bukama'),

    -- Haut-Katanga
    ('Haut-Katanga','Lubumbashi'),
    ('Haut-Katanga','Likasi'),

    -- Lualaba
    ('Lualaba','Kolwezi'),
    ('Lualaba','Dilolo'),

    -- Kasaï
    ('Kasai','Tshikapa'),
    ('Kasai','Luebo'),

    -- Kasaï-Central
    ('Kasai-Central','Kananga'),
    ('Kasai-Central','Demba'),

    -- Kasaï-Oriental
    ('Kasai-Oriental','Mbuji-Mayi'),
    ('Kasai-Oriental','Kabinda'),

    -- Lomami
    ('Lomami','Kabinda'),
    ('Lomami','Mwene-Ditu'),

    -- Sankuru
    ('Sankuru','Lodja'),
    ('Sankuru','Lusambo'),

    -- Tanganyika
    ('Tanganyika','Kalemie'),
    ('Tanganyika','Nyunzu')
) v(province, city)
JOIN gestion_ventes.provinces p 
    ON p.name = v.province
WHERE NOT EXISTS (
    SELECT 1
    FROM gestion_ventes.cities c
    WHERE c.province_id = p.province_id
      AND c.name = v.city
);
GO
