
--inserts a new record into the Attacks table and creates a corresponding log entry in the logs table with default log values.

create or alter proc InsertAttackSimple
    @attacker_id int,
    @attack_type_id int,
    @target_id int,
    @attack_time datetime,
    @motivation VARCHAR(100),
    @response VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON; -- Prevents the system from returning "x rows affected" messages 

    INSERT INTO Attacks 
        (attacker_id, attack_type_id, target_id, date, motivation, response)
    VALUES 
        (@attacker_id, @attack_type_id, @target_id, @attack_time, @motivation, @response);

    
    DECLARE @attack_id INT;
    SET @attack_id = SCOPE_IDENTITY();  --generat new attack_id

    
    INSERT INTO logs 
        (attack_id, time, source, level, message, severity)
    VALUES 
        (@attack_id, GETDATE(), 'System', 'Info', 'Attack recorded', 'Normal');
END



EXEC InsertAttackSimple 
    @attacker_id = 1,
    @attack_type_id = 2,
    @target_id = 3,
	@attack_time = GETDATE(),
    @motivation = 'Test Attack',
    @response = 'Active'
	


---------------------------------------------------------------------------------------------------------------------------------------------

--Get a full summary of an attack by attack_id

create or alter proc GetAttackSummary
    @attack_id INT
AS
BEGIN
    SET NOCOUNT ON

    -- 1. Basic Attack Info
    SELECT 
        A.attack_id,
        A.date,
        A.motivation,
        A.response,
        AT.attack_name,
        AT.category,
        AK.name AS attacker_name,
        AK.ip_address AS attacker_ip,
        AK.country AS attacker_country,
        T.name AS target_name,
        T.ip_address AS target_ip,
        T.industry AS target_industry,
        T.country AS target_country
    FROM Attacks A
    INNER JOIN attack_types AT ON A.attack_type_id = AT.attack_type_id
    INNER JOIN Attackers AK ON A.attacker_id = AK.attacker_id
    INNER JOIN Targets T ON A.target_id = T.target_id
    WHERE A.attack_id = @attack_id

    -- 2. Associated Indicators 
    SELECT 
        I.ioc_id,
        I.type,
        I.value,
        I.threat_level,
        I.description
    FROM Attack_Indicators AI
    INNER JOIN Indicators I ON AI.ioc_id = I.ioc_id
    WHERE AI.attack_id = @attack_id

    -- 3. Associated Vulnerabilities
    SELECT 
        V.vuln_id,
        V.cve_id,
        V.description,
        V.severity,
        V.patch_available
    FROM Attack_Vulnerabilities AV
    INNER JOIN Vulnerabilities V ON AV.vuln_id = V.vuln_id
    WHERE AV.attack_id = @attack_id
END



EXEC GetAttackSummary @attack_id = 100

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Log a message whenever a new attack is inserted
-- after insert into attacks table, it auto-logs a record in the logs table.

create or alter trigger trg_AfterAttackInsert
ON Attacks
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @attack_id INT = (SELECT attack_id FROM inserted)

    INSERT INTO logs 
        (attack_id, time, source, level, message, severity)
    VALUES 
        (@attack_id, GETDATE(), 'Trigger', 'Info', 'New attack inserted.', 'Medium')
END




--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- keeps track of deleted attacks in the logs table and warn on it

CREATE TRIGGER trg_AfterAttackDelete
ON Attacks
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO logs (attack_id, time, source, level, message, severity)
    SELECT 
        d.attack_id,
        GETDATE(),
        'Trigger',
        'Critical',
        CONCAT('Attack record deleted (Attack ID: ', d.attack_id, ')'),
        'Critical'
    FROM deleted d
END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--makes the Indicators table read-only 

create or alter trigger trg_ReadOnly
ON Indicators
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) -- for update
    BEGIN
        RAISERROR('UPDATE not allowed on Indicators table.', 16, 1); -- Shows a custom error message.
        ROLLBACK TRANSACTION; -- Cancels the entire action before any change happens.
        RETURN;
    END

    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) -- for insert
    BEGIN
        RAISERROR('INSERT not allowed on Indicators table.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) -- for delete
    BEGIN
        RAISERROR('DELETE not allowed on Indicators table.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END



INSERT INTO dbo.Indicators (ioc_id, type, value, threat_level, description)
VALUES (999, 'IP', '192.168.0.99', 'High', 'Test insert')







