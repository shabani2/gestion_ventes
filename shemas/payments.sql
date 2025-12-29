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





SET NOCOUNT ON;

INSERT INTO oltp.payments
(
    order_id,
    payment_date,
    amount,
    payment_method,
    payment_status
)
SELECT
    o.order_id,

    -- Date de paiement : 0 à 15 jours après la commande
    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % 16,
        o.order_date
    ) AS payment_date,

    -- Montant payé = total de la commande
    o.total_amount AS amount,

    -- Méthode de paiement (répartition réaliste RDC)
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'CASH'
        WHEN 1 THEN 'MOBILE_MONEY'
        ELSE 'BANK_TRANSFER'
    END AS payment_method,

    -- Statut du paiement
    CASE 
        WHEN r.rnd < 70 THEN 'PAID'
        WHEN r.rnd < 90 THEN 'PENDING'
        ELSE 'FAILED'
    END AS payment_status

FROM oltp.orders o
CROSS APPLY (
    SELECT ABS(CHECKSUM(NEWID())) % 100 AS rnd
) r
WHERE NOT EXISTS (
    SELECT 1
    FROM oltp.payments p
    WHERE p.order_id = o.order_id
);
GO
