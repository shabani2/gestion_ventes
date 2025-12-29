IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'fournisseurs' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.customers (
        customer_id INT IDENTITY PRIMARY KEY,
        full_name NVARCHAR(150) NOT NULL,        
        phone NVARCHAR(30),
        email NVARCHAR(150),
        city_id INT NOT NULL,
        created_at DATETIME2 DEFAULT SYSDATETIME(),
        status NVARCHAR(20) CHECK (status IN ('ACTIVE','INACTIVE')) DEFAULT 'ACTIVE',
        CONSTRAINT FK_custormes_cities FOREIGN KEY (city_id)
            REFERENCES oltp.cities(city_id)
    );
END;
GO



INSERT INTO oltp.customers
(full_name, phone, email, city_id)
SELECT
    v.full_name,
    v.phone,
    v.email,
    c.city_id
FROM (VALUES
    -- Kinshasa (10)
    ('Boutique Nzambe',        '+243810100001', 'contact@nzambe-shop.cd',   'Kinshasa'),
    ('Boutique Lumumba',       '+243810100002', 'info@lumumba.cd',          'Kinshasa'),
    ('Marché Central Plus',    '+243810100003', 'sales@marchecentral.cd',   'Kinshasa'),
    ('Supermarché Kinois',     '+243810100004', 'contact@kinois.cd',        'Kinshasa'),
    ('Boutique Matonge',       '+243810100005', 'info@matonge.cd',          'Kinshasa'),
    ('Boutique Bandal',        '+243810100006', 'contact@bandal.cd',        'Kinshasa'),
    ('Boutique Limete',        '+243810100007', 'info@limete.cd',           'Kinshasa'),
    ('Boutique Ngaba',         '+243810100008', 'contact@ngaba.cd',         'Kinshasa'),
    ('Boutique Selembao',      '+243810100009', 'info@selembao.cd',         'Kinshasa'),
    ('Grossiste Kin Marché',   '+243810100010', 'sales@kinmarche.cd',       'Kinshasa'),

    -- Kongo-Central (6)
    ('Boutique Matadi Nord',   '+243820100011', 'contact@matadinord.cd',    'Matadi'),
    ('Grossiste Boma',         '+243820100012', 'info@boma-grossiste.cd',   'Boma'),
    ('Boutique Muanda',        '+243820100013', 'contact@muanda.cd',        'Muanda'),
    ('Marché Central Matadi',  '+243820100014', 'sales@marchematadi.cd',    'Matadi'),
    ('Boutique Kimpese',       '+243820100015', 'info@kimpese.cd',          'Matadi'),
    ('Boutique Lukala',        '+243820100016', 'contact@lukala.cd',        'Boma'),

    -- Kwilu (4)
    ('Boutique Kikwit Centre', '+243830100017', 'contact@kikwit.cd',        'Kikwit'),
    ('Marché Bandundu',        '+243830100018', 'sales@bandundu.cd',        'Bandundu'),
    ('Boutique Masimanimba',   '+243830100019', 'info@masimanimba.cd',      'Kikwit'),
    ('Grossiste Kwilu',        '+243830100020', 'contact@kwilu.cd',         'Bandundu'),

    -- Équateur (4)
    ('Boutique Mbandaka',      '+243850100021', 'contact@mbandaka.cd',      'Mbandaka'),
    ('Grossiste Équateur',     '+243850100022', 'sales@equateur.cd',        'Mbandaka'),
    ('Boutique Bikoro',        '+243850100023', 'info@bikoro.cd',           'Bikoro'),
    ('Marché Central Équa',    '+243850100024', 'contact@marcheequa.cd',    'Mbandaka'),

    -- Nord-Kivu (6)
    ('Boutique Goma Centre',   '+243910100025', 'contact@goma.cd',          'Goma'),
    ('Grossiste Goma',         '+243910100026', 'sales@goma-grossiste.cd',  'Goma'),
    ('Boutique Butembo',       '+243910100027', 'info@butembo.cd',          'Butembo'),
    ('Marché Virunga',         '+243910100028', 'contact@virunga.cd',       'Goma'),
    ('Boutique Katindo',       '+243910100029', 'info@katindo.cd',          'Goma'),
    ('Grossiste Nord-Kivu',    '+243910100030', 'sales@nordkivu.cd',        'Butembo'),

    -- Sud-Kivu (4)
    ('Boutique Bukavu',        '+243920100031', 'contact@bukavu.cd',        'Bukavu'),
    ('Grossiste Sud-Kivu',     '+243920100032', 'sales@sudkivu.cd',         'Bukavu'),
    ('Boutique Uvira',         '+243920100033', 'info@uvira.cd',            'Uvira'),
    ('Marché Kadutu',          '+243920100034', 'contact@kadutu.cd',        'Bukavu'),

    -- Haut-Katanga (6)
    ('Boutique Lubumbashi',    '+243930100035', 'contact@lubumbashi.cd',    'Lubumbashi'),
    ('Supermarché Katuba',     '+243930100036', 'sales@katuba.cd',          'Lubumbashi'),
    ('Boutique Kenya',         '+243930100037', 'info@kenya.cd',            'Lubumbashi'),
    ('Grossiste Likasi',       '+243930100038', 'contact@likasi.cd',        'Likasi'),
    ('Boutique Panda',         '+243930100039', 'info@panda.cd',            'Likasi'),
    ('Marché Central Lushi',   '+243930100040', 'sales@lushi.cd',           'Lubumbashi'),

    -- Lualaba (4)
    ('Boutique Kolwezi',       '+243940100041', 'contact@kolwezi.cd',       'Kolwezi'),
    ('Grossiste Lualaba',      '+243940100042', 'sales@lualaba.cd',         'Kolwezi'),
    ('Boutique Dilolo',        '+243940100043', 'info@dilolo.cd',           'Dilolo'),
    ('Marché Musompo',         '+243940100044', 'contact@musompo.cd',       'Kolwezi'),

    -- Tshopo (4)
    ('Boutique Kisangani',     '+243890100045', 'contact@kisangani.cd',     'Kisangani'),
    ('Grossiste Tshopo',       '+243890100046', 'sales@tshopo.cd',          'Kisangani'),
    ('Boutique Banalia',       '+243890100047', 'info@banalia.cd',          'Banalia'),
    ('Marché Mangobo',         '+243890100048', 'contact@mangobo.cd',       'Kisangani'),

    -- Tanganyika (4)
    ('Boutique Kalemie',       '+243950100049', 'contact@kalemie.cd',       'Kalemie'),
    ('Grossiste Tanganyika',   '+243950100050', 'sales@tanganyika.cd',     'Kalemie'),
    ('Boutique Nyunzu',        '+243950100051', 'info@nyunzu.cd',           'Nyunzu'),
    ('Marché Lukuga',          '+243950100052', 'contact@lukuga.cd',        'Kalemie'),

    -- Complément (8) – autres provinces/villes
    ('Boutique Inongo',        '+243840100053', 'contact@inongo.cd',        'Inongo'),
    ('Grossiste Mai-Ndombe',   '+243840100054', 'sales@maindombe.cd',       'Inongo'),
    ('Boutique Boende',        '+243860100055', 'contact@boende.cd',        'Boende'),
    ('Boutique Isiro',         '+243870100056', 'info@isiro.cd',            'Isiro'),
    ('Grossiste Bunia',        '+243900100057', 'sales@bunia.cd',           'Bunia'),
    ('Boutique Lodja',         '+243880100058', 'contact@lodja.cd',         'Lodja'),
    ('Boutique Kananga',       '+243830100059', 'info@kananga.cd',          'Kananga'),
    ('Grossiste Kasaï',        '+243830100060', 'sales@kasai.cd',           'Tshikapa')

) v(full_name, phone, email, city_name)
JOIN oltp.cities c
    ON c.name = v.city_name
WHERE NOT EXISTS (
    SELECT 1
    FROM oltp.customers cu
    WHERE cu.full_name = v.full_name
);
GO

