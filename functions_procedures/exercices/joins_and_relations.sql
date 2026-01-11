-- afficher les commandes avec les détails des clients et fournisseurs
SELECT 
    o.order_id,
    c.customer_name,
    f.fournisseur_name,
    o.order_date,
    o.total_amount
FROM oltp.orders o
JOIN oltp.customers c ON o.customer_id = c.customer_id
JOIN oltp.fournisseurs f ON o.fournisseur_id = f.fournisseur_id;

--afficher les nombres de commandes par client
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS Nombre_Commandes   
FROM oltp.customers c
JOIN oltp.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;
--ou
SELECT
    c.customer_id,
    c.full_name AS client,
    COALESCE(COUNT(o.order_id), 0) AS nombre_commandes
FROM oltp.customers c
LEFT JOIN oltp.orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.full_name;

--afficher les nombres de commandes par fournisseur
SELECT 
    f.fournisseur_name,
    COUNT(o.order_id) AS Nombre_Commandes
FROM oltp.fournisseurs f
JOIN oltp.orders o ON f.fournisseur_id = o.fournisseur_id
GROUP BY f.fournisseur_name;

--Afficher les paiements avec les informations de commande
SELECT 
    p.payment_id,
    o.order_id,
    c.full_name,
    p.payment_date,
    p.amount,
    p.payment_method
FROM oltp.payments p
JOIN oltp.orders o ON p.order_id = o.order_id
JOIN oltp.customers c ON o.customer_id = c.customer_id;