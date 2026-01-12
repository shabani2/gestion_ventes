-- 1. afficher les commandes avec les détails des clients et fournisseurs
SELECT 
    o.order_id,
    c.customer_name,
    f.fournisseur_name,
    o.order_date,
    o.total_amount
FROM oltp.orders o
JOIN oltp.customers c ON o.customer_id = c.customer_id
JOIN oltp.fournisseurs f ON o.fournisseur_id = f.fournisseur_id;

--2. afficher les nombres de commandes par client
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

--3. afficher les nombres de commandes par fournisseur
SELECT 
    f.fournisseur_name,
    COUNT(o.order_id) AS Nombre_Commandes
FROM oltp.fournisseurs f
JOIN oltp.orders o ON f.fournisseur_id = o.fournisseur_id
GROUP BY f.fournisseur_name;

--4. Afficher les paiements avec les informations de commande
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

--5. afficher les produits commandes pour chaque commande
SELECT 
    o.order_id,
    p.name as product_name,
    oi.quantity,
    oi.unit_price
FROM oltp.orders o
JOIN oltp.order_items oi ON o.order_id = oi.order_id
JOIN oltp.products p ON oi.product_id = p.product_id
ORDER BY o.order_id;





--6. Trouver les clients n’ayant jamais passé de commande
SELECT 
    c.customer_id,
    c.full_name as client
FROM oltp.customers c
LEFT JOIN oltp.orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;


--7. Lister les commandes sans paiement
SELECT 
    o.order_id,
    c.full_name as client,
    o.order_date,
    o.total_amount
FROM oltp.orders o
LEFT JOIN oltp.payments p ON o.order_id = p.order_id
JOIN oltp.customers c ON o.customer_id = c.customer_id
WHERE p.payment_id IS NULL;


--8. Afficher les commandes avec plusieurs produits
SELECT 
    o.order_id,
    c.full_name as client,
    COUNT(oi.product_id) AS nombre_produits
FROM oltp.orders o
JOIN oltp.order_items oi ON o.order_id = oi.order_id
JOIN oltp.customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, c.full_name
HAVING COUNT(oi.product_id) > 1;    

--9. Trouver les produits jamais commandés
SELECT 
    p.product_id,
    p.name as product_name
FROM oltp.products p
LEFT JOIN oltp.order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

--10. Trouver les villes sans clients
select
ct.name,count(c.customer_id) as nbre_client 
from oltp.cities  ct 
left join oltp.customers c
on ct.city_id = c.city_id
group by ct.name having count(c.customer_id) < 1;

--11. Lister les fournisseurs sans commandes
select
f.fournisseur_id,
f.full_name
from oltp.fournisseurs f
left join oltp.orders o
on f.fournisseur_id = o.fournisseur_id
where o.order_id is null;
GO;


--12. Trouver les provinces sans fournisseurs

--13. lister les provinces ayant plus de 2 fournisseurs
SELECT DISTINCT
    p.province_id,
    p.name
FROM oltp.provinces p
LEFT JOIN oltp.cities c
    ON p.province_id = c.province_id
JOIN oltp.fournisseurs f
    ON c.city_id = f.city_id
GROUP BY
    p.province_id,
    p.name,
    c.city_id
HAVING
    COUNT(f.fournisseur_id) > 2;

-- ou 
SELECT
    p.province_id,
    p.name AS province_name,
    COUNT(f.fournisseur_id) AS nombre_fournisseurs
FROM oltp.provinces p
JOIN oltp.cities c
    ON c.province_id = p.province_id
JOIN oltp.fournisseurs f
    ON f.city_id = c.city_id
GROUP BY
    p.province_id,
    p.name
HAVING
    COUNT(f.fournisseur_id) > 2;

--ou 
SELECT
    p.province_id,
    p.name
FROM oltp.provinces p
WHERE EXISTS (
    SELECT 1
    FROM oltp.cities c
    JOIN oltp.fournisseurs f
        ON c.city_id = f.city_id
    WHERE c.province_id = p.province_id
    GROUP BY c.city_id
    HAVING COUNT(f.fournisseur_id) > 2
);


--Afficher les commandes payées partiellement
SELECT 
    o.order_id,
    c.full_name as client,
    o.total_amount,
    SUM(p.amount) AS total_paye
FROM oltp.orders o
JOIN oltp.payments p ON o.order_id = p.order_id
JOIN oltp.customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, c.full_name, o.total_amount
HAVING SUM(p.amount) < o.total_amount;
ORDER BY SUM(p.amount) DESC;
GO;

--afficher les commandes payees avec un montant inferieur a 800.000
SELECT 
    o.order_id,
    c.full_name as client,
    o.total_amount,
    SUM(p.amount) AS total_paye
FROM oltp.orders o
JOIN oltp.payments p ON o.order_id = p.order_id
JOIN oltp.customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, c.full_name, o.total_amount
HAVING SUM(p.amount) < 800000
order by SUM(p.amount) DESC;


