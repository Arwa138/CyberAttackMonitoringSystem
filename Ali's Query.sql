
--1-Show the latest 10 cyber attacks with attack type and attacker details .
--اعرض أحدث 10 هجمات إلكترونية مع نوع الهجوم وتفاصيل المهاجم

Create View vw_Top10RecentAttacks As
Select Top 10 a.attack_id, a.attack_time, a.status, at.attack_name, atk.name AS attacker_name, atk.country
From Attacks a
Join attack_types at On a.attack_type_id = at.attack_type_id
Join Attackers atk On a.attacker_id = atk.attacker_id
Order By a.attack_time Desc

--Test
Select * From vw_Top10RecentAttacks

--2-Create a comprehensive View of attacks with the attack type and attacker name .
-- عرض شامل للهجمات وأنواعها والمهاجمين

Create View vw_AttackDetails As
Select  a.attack_id,  a.attack_time, a.status, at.attack_name, atk.name As attacker_name, atk.Country
From  Attacks a
Join attack_types at On a.attack_type_id = at.attack_type_id
Join Attackers atk On a.attacker_id = atk.attacker_id

--Test
Select * From vw_AttackDetails

--3-Create a View of threat indicators with their Associated threat level.
--عرض مؤشرات التهديد مع مستوى التهديد المرتبط بها

Create View vw_IndicatorsThreat As
Select  i.ioc_id, i.type, i.threat_level, i.value, ai.attack_id
From Indicators i
Join Attack_Indicators ai On i.ioc_id = ai.ioc_id

--Test
Select * From vw_IndicatorsThreat

--4-Display targeted devices by country
--عرض الأجهزة المستهدفة حسب الدولة

Create View vw_TargetDevicesByCountry As
Select t.Country, d.device_info, d.network_segment, d.geo_locatiOn
From Targets t
Join target_device td On t.target_id = td.target_id
Join device_info d On td.device_id = d.device_id

--Test
Select * From vw_TargetDevicesByCountry

--5-Display attacks Associated with specific vulnerabilities .
--عرض الهجمات المرتبطة بثغرات محددة

Create View vw_AttacksWithVulns As
Select a.attack_id, v.vuln_id, v.cve_id, v.descriptiOn, v.severity
From Attack_Vulnerabilities av
Join Vulnerabilities v On av.vuln_id = v.vuln_id
Join Attacks a On av.attack_id = a.attack_id

--Test
Select * From vw_AttacksWithVulns

--6-Display the logs Associated with the attacks .
--عرض السجلات (logs) المرتبطة بالهجمات

Create View vw_AttackLogs As
Select l.log_id, l.log_timestamp, l.log_level, l.message, a.attack_time, a.status
From logs l
Join Attacks a On l.attack_id = a.attack_id

--Test
Select * From vw_AttackLogs

--7- Create FunctiOn to retrieve the details of a specific attack using the attack_id
--دالة لمعرقة تفاصيل هجوم معين باستخدام attack_id

Create FunctiOn fn_GetAttackDetails (@attackId Int)
Returns Table
As
Return
Select a.attack_id, at.attack_name, atk.name As attacker_name, a.status, a.attack_time
From Attacks a
Join attack_types at On a.attack_type_id = at.attack_type_id
Join Attackers atk On a.attacker_id = atk.attacker_id
Where a.attack_id = @attackId

--Test
Select * From fn_GetAttackDetails(18)

--8-Create FunctiOn that Returns the number of indicators Associated with each attack
--دالة تعرض عدد المؤشرات المرتبطة بكل هجوم

Create FunctiOn fn_CountIndicatorsPerAttack ()
Returns Table
As
Return
Select ai.attack_id, Count(ai.ioc_id) As indicator_Count
From Attack_Indicators ai
GROUP by ai.attack_id

--Test
Select * From fn_CountIndicatorsPerAttack()

--9-Create FunctiOn that displays the threat level of a specific indicator .
--دالة تعرض مستوى التهديد الخاص بمؤشر معين

Create FunctiOn fn_ThreatLevel (@iocId Int)
Returns Varchar(50)
As
Begin
    DECLARE @level Varchar(50)
    Select @level = threat_level
    From Indicators
    Where ioc_id = @iocId

    Return @level
End

--Test
Select dbo.fn_ThreatLevel(299)

