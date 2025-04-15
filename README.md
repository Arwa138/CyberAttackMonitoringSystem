# 🔐 CyberAttackMonitoringSystem

## Project Title: **CyberAttack Monitoring System**

A relational database project designed to model, track, and analyze cyberattacks using structured data. This system was developed as a final project for the Database Fundamentals course at ITI, focusing on real-world cybersecurity challenges.

---

## 📌 Project Overview

Cybersecurity incidents are growing in complexity and volume. This system aims to support **threat detection**, **incident response**, and **behavioral analysis** by modeling key elements of cyberattacks in a relational database.

---

## 🧱 Key Features

- **ERD Design**: A detailed Entity Relationship Diagram representing the core entities involved in cyberattacks and their relationships.
- **Relational Schema**: A normalized database structure designed for clarity, efficiency, and analytical capabilities.
- **SQL Queries**: Developed to extract valuable insights and answer key business questions around cyberattack patterns.

---

## 🗃️ Database Entities

The system models real-world cybersecurity workflows using the following core entities:

- **Targets**
  - `target_id` (PK)
  - `name`
  - `ip_address`
  - `industry`
  - `country`

- **Device_Info**
  - `device_id` (PK)
  - `user_info`
  - `device_info`
  - `network_segment`
  - `geo_location`

- **Vulnerabilities**
  - `vulnerability_id` (PK)
  - `name`
  - `severity`
  - `patch_available`

- **Attacks**
  - `attack_id` (PK)
  - `attacker_id` (FK)
  - `attack_time`
  - `motivation_status`

- **Attack_Types**
  - `attack_type_id` (PK)
  - `attack_name`
  - `category`

- **Indicators**
  - `ioa_id` (PK)
  - `type_value`
  - `threat_level_score`

- **Attackers**
  - `attacker_id` (PK)
  - `ip_address`
  - `country`

- **Logs**
  - `log_id` (PK)
  - `timestamp_log`
  - `storage_log`
  - `level_message`
  - `severity_level`
  - `attack_id` (FK)

---

### Relationship Entities

- **Attack_Vulnerabilities**
  - `attack_vulnerability_id` (PK)
  - `attack_id` (FK)
  - `vulnerability_id` (FK)

- **Attack_Indicators**
  - `attack_indicator_id` (PK)
  - `attack_id` (FK)
  - `indicator_id` (FK)

- **Target_Devices**
  - `target_device_id` (PK)
  - `target_id` (FK)
  - `device_id` (FK)

---

## 💡 Explanation

### Entities:

- **Targets**: Represents entities that are potential victims of attacks, categorized by industry and country.
- **Device_Info**: Contains information about devices, including user info, network segment, and geographical location.
- **Vulnerabilities**: Details weaknesses in systems that can be exploited, with severity and patch availability information.
- **Attacks**: Represents individual attack events, linking attackers, attack types, and targets, with timestamps and motivation status.
- **Attack_Types**: Defines different types of attacks, categorized by name and description.
- **Indicators**: Represents indicators of compromise, with type and threat level score.
- **Attackers**: Represents individuals or groups carrying out attacks, with attributes detailing their IP address and country.
- **Logs**: Records of events that occur within the system, timestamped and categorized by severity level and associated attack.

### Relationships:

- **Attack_Vulnerabilities**: Links attacks to the vulnerabilities they exploit.
- **Attack_Indicators**: Connects indicators of compromise to specific attacks.
- **Target_Devices**: Connects targets to the devices they are associated with.

---

## 📑 ERD and Mapping

- **ERD Design**: The Entity Relationship Diagram (ERD) visually represents the structure of the database. It shows how each entity in the system is connected and the relationships between them, providing an overview of the cybersecurity landscape.
  
- **Mapping**: The `Table_Mapping.xlsx` file provides detailed descriptions of each table and its attributes, including primary and foreign keys. This helps understand the purpose of each entity and how they interconnect in the system.

---

## 📑 SQL Queries Overview

The `analysis_queries.sql` file includes a rich set of SQL features and business-driven queries, such as:

- **Views**: For simplified access to frequently used or complex queries  
- **Stored Procedures**: Automating reports and parameterized operations  
- **Cursors**: Handling row-by-row logic for tracking or inspection  
- **Pivot Tables**: Restructuring data for monthly/quarterly attack summaries  
- **Triggers**: Enforcing rules or tracking changes during data updates  
- **UNION / UNION ALL**: Merging datasets from similar structures  
- **JOINs**: Retrieving insights across multiple related tables  
- **Aggregate Functions**: COUNT, AVG, MAX, etc., for summarizing attack trends  
- **Subqueries**: Used within SELECT, WHERE, and FROM clauses  
- **Business Questions Answered**:
  - **Which attackers are most active or dangerous?**
    - _(Based on high-severity logs associated with their attacks)_
  - **What is the attack prevention rate?**
    - _(A comparison of detected vs. undetected attacks based on the `response` field)_
  - **Which vulnerabilities have led to the most attacks?**
    - _(And whether those vulnerabilities have patches available or not)_
  - **Does the availability of a patch affect the attack response outcome?**
    - _(Analyzing whether attacks exploiting unpatched vulnerabilities result in different responses)_

These components enable both technical exploration and high-level insight generation.

---

## 💡 Technology Used

- **SQL Server Management Studio (SSMS)**
- 
