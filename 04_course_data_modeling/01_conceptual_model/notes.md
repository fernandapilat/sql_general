# Conceitual Model

> "The goal of the conceptual model is to describe, in a simple and easily understood way for the end user, the business context information that must be stored in a database."
> — **Machado, Felipe Nery Rodrigues (Database - Design and Implementation)**

## 1. Introduction: The Importance of Data Modeling
Data modeling is a fundamental technique used to design, maintain, and utilize databases effectively. It ensures that the information system supports business goals through a structured architecture.

### Who uses Data Modeling?
* **Systems Analysts & Developers:** To design databases that support application requirements.
* **Database Administrators (DBAs):** To monitor, optimize performance, and ensure data integrity.
* **Data Scientists & Analysts:** To organize data for effective cleaning and analysis.
* **Data Architects:** To manage data as a strategic resource across organizations.
* **Project Managers:** To bridge the gap between technical teams and stakeholders.
* **Compliance & Security Officers:** To ensure regulations like LGPD/GDPR are met.
* **Entrepreneurs:** To build scalable data infrastructures from the start.

---

## 2. Conceptual Framework: MER vs. DER
It is common to confuse these terms, but they represent different levels: the **methodology** and the **visualization**.

### 2.1 MER (Entity-Relationship Model)
The **MER** is the **conceptual framework** (the rules).
* **Focus:** Logic, constraints, and business rules.
* **Analogy:** It is like the **BPMN standard**—it defines *how* to map, but isn't the map itself.

### 2.2 DER (Entity-Relationship Diagram)
The **DER** is the **visual representation** (the drawing).
* **Focus:** Graphic tools (Rectangles, Rhombuses, Ellipses) to provide a clear view.
* **Analogy:** It is the **Flowchart** itself—the final visual delivery.

---

## 3. Workflow & Tooling
1. **Mini-world:** The "story" or business process.
2. **Requirement Elicitation:** Using Interviews, Questionnaires, and Observation to define data needs.
3. **CASE Tool:** We use [Visual Paradigm](https://www.visual-paradigm.com/) to create professional ERDs.

---

## 4. Entities: Strong vs. Weak
Entities are classified based on their independence within the model.

* **Strong Entity:** Independent; has its own Primary Key (e.g., `Customer`).
* **Weak Entity:** Dependent on a strong entity; its identity is tied to a parent (e.g., `Payment` depends on `Loan`).

| Conceptual (Entity) | Physical (Table) |
| :--- | :--- |
| Entity | Table |
| Attribute | Column / Field |
| Identifier | Primary Key (PK) |
| **Relationship** | **Foreign Key (FK)** |
| Instance | Row / Record |

---

## 5. Relationships and Cardinality
How entities interact within the business process.

* **Degree:** Unary (recursive), Binary (2 entities), or Ternary (3 entities).
* **Cardinality:** 1:1, 1:N (One-to-Many), or N:N (Many-to-Many).
* **Associative Entities:** Used to resolve **N:N** relationships by creating a "middle" entity that can hold its own attributes (e.g., `Enrollment` connecting `Employee` and `Training`).

---

## 6. Attributes (Conceptual Level)
Attributes describe the properties of an Entity.

### 6.1 Classification
* **Simple (Atomic):** e.g., `salary`.
* **Composite:** e.g., `Address` (Street + City).
* **Multi-valued:** e.g., `phone` (represented with **double-line ellipse**).
* **Derived:** e.g., `age` (calculated from birth date, **dashed-line ellipse**).

### 6.2 Identifiers (Key Attributes)
* **Natural Key:** Real-world ID (e.g., `tax_id` / `CPF`).
* **Surrogate Key:** System-generated ID (e.g., `customer_id`).
* **Visual:** Key attributes are always **underlined** in the DER.

---

## 7. DBMS (SGBD) vs. Spreadsheets
A crucial transition for the **Flexempresta** project.

### Why not stay in Excel?
* **Data Integrity:** SGBDs prevent "dirty data" (e.g., text in a currency field).
* **Concurrency:** Multi-user access without file locking.
* **Security:** Granular permissions (who sees what).
* **Scalability:** Handling millions of rows with high performance.

---

## 8. Strategic Success Factors
* **Storage Selection:** Deciding between SQL vs. NoSQL or Cloud vs. On-premise.
* **Compliance:** Ensuring the architecture follows data protection laws.
* **Human Expertise:** Involving DBAs and Architects for a long-lasting system.