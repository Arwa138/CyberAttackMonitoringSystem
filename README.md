
---

## 🗃️ Database Entities

The system models real-world cybersecurity workflows using the following core entities:

- `Attackers`
- `Attack_Types`
- `Motivations`
- `Devices`
- `Targets`
- `Vulnerabilities`
- `Indicators_Of_Compromise`
- `Log_Events`
- `Incidents`

Each entity plays a role in tracking, linking, and analyzing different dimensions of a cyberattack.

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

