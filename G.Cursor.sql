--rollup

SELECT 
    t.country,
    at.attack_name AS attack_type,
    COUNT(*) AS total_attacks
FROM Attacks a
JOIN Targets t ON a.target_id = t.target_id
JOIN attack_types at ON a.attack_type_id = at.attack_type_id
GROUP BY ROLLUP (t.country, at.attack_name);

-------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    t.country,
    at.attack_name AS attack_type,
    COUNT(*) AS total_attacks
FROM Attacks a
JOIN Targets t ON a.target_id = t.target_id
JOIN attack_types at ON a.attack_type_id = at.attack_type_id
GROUP BY CUBE (t.country, at.attack_name);
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @AttackID INT,
        @AttackerName VARCHAR(50),
        @TargetName VARCHAR(50),
        @AttackType VARCHAR(50),
        @AttackTime DATETIME;


DECLARE attack_cursor CURSOR FOR
SELECT 
    a.attack_id,
    atk.name AS attacker_name,
    tgt.name AS target_name,
    at.attack_name AS attack_type,
    a.date
FROM Attacks a
	JOIN Attackers atk ON a.attacker_id = atk.attacker_id
	JOIN Targets tgt ON a.target_id = tgt.target_id
	JOIN attack_types at ON a.attack_type_id = at.attack_type_id
WHERE a.date >= DATEADD(DAY, -7, GETDATE()); -- only attacks in last 7 days


OPEN attack_cursor


FETCH NEXT FROM attack_cursor INTO @AttackID, @AttackerName, @TargetName, @AttackType, @AttackTime;


WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Attack ID: ' + CAST(@AttackID AS VARCHAR) + 
          ' | Attacker: ' + @AttackerName + 
          ' | Target: ' + @TargetName + 
          ' | Type: ' + @AttackType + 
          ' | Time: ' + CONVERT(VARCHAR, @AttackTime, 120);

    FETCH NEXT FROM attack_cursor INTO @AttackID, @AttackerName, @TargetName, @AttackType, @AttackTime;
END


CLOSE attack_cursor;
DEALLOCATE attack_cursor;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE attack_summary (
    country VARCHAR(100),
    total_attacks INT
);

INSERT INTO attack_summary (country, total_attacks)
SELECT DISTINCT t.country, 0
FROM Targets t;

-- Merge live attack data into this table
MERGE attack_summary AS summary
USING (
    SELECT t.country, COUNT(a.attack_id) AS attack_count
    FROM Attacks a
    JOIN Targets t ON a.target_id = t.target_id
    GROUP BY t.country
) AS live_data
ON summary.country = live_data.country

WHEN MATCHED THEN
    UPDATE SET summary.total_attacks = live_data.attack_count;


SELECT * FROM attack_summary;


