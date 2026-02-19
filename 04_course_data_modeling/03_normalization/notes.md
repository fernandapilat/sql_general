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
To achieve 1NF, we must ensure **Atomicity** - each column must contain a single, indivisible value.

### 4.1 Decomposing Composite Attributes (Address)
* **Problem:** Storing a full address in one field makes it impossible to filter by city or state efficiently.
* **Solution:** Breaking it into atomic fields: `street_name`, `house_number`, `city`, `state_uf`, and `zip_code`.



### 4.2 Handling Multivalued Attributes (Phone Numbers)
* **Problem:** A customer with multiple phone numbers stored in a single cell violates atomicity.
* **Solution:** Removing the "Phone" field from the main table and creating a dedicated table:
    * **Table `customer_phones`**: Contains `phone_id` (PK), `phone_number`, and `customer_id` (FK).

---

## 5. Study Case: Multivalued Attributes (Clients & Suppliers)

In this scenario, I analyzed a table named `ClientesFornecedores` that violated the **1st Normal Form (1NF)** by storing multiple values (emails and phones) in a single cell.

### 5.1 The Problem: Unnormalized Form (0NF)
The table below shows how data was originally stored. Notice the comma-separated values, which make filtering and searching impossible.

| ID | Nome | Emails | Telefones | Tipo |
| :--- | :--- | :--- | :--- | :--- |
| 01 | Alpha Co | alpha@ex.com, beta@ex.com | 123456, 987654 | Fornecedor |
| 02 | Beta Inc | beta_inc@ex.com | 123123 | Cliente |
| 03 | Gamma LLC | gamma@ex.com, delta@ex.com | 222333, 444555 | Cliente |

---

### 5.2 The 1NF Solution: Atomic Tables
To solve this, I decomposed the multivalued attributes into separate, specialized tables linked by **Foreign Keys (FK)**. This ensures that every cell contains only one value (Atomicity).

#### Table A: `entities` (Main Data)
| id (PK) | name | type |
| :--- | :--- | :--- |
| 01 | Alpha Co | Supplier |
| 02 | Beta Inc | Client |
| 03 | Gamma LLC | Client |

#### Table B: `entity_emails` (Atomic Emails)
| email_id (PK) | email_address | entity_id (FK) |
| :--- | :--- | :--- |
| 1 | alpha@ex.com | 01 |
| 2 | beta@ex.com | 01 |
| 3 | beta_inc@ex.com | 02 |
| 4 | gamma@ex.com | 03 |
| 5 | delta@ex.com | 03 |

#### Table C: `entity_phones` (Atomic Phones)
| phone_id (PK) | phone_number | entity_id (FK) |
| :--- | :--- | :--- |
| 1 | 123456 | 01 |
| 2 | 987654 | 01 |
| 3 | 123123 | 02 |
| 4 | 222333 | 03 |
| 5 | 444555 | 03 |


---
> **Technical Note - Analytics Optimization:** 
> While normalization is essential for data integrity, analytics teams often require a "denormalized" view for dashboarding. Instead of compromising the database structure, we create a **View**. 
> This virtual table performs the necessary joins (joining `entities`, `emails`, and `phones`) on the fly, providing a flat structure without duplicating physical data.

## 6. Second Normal Form (2NF): Handling Composite Keys

The Second Normal Form (2NF) is applied to tables that use a **Composite Primary Key** (a key formed by two or more columns). Its goal is to ensure that every non-key attribute depends on the **entire** composite key, not just a part of it.

### 6.1 Practical Case: Bank Account Owners
In the **Flexempresta** system, we have a relationship where a customer can own multiple accounts, and an account can have multiple owners (a Many-to-Many relationship). This is managed by an associative table: `TableAccountOwners`.

**The Refactoring Process:**
Initially, the junction table might be tempted to store descriptive fields for convenience. However, I refactored the model to comply with 2NF:

* **Composite Key:** `id_customer` + `id_account`.
* **Action Taken:** I removed the `customer_name` and `account_type` fields from this table.
* **Reasoning:** * `customer_name` depends only on `id_customer` (Partial Dependency).
    * `account_type` depends only on `id_account` (Partial Dependency).

### 6.2 Benefits of this Structure
By removing these fields, the `TableAccountOwners` table now serves its true purpose: **linking entities**. 

1.  **Eliminates Redundancy:** We no longer store the customer's name multiple times if they have multiple accounts.
2.  **Prevents Update Anomalies:** If a customer changes their name, we only update it in the `TableCustomers` table, and the change is reflected everywhere through the relationship.
3.  **Data Integrity:** The table now contains only the necessary Foreign Keys (FKs) to maintain the relationship, ensuring a lean and professional schema.

![alt text](New_TableAcoountOwners.png)

### 6.3 Case Study: Courses and Materials (2NF Application)

In this scenario, I analyzed a table that linked Courses, Professors, and Teaching Materials.

#### The Problem: Unnormalized Form (0NF/1NF)
The original table suffered from partial dependencies. Data about professors and materials was repeated for every entry, creating redundancy.

| course_id | course_name | professor_id | professor_name | material_id | material_description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 001 | English | 101 | Maria Silva | M01 | Grammar Book |
| 001 | English | 101 | Maria Silva | M02 | Vocabulary Book |
| 002 | French | 102 | João Pereira | M03 | Exercise Book |

**2NF Analysis:** - `professor_name` depends only on `professor_id`.
- `material_description` depends only on `material_id`.
- Storing them together forced unnecessary repetitions of professor names whenever a new material was added.

---

#### The 2NF Solution: 3-Table Decomposition

I reorganized the schema into three tables to ensure that every non-key attribute depends entirely on its primary key.

**1. Table `professors`**
| professor_id (PK) | professor_name |
| :--- | :--- |
| 101 | Maria Silva |
| 102 | João Pereira |

**2. Table `courses`**
| course_id (PK) | course_name | professor_id (FK) |
| :--- | :--- | :--- |
| 001 | English | 101 |
| 002 | French | 102 |



**3. Table `course_materials`**
| material_id (PK) | course_id (FK) | material_description |
| :--- | :--- | :--- |
| M01 | 001 | Grammar Book |
| M02 | 001 | Vocabulary Book |
| M03 | 002 | Exercise Book |


**Conclusion:** This 3-table structure eliminates partial dependencies. Now, if we update a professor's name, it happens in one row. If a course changes its professor, we only update the `professor_id` in the `courses` table.