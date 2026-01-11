-- ======================================================================================
-- SCRIPT DE CRÉATION DE LA BASE DE DONNÉES AGRICOLE (DDL)
-- Description : Création de toutes les tables dans l'ordre de dépendance.
-- Schéma cible : oltp
-- ======================================================================================

-- 1. CRÉATION DU SCHÉMA (Optionnel, au cas où il n'existe pas)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'oltp')
BEGIN
    EXEC('CREATE SCHEMA [oltp]')
END
GO

-- 2. TABLES GÉOGRAPHIQUES (Doivent être créées en premier)

-- Table : provinces
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'provinces' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.provinces (
        province_id INT IDENTITY PRIMARY KEY,
        name NVARCHAR(100) NOT NULL UNIQUE
    );
END;
GO

-- Table : cities (Dépend de provinces)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'cities' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.cities (
        city_id INT IDENTITY PRIMARY KEY,
        province_id INT NOT NULL,
        name NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_cities_provinces FOREIGN KEY (province_id)
            REFERENCES oltp.provinces(province_id),
        CONSTRAINT UQ_city UNIQUE (province_id, name)
    );
END;
GO

-- 3. TABLES DE RÉFÉRENCE PRODUITS

-- Table : product_categories
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'product_categories' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.product_categories (
        category_id INT IDENTITY PRIMARY KEY,
        code NVARCHAR(10) NOT NULL UNIQUE,
        name NVARCHAR(100) NOT NULL
    );
END;
GO

-- Table : products (Dépend de product_categories)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'products' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.products (
        product_id INT IDENTITY PRIMARY KEY,
        category_id INT NOT NULL,
        name NVARCHAR(150) NOT NULL,
        unit NVARCHAR(50) NOT NULL,
        is_active BIT DEFAULT 1,
        CONSTRAINT FK_products_categories FOREIGN KEY (category_id)
            REFERENCES oltp.product_categories(category_id)
    );
END;
GO

-- 4. ACTEURS (CLIENTS ET FOURNISSEURS)

-- Table : customers (Dépend de cities)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'customers' AND schema_id = SCHEMA_ID('oltp'))
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

-- Table : fournisseurs (Dépend de cities)
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

-- 5. TRANSACTIONS (COMMANDES ET PAIEMENTS)

-- Table : orders (Dépend de customers et fournisseurs)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'orders' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.orders (
        order_id INT IDENTITY PRIMARY KEY,
        customer_id INT NOT NULL,
        fournisseur_id INT NOT NULL,
        order_date DATE NOT NULL,
        order_status NVARCHAR(20)
            CHECK (order_status IN ('NEW','CONFIRMED','DELIVERED','CANCELLED')),
        total_amount DECIMAL(14,2),

        CONSTRAINT FK_orders_customers
            FOREIGN KEY (customer_id)
            REFERENCES oltp.customers(customer_id),

        CONSTRAINT FK_orders_fournisseurs
            FOREIGN KEY (fournisseur_id)
            REFERENCES oltp.fournisseurs(fournisseur_id)
    );
END;
GO

-- Table : order_items (Dépend de orders et products)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'order_items' AND schema_id = SCHEMA_ID('oltp'))
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

-- Table : payments (Dépend de orders)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'payments' AND schema_id = SCHEMA_ID('oltp'))
BEGIN
    CREATE TABLE oltp.payments (
        payment_id INT IDENTITY PRIMARY KEY,
        order_id INT NOT NULL,
        payment_date DATE NOT NULL,
        amount DECIMAL(14,2) NOT NULL,
        payment_method NVARCHAR(30) CHECK (payment_method IN ('CASH','MOBILE_MONEY','BANK_TRANSFER')),
        payment_status NVARCHAR(20) CHECK (payment_status IN ('PENDING','PAID','FAILED')),
        CONSTRAINT FK_payments_orders FOREIGN KEY (order_id)
            REFERENCES oltp.orders(order_id)
    );
END;
GO