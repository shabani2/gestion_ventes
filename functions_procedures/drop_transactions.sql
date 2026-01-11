
-- ======================================================================================
-- 6. PROCÉDURES DE MAINTENANCE
-- ======================================================================================

-- Procédure : Vider les tables de transactions
-- Note : L'ordre de suppression est crucial à cause des clés étrangères.
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oltp.sp_purge_transactions') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE oltp.sp_purge_transactions
END
GO

CREATE PROCEDURE oltp.sp_purge_transactions
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Supprimer les paiements (table enfant de orders)
        DELETE FROM oltp.payments;
        
        -- 2. Supprimer les détails de commande (table enfant de orders)
        DELETE FROM oltp.order_items;
        
        -- 3. Supprimer les commandes (table parente)
        DELETE FROM oltp.orders;

        -- Optionnel : Réinitialiser les compteurs d'identité (ID repartira de 1)
        -- DBCC CHECKIDENT ('oltp.payments', RESEED, 0);
        -- DBCC CHECKIDENT ('oltp.order_items', RESEED, 0);
        -- DBCC CHECKIDENT ('oltp.orders', RESEED, 0);

        COMMIT TRANSACTION;
        
        PRINT 'Succès : Les tables transactions (orders, items, payments) ont été vidées.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Erreur lors de la purge : ' + ERROR_MESSAGE();
    END CATCH
END;
GO