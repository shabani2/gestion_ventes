IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'payments' AND schema_id = SCHEMA_ID('gestion_ventes'))
BEGIN
    CREATE TABLE gestion_ventes.payments (
        payment_id INT IDENTITY PRIMARY KEY,
        order_id INT NOT NULL,
        payment_date DATE NOT NULL,
        amount DECIMAL(14,2) NOT NULL,
        payment_method NVARCHAR(30) CHECK (payment_method IN ('CASH','MOBILE_MONEY','BANK_TRANSFER')),
        payment_status NVARCHAR(20) CHECK (payment_status IN ('PENDING','PAID','FAILED')),
        CONSTRAINT FK_payments_orders FOREIGN KEY (order_id)
            REFERENCES gestion_ventes.orders(order_id)
    );
END;
GO
