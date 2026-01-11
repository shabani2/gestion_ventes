-- Cela supprimera toutes les données des trois tables en une seule transaction sécurisée.
EXEC oltp.sp_purge_transactions;

-- Générer les ~15 500 commandes et paiements
EXEC oltp.sp_simulate_data;
