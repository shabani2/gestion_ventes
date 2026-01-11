-- ======================================================================================
-- ANALYSE DE LA GESTION DES VENTES DE PRODUITS AGRICOLES
-- Auteur : Assistant
-- Description : Série de requêtes pour analyser les ventes, les clients et les produits.
-- ======================================================================================

-- 1. ANALYSE TEMPORELLE DES VENTES
-- Objectif : Voir l'évolution du chiffre d'affaires (CA) par mois et année.
SELECT 
    FORMAT(o.order_date, 'yyyy-MM') AS mois_annee,
    COUNT(o.order_id) AS nombre_commandes,
    SUM(o.total_amount) AS chiffre_affaires_total,
    AVG(o.total_amount) AS panier_moyen
FROM 
    oltp.orders o
WHERE 
    o.order_status IN ('CONFIRMED', 'DELIVERED') -- On ne compte que les ventes validées
GROUP BY 
    FORMAT(o.order_date, 'yyyy-MM')
ORDER BY 
    mois_annee DESC;

-- 2. PALMARÈS DES PRODUITS (BEST-SELLERS)
-- Objectif : Identifier les produits agricoles les plus vendus en volume et en valeur.
SELECT TOP 10
    p.name AS produit,
    c.name AS categorie,
    SUM(oi.quantity) AS volume_total_vendu,
    p.unit AS unite_mesure,
    SUM(oi.quantity * oi.unit_price) AS revenu_genere
FROM 
    oltp.order_items oi
JOIN 
    oltp.products p ON oi.product_id = p.product_id
JOIN 
    oltp.product_categories c ON p.category_id = c.category_id
JOIN 
    oltp.orders o ON oi.order_id = o.order_id
WHERE 
    o.order_status <> 'CANCELLED'
GROUP BY 
    p.name, c.name, p.unit
ORDER BY 
    revenu_genere DESC;

-- 3. ANALYSE GÉOGRAPHIQUE (PAR PROVINCE)
-- Objectif : Savoir quelle région génère le plus de demande.
SELECT 
    prov.name AS province,
    COUNT(DISTINCT o.order_id) AS nombre_commandes,
    SUM(o.total_amount) AS chiffre_affaires
FROM 
    oltp.orders o
JOIN 
    oltp.customers cust ON o.customer_id = cust.customer_id
JOIN 
    oltp.cities city ON cust.city_id = city.city_id
JOIN 
    oltp.provinces prov ON city.province_id = prov.province_id
GROUP BY 
    prov.name
ORDER BY 
    chiffre_affaires DESC;

-- 4. SEGMENTATION CLIENTS (RÈGLE DES 80/20)
-- Objectif : Identifier les "V.I.P." (clients qui achètent le plus).
SELECT TOP 20
    cust.full_name AS nom_client,
    city.name AS ville,
    COUNT(o.order_id) AS frequence_achat,
    SUM(o.total_amount) AS total_depense,
    MAX(o.order_date) AS dernier_achat
FROM 
    oltp.customers cust
JOIN 
    oltp.orders o ON cust.customer_id = o.customer_id
JOIN 
    oltp.cities city ON cust.city_id = city.city_id
WHERE 
    o.order_status IN ('CONFIRMED', 'DELIVERED')
GROUP BY 
    cust.customer_id, cust.full_name, city.name
ORDER BY 
    total_depense DESC;

-- 5. PERFORMANCE DES FOURNISSEURS
-- Objectif : Voir quel fournisseur alimente le plus le chiffre d'affaires.
SELECT 
    f.company_name AS fournisseur,
    COUNT(DISTINCT o.order_id) AS commandes_liees,
    SUM(o.total_amount) AS volume_affaires_genere
FROM 
    oltp.orders o
JOIN 
    oltp.fournisseurs f ON o.fournisseur_id = f.fournisseur_id
WHERE 
    o.order_status <> 'CANCELLED'
GROUP BY 
    f.company_name
ORDER BY 
    volume_affaires_genere DESC;

-- 6. ÉTAT DE LA TRÉSORERIE (PAIEMENTS)
-- Objectif : Comparer ce qui a été facturé vs ce qui a été réellement encaissé.
SELECT 
    pm.payment_method,
    pm.payment_status,
    COUNT(pm.payment_id) AS nombre_transactions,
    SUM(pm.amount) AS montant_total
FROM 
    oltp.payments pm
GROUP BY 
    pm.payment_method, pm.payment_status
ORDER BY 
    pm.payment_status, montant_total DESC;

-- 7. TAUX D'ANNULATION DES COMMANDES
-- Objectif : Surveiller la santé commerciale.
SELECT 
    order_status,
    COUNT(*) AS nombre,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM oltp.orders) AS DECIMAL(5,2)) AS pourcentage
FROM 
    oltp.orders
GROUP BY 
    order_status;