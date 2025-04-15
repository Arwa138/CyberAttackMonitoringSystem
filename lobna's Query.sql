--Which attackers are most active or dangerous
select distinct name 
from Attackers ar
join attacks a
on a.attacker_id=ar.attacker_id
join logs l
on a.attack_id=l.attack_id
where l.severity='High'


--Attack prevention rate: (Detected vs. Undetected)

SELECT 
    response,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 0) AS percentage
FROM attacks
GROUP BY response;



--Which vulnerabilities have led to the most attacks?   and if it has patch available
SELECT 
    va.vuln_id,v.patch_available,
    COUNT(*) AS attack_count
FROM Attack_Vulnerabilities va,Vulnerabilities v
where va.vuln_id=v.vuln_id
GROUP BY va.vuln_id,v.patch_available
ORDER BY attack_count DESC;

--does having patch availabile effects?
select a.response ,COUNT(*)
from Vulnerabilities v
join Attack_Vulnerabilities va
on va.vuln_id=v.vuln_id
join attacks a
on a.attack_id=va.attack_id
where v.patch_available=0
group by a.response
