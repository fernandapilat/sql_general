# Database Normalization: Flexempresta Project

## 1. Introduction

Normalization is the technical process of refining a database's logical structure to ensure it is efficient, reliable, and professional. By applying specific rules known as Normal Forms, we transform raw or disorganized data into a robust relational system, preventing future errors and redundancy.

### 1.1 Core Concept

According to Felipe Machado, normalization is a fundamental step in high-quality database design:

> "Normalization can be defined as the process of establishing the appropriate logical format for the data structures within a relational database's tables. Identified during the system's logical design phase, its objective is to minimize storage space and ensure the integrity and reliability of information."
> — **Machado, Felipe Nery Rodrigues (Database - Design and Implementation)**



### 1.2 Main Objectives

In the context of the **Flexempresta** system, we normalize to achieve three critical goals:

1.  **Eliminate Data Redundancy:** Ensuring that the same information (such as a customer's address or a branch's phone number) is not stored in multiple tables unnecessarily.
2.  **Ensure Integrity:** Creating a "single source of truth" where an update in one record is automatically reflected across all related data.
3.  **Optimize Performance:** Reducing storage waste and preparing the model for scalability, allowing the system to grow without losing speed or reliability.

---

## 2. The Importance of Data Normalization

Normalization is the process of organizing fields and tables to eliminate redundancy and ensure that every piece of data is in its correct place. In the context of the **Flexempresta** project, it transforms a simple "flat file" into a professional database system.

### 2.1 Key Benefits Summary

* **Reduces Redundancy:** Less duplicated data means less storage waste and simplified management.
* **Prevents Anomalies:** Protects the database against errors during Insertion, Update, and Deletion operations.
* **Improves Data Integrity:** Establishes logical rules to prevent incorrect or invalid data entry.
* **Optimizes Performance:** Smaller, focused tables result in faster queries and easier scalability.
* **Regulatory Compliance:** Ensures data accuracy and security, which is essential for financial projects.



### 2.2 The Problem: Data Redundancy and Anomalies (0NF)

Before normalization, data is often stored in a single, large table (often called a "Flat File"). This structure leads to several issues that compromise the database's health. Below is an example of an **Unnormalized Table (0NF)**:

| id_student | name_student | id_course | name_course | instructor_name | grade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Ana Silva | 101 | Mathematics | João Santos | 85 |
| 1 | Ana Silva | 102 | History | Maria Pereira | 90 |
| 2 | Carlos Andrade | 101 | Mathematics | João Santos | 88 |

### 2.3 Why is this a problem?

Looking at the example above, we can identify several risks known as **Database Anomalies**:

* **Data Redundancy:** The name "Ana Silva" and the course "Mathematics" are stored multiple times. If Ana changes her name, we must update it in every row, or the data will become inconsistent.
* **Insertion Anomalies:** We cannot register a new course (e.g., "Physics") unless we have at least one student enrolled in it, because the table structure requires student data to exist.
* **Update Anomalies:** If Professor "João Santos" changes his name or leaves, we must search and update every single row where he appears. A single missed row creates a data conflict.
* **Deletion Anomalies:** If "Carlos Andrade" drops out and we delete his row, we accidentally lose all information about course 101 ("Mathematics" and "João Santos"), as he was the only link to that data in this specific record.

---

## 3. Foundations of Normalization

To move from a disorganized state (0NF) to a structured database, we rely on three pillars: Functional Dependencies, Formal Rules (Normal Forms), and Design Guidelines.

### 3.1 Functional Dependencies: "Who defines whom?"
This is the core concept of normalization. A functional dependency occurs when one attribute uniquely determines another.

* **Example:** In our system, the **CPF** (or `id_customer`) functionally determines the **Name**. If you have the ID, you can find exactly one specific name.
* **Why it matters:** Understanding these relationships helps us decide which data belongs in which table. If a piece of data doesn't depend on the table's primary key, it should probably be moved.



### 3.2 The Normal Forms (The Step-by-Step Checklist)
Normalization is a progressive process. Each "Normal Form" is a level of quality that builds upon the previous one:

1.  **1st Normal Form (1NF):** Focuses on atomicity (no multiple values in a single cell).
2.  **2nd Normal Form (2NF):** Focuses on removing partial dependencies.
3.  **3rd Normal Form (3NF):** Focuses on removing transitive dependencies (attributes that depend on other non-key attributes).

> **Goal:** To reach the 3rd Normal Form (3NF), which is the industry standard for a healthy relational database.



### 3.3 Informal Design Guidelines (The "Best Practices")
Beyond the mathematical rules, we follow professional guidelines to ensure the model is intuitive:

* **Clear Semantics:** Tables should be easy to explain and reflect real-world concepts (e.g., a "Loans" table should only contain loan data).
* **Avoid NULLs:** We design tables to minimize empty fields, which simplifies queries and saves space.
* **Reduce Redundancy:** We ensure information isn't scattered or repeated unnecessarily, making updates safer and faster.
* **Avoid Spurious Tuples:** We ensure that when we join tables, the resulting information is valid and meaningful, not "ghost data" created by poor connections.

### 3.4 Study Case: Analyzing a Flat File (Sales Record)

I was challenged to identify the structural flaws in a single-table sales record where Customer, Book, and Employee data are merged.

**The Original Data (Unnormalized Form - 0NF):**

| VendaID | ClienteID | NomeCliente | EndereçoCliente | LivroID | TítuloLivro | AutorLivro | ColaboradorID | NomeColaborador | DataVenda |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 001 | 1001 | Ana Silva | Rua das Flores, 10 | 501 | O Alquimista | Paulo Coelho | 201 | João Pedro | 2024-06-01 |
| 002 | 1002 | Marco Antônio | Av. Brasil, 25 | 502 | A Bruxa de Portobello | Paulo Coelho | 202 | Maria Clara | 2024-06-02 |
| 003 | 1001 | Ana Silva | Rua das Flores, 10 | 503 | O Pequeno Príncipe | A. Saint-Exupéry | 201 | João Pedro | 2024-06-03 |

**Identified Structural Issues:**

* **Redundancy:** Customer addresses and employee names are repeated. "Ana Silva" and her address appear multiple times, wasting space and increasing the risk of data mismatch.
* **Update Anomalies:** If "Ana Silva" moves, we must update every single sale record. If one row is missed, the database will provide conflicting information about her location.
* **Deletion Anomalies:** If we delete the sale `002`, we lose all record of "Marco Antônio" and the fact that "A Bruxa de Portobello" exists in our inventory, as they only exist within that transaction.
* **Insertion Anomalies:** We cannot add a new book to our catalog or hire a new employee until a sale occurs. The database structure "forces" a transaction to exist for any entity to be registered.

**Proposed Solution:** Decompose the flat file into four specialized tables linked by **Foreign Keys**: 
1. `TB_Sales` (The Transaction)
2. `TB_Customers` (Personal Data)
3. `TB_Employees` (Staff Data)
4. `TB_Books` (Product Catalog)