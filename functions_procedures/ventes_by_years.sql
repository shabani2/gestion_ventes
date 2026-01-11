SELECT 
    YEAR(order_date) AS Annee, 
    COUNT(*) AS Nombre_Commandes,
    SUM(total_amount) AS Chiffre_Affaire_Annuel
FROM oltp.orders 
GROUP BY YEAR(order_date) 
ORDER BY Annee;