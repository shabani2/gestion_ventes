IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'fournisseurs' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.fournisseurs (
        fournisseur_id INT IDENTITY PRIMARY KEY,
        full_name NVARCHAR(150) NOT NULL,
        company_name NVARCHAR(150) NOT NULL,
        phone NVARCHAR(30),
        email NVARCHAR(150),
        city_id INT NOT NULL,
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        status NVARCHAR(20) CHECK (status IN ('ACTIVE','INACTIVE')) DEFAULT 'ACTIVE',
        CONSTRAINT FK_fournisseurs_cities FOREIGN KEY (city_id)
            REFERENCES oltp.cities(city_id)
    );
END;
GO


INSERT INTO oltp.fournisseurs
(full_name, company_name, phone, email, city_id)
SELECT
    v.full_name,
    v.company_name,
    v.phone,
    v.email,
    c.city_id
FROM (VALUES
    -- Kinshasa
    ('Jean Mukendi',      'Mukendi Distribution',     '+243810000001', 'contact@mukendi.cd',      'Kinshasa'),
    ('Paul Tshibangu',    'Tshibangu & Fils',          '+243810000002', 'info@tshibangu.cd',       'Kinshasa'),
    ('Alain Nzambe',      'Nzambe Trading',            '+243810000003', 'sales@nzambe.cd',         'Kinshasa'),

    -- Kongo-Central
    ('Joseph Lukusa',     'Lukusa Commerce',           '+243820000004', 'contact@lukusa.cd',       'Matadi'),
    ('Daniel Mavungu',    'Mavungu Distribution',      '+243820000005', 'info@mavungu.cd',         'Boma'),

    -- Kwilu
    ('Patrick Mbuyi',     'Mbuyi Agro',                '+243830000006', 'contact@mbuyi.cd',        'Kikwit'),

    -- Mai-Ndombe
    ('Claude Inongo',     'Inongo Services',            '+243840000007', 'info@inongo.cd',          'Inongo'),

    -- Équateur
    ('Samuel Bomanga',    'Bomanga Négoce',            '+243850000008', 'sales@bomanga.cd',        'Mbandaka'),

    -- Mongala
    ('Alex Bumba',        'Bumba Trading',             '+243860000009', 'contact@bumba.cd',        'Bumba'),

    -- Nord-Ubangi
    ('André Gbadolite',   'Gbadolite Commerce',        '+243870000010', 'info@gbadolite.cd',       'Gbadolite'),

    -- Sud-Ubangi
    ('Michel Gemena',     'Gemena Distribution',       '+243880000011', 'contact@gemena.cd',       'Gemena'),

    -- Tshopo
    ('Pascal Kisangani',  'Kisangani Négoce',          '+243890000012', 'sales@kisangani.cd',      'Kisangani'),

    -- Ituri
    ('David Bunia',       'Bunia Trading',             '+243900000013', 'info@bunia.cd',           'Bunia'),

    -- Nord-Kivu
    ('Eric Goma',         'Goma Food Supply',          '+243910000014', 'contact@gomafood.cd',     'Goma'),
    ('Julien Butembo',    'Butembo Distribution',      '+243910000015', 'info@butembo.cd',         'Butembo'),

    -- Sud-Kivu
    ('Laurent Bukavu',    'Bukavu Négoce',             '+243920000016', 'sales@bukavu.cd',         'Bukavu'),

    -- Haut-Katanga
    ('Patrick Lubumba',   'Lubumba Trading',           '+243930000017', 'contact@lubumba.cd',      'Lubumbashi'),
    ('Chris Likasi',      'Likasi Distribution',       '+243930000018', 'info@likasi.cd',          'Likasi'),

    -- Lualaba
    ('Moïse Kolwezi',     'Kolwezi Commerce',          '+243940000019', 'contact@kolwezi.cd',      'Kolwezi'),

    -- Tanganyika
    ('Jonas Kalemie',     'Kalemie Trading',           '+243950000020', 'info@kalemie.cd',         'Kalemie')

) v(full_name, company_name, phone, email, city_name)
JOIN oltp.cities c
    ON c.name = v.city_name
WHERE NOT EXISTS (
    SELECT 1
    FROM oltp.fournisseurs f
    WHERE f.company_name = v.company_name
);
GO





INSERT INTO oltp.fournisseurs
(full_name, company_name, phone, email, city_id)
SELECT
    v.full_name,
    v.company_name,
    v.phone,
    v.email,
    c.city_id
FROM (VALUES
    -- Kinshasa
    ('Jean Mukendi',      'Mukendi Distribution',     '+243810000001', 'contact@mukendi.cd',      'Kinshasa'),
    ('Paul Tshibangu',    'Tshibangu & Fils',          '+243810000002', 'info@tshibangu.cd',       'Kinshasa'),
    ('Alain Nzambe',      'Nzambe Trading',            '+243810000003', 'sales@nzambe.cd',         'Kinshasa'),

    -- Kongo-Central
    ('Joseph Lukusa',     'Lukusa Commerce',           '+243820000004', 'contact@lukusa.cd',       'Matadi'),
    ('Daniel Mavungu',    'Mavungu Distribution',      '+243820000005', 'info@mavungu.cd',         'Boma'),

    -- Kwilu
    ('Patrick Mbuyi',     'Mbuyi Agro',                '+243830000006', 'contact@mbuyi.cd',        'Kikwit'),

    -- Mai-Ndombe
    ('Claude Inongo',     'Inongo Services',            '+243840000007', 'info@inongo.cd',          'Inongo'),

    -- Équateur
    ('Samuel Bomanga',    'Bomanga Négoce',            '+243850000008', 'sales@bomanga.cd',        'Mbandaka'),

    -- Mongala
    ('Alex Bumba',        'Bumba Trading',             '+243860000009', 'contact@bumba.cd',        'Bumba'),

    -- Nord-Ubangi
    ('André Gbadolite',   'Gbadolite Commerce',        '+243870000010', 'info@gbadolite.cd',       'Gbadolite'),

    -- Sud-Ubangi
    ('Michel Gemena',     'Gemena Distribution',       '+243880000011', 'contact@gemena.cd',       'Gemena'),

    -- Tshopo
    ('Pascal Kisangani',  'Kisangani Négoce',          '+243890000012', 'sales@kisangani.cd',      'Kisangani'),

    -- Ituri
    ('David Bunia',       'Bunia Trading',             '+243900000013', 'info@bunia.cd',           'Bunia'),

    -- Nord-Kivu
    ('Eric Goma',         'Goma Food Supply',          '+243910000014', 'contact@gomafood.cd',     'Goma'),
    ('Julien Butembo',    'Butembo Distribution',      '+243910000015', 'info@butembo.cd',         'Butembo'),

    -- Sud-Kivu
    ('Laurent Bukavu',    'Bukavu Négoce',             '+243920000016', 'sales@bukavu.cd',         'Bukavu'),

    -- Haut-Katanga
    ('Patrick Lubumba',   'Lubumba Trading',           '+243930000017', 'contact@lubumba.cd',      'Lubumbashi'),
    ('Chris Likasi',      'Likasi Distribution',       '+243930000018', 'info@likasi.cd',          'Likasi'),

    -- Lualaba
    ('Moïse Kolwezi',     'Kolwezi Commerce',          '+243940000019', 'contact@kolwezi.cd',      'Kolwezi'),

    -- Tanganyika
    ('Jonas Kalemie',     'Kalemie Trading',           '+243950000020', 'info@kalemie.cd',         'Kalemie')

) v(full_name, company_name, phone, email, city_name)
JOIN oltp.cities c
    ON c.name = v.city_name
WHERE NOT EXISTS (
    SELECT 1
    FROM oltp.fournisseurs f
    WHERE f.company_name = v.company_name
);
GO


