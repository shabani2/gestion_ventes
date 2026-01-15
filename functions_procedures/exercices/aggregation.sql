--calculer le montant total des commandes
select sum(o.total_amount) as total_amount
from oltp.orders o;

--2 trouver le maximun de paiement
select max(p.amount) as max_payment
from oltp.payments p;

--3Compter le nombre de produits
select count(p.product_id) as product_count
from oltp.products p;

--4Nombre de produits par catégorie
select p.category_id, count(p.product_id) as product_count
from oltp.products p
group by p.category_id;
--ou
select cp.name, count(p.product_id) as nbre_produit
from oltp.product_categories cp 
left join oltp.products p 
on cp.category_id = p.category_id
group by cp.name;

--5Nombre de clients par ville
select c.name, count(ct.customer_id) as nbre_client
from oltp.cities c
left join oltp.customers ct
on c.city_id=ct.city_id
group by c.name;

--6Nombre de commandes par client
select c.full_name, count(o.order_id) as nbre_commande
from oltp.customers c left join
oltp.orders o on c.customer_id=o.customer_id
group by c.full_name
order by c.full_name asc;

--7Montant total des ventes par fournisseur
select f.full_name, count(o.order_id) as nbre_commande, sum(o.total_amount) as montant
from oltp.fournisseurs f left join
oltp.orders o on f.fournisseur_id=o.fournisseur_id
group by f.full_name
order by f.full_name asc;

--8Top 5 clients par montant commandé
select top 5 c.full_name, count(o.order_id) as nbre_commande,sum(o.total_amount) as montant
from oltp.customers c left join
oltp.orders o on c.customer_id=o.customer_id
group by c.full_name
order by sum(o.total_amount) desc;

--9Classement des fournisseurs par chiffre d’affaires
select f.full_name, count(o.order_id) as nbre_commande, sum(o.total_amount) as montant
from oltp.fournisseurs f left join
oltp.orders o on f.fournisseur_id=o.fournisseur_id
group by f.full_name
order by sum(o.total_amount) desc;

--10Moyenne des paiements par méthode
select p.payment_method as methode,avg(p.amount) as moyenne_by_methode 
from oltp.payments p group by p.payment_method
order by avg(p.amount) desc;

--11Montant total des ventes par province
SELECT
	p.name,
    count(distinct c.city_id) as nbre_ville,
    COUNT(DISTINCT f.fournisseur_id) AS nbre_fournisseur,
    Coalesce(SUM(o.total_amount),0) AS montant
FROM oltp.provinces p left join oltp.cities c
on p.province_id = c.province_id left join
oltp.fournisseurs f
    ON c.city_id = f.city_id
left JOIN oltp.orders o 
    ON f.fournisseur_id = o.fournisseur_id
GROUP BY p.name
ORDER BY montant desc;


--12 lister les produits les plus commandes
SELECT
  p.product_id,
  p.name AS product_name,
  COALESCE(SUM(o.quantity), 0) AS quantite
FROM oltp.products p
LEFT JOIN oltp.order_items o
  ON p.product_id = o.product_id
GROUP BY
  p.product_id,
  p.name
ORDER BY quantite DESC;

--13 afficher les nombres de produits par commande
SELECT
  o.order_id,
  COUNT(oi.product_id) AS nombre_produits
FROM oltp.orders o
LEFT JOIN oltp.order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

--14 Fournisseur avec le plus grand nombre de commandes
select  f.full_name, coalesce(count(o.order_id),0) nbre_cmde from oltp.fournisseurs f
left join oltp.orders o on f.fournisseur_id = o.fournisseur_id
group by f.full_name
order by nbre_cmde desc;

