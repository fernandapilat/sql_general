# Normalization

## 1. Introduction
Normalization is the process of refining a database's structure to ensure it is efficient, reliable, and professional. By applying rules known as **Normal Forms**, we transform disorganized data into a robust relational system.

### 1.1 Core Concept
According to Felipe Machado, normalization is fundamental for high-quality design:
> "Normalization establishes the appropriate logical format for data structures... its objective is to minimize storage space and ensure the integrity and reliability of information."
> — **Machado, Felipe Nery Rodrigues**

### 1.2 Main Objectives for Flexempresta
1.  **Eliminate Redundancy:** No storing the same info in multiple places.
2.  **Ensure Integrity:** Create a "single source of truth."
3.  **Optimize Performance:** Prepare the model for scalability and speed.

---

## 2. The Problem: Unnormalized Data (0NF)
Before normalization, data is often trapped in a "Flat File"—a single, massive table. This leads to **Database Anomalies** that compromise the system's health and the reliability of **CRUD** operations (**C**reate, **R**ead, **U**pdate, **D**elete).

### 2.1 Study Case: Analyzing a Sales Flat File
Below is an example of an **Unnormalized Table (0NF)** used in our initial analysis:

| VendaID | ClienteID | NomeCliente | EndereçoCliente | LivroID | TítuloLivro | AutorLivro | ColaboradorID | NomeColaborador | DataVenda |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 001 | 1001 | Ana Silva | Rua das Flores, 10 | 501 | O Alquimista | Paulo Coelho | 201 | João Pedro | 2024-06-01 |
| 002 | 1002 | Marco Antônio | Av. Brasil, 25 | 502 | A Bruxa de Portobello | Paulo Coelho | 202 | Maria Clara | 2024-06-02 |
| 003 | 1001 | Ana Silva | Rua das Flores, 10 | 503 | O Pequeno Príncipe | A. Saint-Exupéry | 201 | João Pedro | 2024-06-03 |

### 2.2 Why this fails (Anomalies)
* **Redundancy:** Customer names and addresses are repeated. This wastes storage and increases the risk of data mismatch.
* **Update Anomaly:** If a customer moves, we must update every single row. Missing one row creates an inconsistency.
* **Insertion Anomaly:** We cannot catalog a new book unless a sale occurs, as the table structure forces a transaction ID.
* **Deletion Anomaly:** Deleting a sale record might accidentally erase the only record of a specific book or customer from the system.

---

## 3. Foundations of Normalization

### 3.1 Functional Dependencies
This is the "Who defines whom?" rule. A functional dependency occurs when one attribute uniquely determines another.
* **Example:** In our system, `id_customer` functionally determines the `Name`. Understanding this helps us decide which data belongs in which table.

### 3.2 The Normal Forms (The Checklist)
Normalization is progressive; each level builds upon the last:
1.  **1st Normal Form (1NF):** Focuses on **Atomicity** (one value per cell) and removing repeating groups.
2.  **2nd Normal Form (2NF):** Focuses on removing partial dependencies.
3.  **3rd Normal Form (3NF):** Focuses on removing transitive dependencies.



### 3.3 Informal Design Guidelines
Beyond formal rules, we follow best practices:
* **Clear Semantics:** Tables should reflect real-world concepts.
* **Avoid NULLs:** Minimize empty fields to simplify queries.
* **Avoid Spurious Tuples:** Ensure that table joins don't create "ghost" or invalid data.

---

## 4. Path to 1st Normal Form (1NF)
To achieve 1NF, we must ensure **Atomicity**—each column must contain a single, indivisible value.

### 4.1 Decomposing Composite Attributes (Address)
* **Problem:** Storing a full address in one field makes it impossible to filter by city or state efficiently.
* **Solution:** Breaking it into atomic fields: `street_name`, `house_number`, `city`, `state_uf`, and `zip_code`.



### 4.2 Handling Multivalued Attributes (Phone Numbers)
* **Problem:** A customer with multiple phone numbers stored in a single cell violates atomicity.
* **Solution:** Removing the "Phone" field from the main table and creating a dedicated table:
    * **Table `customer_phones`**: Contains `phone_id` (PK), `phone_number`, and `customer_id` (FK).


