# SecureRehab: Logical Database Design

**Student Name:** Umwizerwa Ruth  
**Student ID:** 28235  
**Course:** PL/SQL Oracle Database Capstone (INSY 8311)  
**Phase:** III – Logical Database Design

---

## **Project Overview**

SecureRehab is a security-focused database system for offender rehabilitation and early-release management. The system aims to reduce prison overcrowding and recidivism by supporting data-driven decision-making in correctional institutions.

This Phase III submission focuses on the **logical database design**, including the **Entity-Relationship (ER) Diagram**, **Data Dictionary**, and **Assumptions**. All entities, attributes, primary keys, and foreign keys are defined, ensuring proper relationships, data integrity, and normalization up to 3NF.

---

## **Phase III Explanation**

The logical design of the SecureRehab system structures offender rehabilitation and early-release management into a normalized relational database to ensure data integrity and support analytics. The core entities include **Offenders, Offenses, Sentences, Rehab_Programs, Program_Participation,** and **Alerts**. Each entity contains attributes with clearly defined data types, primary keys (PKs), and foreign keys (FKs) to enforce relationships, e.g., `offender_id` links offenses, sentences, and program participation.

Normalization up to **3NF** eliminates redundant data and ensures that attributes depend solely on their primary keys, preventing anomalies during insertions or updates. Key constraints such as **PKs, FKs, NOT NULL, UNIQUE, and CHECK** maintain data accuracy. Relationships reflect real-world scenarios: offenders may have multiple offenses and participate in multiple rehabilitation programs, while alerts track risk levels and early-release eligibility.

This logical design supports **Management Information Systems (MIS)** by enabling accurate reporting on offender progress, program completion, and recidivism risk. Additionally, it lays the foundation for **Business Intelligence**, allowing aggregation of rehabilitation outcomes, identification of high-risk offenders, and informed decision-making by correctional authorities.

---

## **Submission Files**

All Phase III files are stored in this folder:

| File                  | Description                                                                           |
| --------------------- | ------------------------------------------------------------------------------------- |
| `SecureRehab_ERD.png` | Entity-Relationship Diagram showing entities, attributes, PKs, FKs, and relationships |
| `data_dictionary.md`  | Detailed table structures, columns, data types, constraints, and purpose              |
| `assumptions.md`      | List of assumptions used during logical database design                               |

---

---

**Note:**

- ER diagram clearly shows all relationships and cardinalities.
- Data dictionary follows clean Markdown format for easy readability.
- Assumptions include all business rules, optional fields, and standard formats for dates, gender, and risk scoring.
