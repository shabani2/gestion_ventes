
-- Procédure : Simulation de données massives (Volume >= 3000 par an)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oltp.sp_simulate_data') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE oltp.sp_simulate_data
END
GO

CREATE PROCEDURE oltp.sp_simulate_data
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Year INT = 2020;
    DECLARE @MaxYear INT = 2026;
    DECLARE @i INT;
    DECLARE @TargetCount INT;
    
    DECLARE @RandomDate DATE;
    DECLARE @RandomCustomerID INT;
    DECLARE @RandomFournisseurID INT;
    DECLARE @OrderID INT;
    DECLARE @TotalOrderAmount DECIMAL(14,2);
    DECLARE @RandomStatus NVARCHAR(20);

    BEGIN TRY
        PRINT 'Début de la simulation des données... (Veuillez patienter)';

        WHILE @Year <= @MaxYear
        BEGIN
            -- Définition du volume de données selon l'année
            SET @TargetCount = CASE WHEN @Year = 2026 THEN 500 ELSE 3000 END;
            SET @i = 1;

            WHILE @i <= @TargetCount
            BEGIN
                -- 1. Génération d'une date aléatoire dans l'année
                IF @Year < 2026
                    SET @RandomDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), CAST(CAST(@Year AS VARCHAR) + '-01-01' AS DATE));
                ELSE
                    -- Limité au début janvier 2026
                    SET @RandomDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 10), CAST('2026-01-01' AS DATE));

                -- 2. Sélection aléatoire d'un client et d'un fournisseur
                SELECT TOP 1 @RandomCustomerID = customer_id FROM oltp.customers ORDER BY NEWID();
                SELECT TOP 1 @RandomFournisseurID = fournisseur_id FROM oltp.fournisseurs ORDER BY NEWID();

                -- 3. Sélection aléatoire d'un statut (NEW, CONFIRMED, DELIVERED, CANCELLED)
                SET @RandomStatus = CASE (ABS(CHECKSUM(NEWID()) % 4)) 
                                        WHEN 0 THEN 'NEW' 
                                        WHEN 1 THEN 'CONFIRMED' 
                                        WHEN 2 THEN 'DELIVERED' 
                                        ELSE 'CANCELLED' 
                                    END;

                -- 4. Insertion de la commande avec le statut aléatoire
                INSERT INTO oltp.orders (customer_id, fournisseur_id, order_date, order_status, total_amount)
                VALUES (@RandomCustomerID, @RandomFournisseurID, @RandomDate, @RandomStatus, 0);

                SET @OrderID = SCOPE_IDENTITY();

                -- 5. Insertion des items (1 à 3 par commande)
                DECLARE @ItemsCount INT = (ABS(CHECKSUM(NEWID()) % 3) + 1);
                DECLARE @j INT = 1;
                SET @TotalOrderAmount = 0;

                WHILE @j <= @ItemsCount
                BEGIN
                    DECLARE @ProdID INT, @UnitPrice DECIMAL(12,2), @Qty INT;
                    
                    -- Sélection d'un produit non déjà présent dans cette commande
                    SELECT TOP 1 @ProdID = product_id FROM oltp.products 
                    WHERE product_id NOT IN (SELECT product_id FROM oltp.order_items WHERE order_id = @OrderID)
                    ORDER BY NEWID();

                    -- Prix aléatoire entre 10 000 et 60 000
                    SET @UnitPrice = (ABS(CHECKSUM(NEWID()) % 50) + 10) * 1000; 
                    SET @Qty = (ABS(CHECKSUM(NEWID()) % 5) + 1);

                    INSERT INTO oltp.order_items (order_id, product_id, quantity, unit_price)
                    VALUES (@OrderID, @ProdID, @Qty, @UnitPrice);

                    SET @TotalOrderAmount = @TotalOrderAmount + (@UnitPrice * @Qty);
                    SET @j = @j + 1;
                END

                -- 6. Mise à jour du total de la commande
                UPDATE oltp.orders SET total_amount = @TotalOrderAmount WHERE order_id = @OrderID;

                -- 7. Insertion du paiement (uniquement si la commande n'est pas annulée, par exemple)
                -- On simule un paiement pour la plupart des commandes pour peupler la table payments
                IF @RandomStatus <> 'CANCELLED' OR (ABS(CHECKSUM(NEWID()) % 2) = 0)
                BEGIN
                    INSERT INTO oltp.payments (order_id, payment_date, amount, payment_method, payment_status)
                    VALUES (@OrderID, @RandomDate, @TotalOrderAmount, 
                            CASE (ABS(CHECKSUM(NEWID()) % 3)) 
                                 WHEN 0 THEN 'CASH' WHEN 1 THEN 'MOBILE_MONEY' ELSE 'BANK_TRANSFER' END, 
                            CASE WHEN @RandomStatus = 'DELIVERED' THEN 'PAID' ELSE 'PENDING' END);
                END

                SET @i = @i + 1;
            END
            
            PRINT 'Année ' + CAST(@Year AS VARCHAR) + ' terminée : ' + CAST(@TargetCount AS VARCHAR) + ' commandes insérées.';
            SET @Year = @Year + 1;
        END

        PRINT 'Simulation terminée avec succès !';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'Erreur lors de la simulation : ' + ERROR_MESSAGE();
    END CATCH
END;
GO