-- selection de fournisseur et client qui sont dans la meme ville
SELECT 
    COUNT(DISTINCT f.fournisseur_id) AS NB_Fournisseurs, 
    COUNT(DISTINCT c.customer_id) AS NB_Clients, 
    ci.name AS Ville
FROM oltp.cities ci
LEFT JOIN oltp.fournisseurs f ON ci.city_id = f.city_id
LEFT JOIN oltp.customers c ON ci.city_id = c.city_id
GROUP BY ci.name;


-- liste tous les nombres de commande pour chaque client
select c.full_name as client, count(distinct o.order_id) as nb_commandes
 from oltp.customers c left join oltp.orders o
  on c.customer_id=o.customer_id 
  group by  c.full_name;

-- lister les nombres de commandes recus pour chaque fournisseur
  select f.full_name as fournisseur, count(distinct o.order_id) as nb_commandes
 from oltp.fournisseurs f left join oltp.orders o
  on f.fournisseur_id=o.fournisseur_id 
  group by  f.full_name;

-- lister les comandes par client et fournisseur
  SELECT 
    f.full_name AS fournisseur, 
    c.full_name AS client, 
    COUNT(o.order_id) AS nb_commandes
    o.total_amount
FROM oltp.fournisseurs f
LEFT JOIN oltp.orders o ON f.fournisseur_id = o.fournisseur_id
LEFT JOIN oltp.customers c ON o.customer_id = c.customer_id 
GROUP BY f.full_name, c.full_name,o.total_amount;