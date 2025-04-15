--Show a list of all attacks with the target name, the attack type name, and the attack motivation. 
--Only include attacks that have valid targets and attack types.
SELECT 
    A.attack_id,
    T.name AS target_name,
    AT.attack_name,
    A.motivation
FROM 
    Attacks A
INNER JOIN 
    Targets T ON A.target_id = T.target_id
INNER JOIN 
    attack_types AT ON A.attack_type_id = AT.attack_type_id;

--List all targets and their associated attacks,
--if any. Show target name, IP address, and attack ID (if exists).
--Include targets even if they don’t have attacks.

SELECT 
    T.name AS target_name,
    T.ip_address,
    A.attack_id
FROM 
    Targets T
LEFT JOIN 
    Attacks A ON T.target_id = A.target_id;



--List all vulnerabilities and their associated attacks (if any), 
--showing the CVE ID, severity, and attack ID. 
--Include vulnerabilities even if they haven’t been linked to any attack.
SELECT 
    V.cve_id,
    V.severity,
    AV.attack_id
FROM 
    Vulnerabilities V
RIGHT JOIN 
    Attack_Vulnerabilities AV ON V.vuln_id = AV.vuln_id;

--Get a list of devices that are not currently linked to any targets. Show device ID and location.
SELECT 
    D.device_id,
    D.geo_location
FROM 
    device_info D
LEFT JOIN 
    target_device td ON D.device_id = td.device_id
WHERE 
    td.device_id IS NULL;

--How many attacks have been launched for each attack type? Show attack type name and number of attacks.

SELECT 
    AT.attack_name,
    COUNT(A.attack_id) AS number_of_attacks
FROM 
    attack_types AT
INNER JOIN 
    Attacks A ON AT.attack_type_id = A.attack_type_id
GROUP BY 
    AT.attack_name;

--List all targets and how many attacks were attempted on each. Include targets with zero attacks.
SELECT 
    T.name AS target_name,
    COUNT(A.attack_id) AS total_attacks
FROM 
    Targets T
LEFT JOIN 
    Attacks A ON T.target_id = A.target_id
GROUP BY 
    T.name;

--Show the most recent log time for each attack.
SELECT 
    A.attack_id,
    MAX(L.time) AS last_log_time
FROM 
    Attacks A
JOIN 
    logs L ON A.attack_id = L.attack_id
GROUP BY 
    A.attack_id;

--Find targets that have been attacked more than once. Show target name and number of attacks.
SELECT 
    T.name AS target_name,
    COUNT(A.attack_id) AS total_attacks
FROM 
    Targets T
JOIN 
    Attacks A ON T.target_id = A.target_id
GROUP BY 
    T.name
HAVING 
    COUNT(A.attack_id) > 1;

--Get a list of all unique device locations and target countries.
SELECT geo_location AS location
FROM device_info

UNION

SELECT country AS location
FROM Targets;

--Get a list of all device locations and target countries including duplicates.
SELECT geo_location AS location
FROM device_info

UNION ALL

SELECT country AS location
FROM Targets;

--Get all indicators and vulnerabilities with threat-level 'High' or severity 'High'.
SELECT type AS item_type, value AS description
FROM Indicators
WHERE threat_level = 'High'

UNION ALL

SELECT 'Vulnerability', cve_id
FROM Vulnerabilities
WHERE severity = 'High';

--Get the count of logs and the count of attacks, labeled properly in a single result.
SELECT COUNT(*) AS total, 'Logs' AS category
FROM logs

UNION

SELECT COUNT(*) AS total, 'Attacks' AS category
FROM Attacks;

--List all device locations that are not used as target countries.
SELECT geo_location
FROM device_info

EXCEPT

SELECT country
FROM Targets;

 --Get names of targets that have never been attacked.
 SELECT name
FROM Targets
WHERE target_id NOT IN (
    SELECT target_id
    FROM Attacks
);

SELECT T.name
FROM Targets T
LEFT JOIN Attacks A ON T.target_id = A.target_id
WHERE A.attack_id IS NULL;

--Show all vulnerabilities that were never exploited in any attack
SELECT cve_id
FROM Vulnerabilities
WHERE vuln_id NOT IN (
    SELECT vuln_id
    FROM Attack_Vulnerabilities
);

SELECT V.cve_id
FROM Vulnerabilities V
LEFT JOIN Attack_Vulnerabilities AV ON V.vuln_id = AV.vuln_id
WHERE AV.attack_id IS NULL;

--List each target and the number of attacks it has received.
SELECT 
    name,
    (SELECT COUNT(*) 
     FROM Attacks 
     WHERE target_id = T.target_id) AS attack_count
FROM Targets T;


















































