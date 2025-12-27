IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'orders' AND schema_id = SCHEMA_ID('gestion_ventes'))
BEGIN
    CREATE TABLE gestion_ventes.orders (
        order_id INT IDENTITY PRIMARY KEY,
        customer_id INT NOT NULL,
        fournisseur_id INT NOT NULL,
        order_date DATE NOT NULL,
        order_status NVARCHAR(20) CHECK (order_status IN ('NEW','CONFIRMED','DELIVERED','CANCELLED')),
        total_amount DECIMAL(14,2),
        CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id)
            REFERENCES gestion_ventes.customers(customer_id),
        CONSTRAINT FK_orders_fournisseurs FOREIGN KEY (fournisseur_id)
            REFERENCES gestion_ventes.fournisseurs(fournisseur_id)
    );
END;
GO
