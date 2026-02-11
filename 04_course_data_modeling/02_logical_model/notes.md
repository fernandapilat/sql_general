# Logical Modeling & Implementation

## 1. What is a Logical Model?
> "The logical model describes, in format, the structures that will be in the database according to the possibilities permitted by its approach, but without yet considering any specific characteristics of a Database Management System (DBMS)." 
> — **Machado, Felipe Nery Rodrigues**

The logical model serves as the technical blueprint. It translates abstract business needs (Conceptual) into an organized structure that ensures data efficiency and consistency before the final implementation (Physical).

* **Entities:** Represent real-world objects (e.g., Book, User) that become **Tables**.
* **Attributes:** Characteristics (e.g., Title, Email) that become **Columns**.

---

## 2. From Concept to Practice: Transition & Naming
Transitioning to a logical model requires defining data types and establishing clear identifiers. A critical part of this is avoiding **ambiguity**.

### 2.1 Case Study: Employees vs. Customers
When joining tables, generic names like `name` or `email` can cause confusion. Best practice suggests unique naming:

| Table | Attribute | Recommended Logical Name | Reason |
| :--- | :--- | :--- | :--- |
| **Employees** | `name` | `name_employee` | Distinguishes staff from customers in reports. |
| **Customers** | `name` | `name_customer` | Ensures clarity for sales and marketing data. |

**Benefits:** Instant SQL clarity, error prevention during updates, and a self-documenting structure.

---

## 3. Data Integrity: Primary Keys (PK) & Surrogate Keys
A **Primary Key (PK)** is the anchor of relational structure. According to Machado, a well-defined PK ensures that every record is uniquely identifiable.

* **Uniqueness:** No two rows can share the same PK.
* **Non-Nullability:** A PK field can never be empty (null).
* **Immutability:** Its value should ideally never change.

**My Implementation:** In the **Flexempresta** project, I use **UniqueID** as a *Surrogate Key*. This ensures data identity is independent of business values (like CPFs) that might change.

---

## 4. Implementation in Power BI & Power Query
When applying the Logical Model to tools like Power BI (via Power Query), the theory meets the "real world" of data transformation.

### 4.1 Data Transformation (ETL)
Power Query acts as the engine to enforce the rules defined in the Logical Model:
* **Handling Nulls:** To maintain integrity, rows with `null` values in PK columns are filtered out. This prevents "orphan" records and ensures that every row represents a valid business entity.
* **Data Typing:** Power Query allows us to explicitly define whether a field is an Integer, Decimal, or Text, ensuring the **Implementation Readiness** mentioned in Section 2.
* **Schema Validation:** We ensure that each imported sheet (Entity) follows the attributes and naming conventions defined in our Data Dictionary.

### 4.2 Simulating Relationships
While spreadsheets don't have native "enforced" Foreign Keys (FK), we simulate them in Power BI by linking IDs between tables (e.g., linking `id_customer` in the Loans table to the `UniqueID` in the Customers table).

---

## 5. The Data Dictionary: The Source of Truth
As the model grows, the **Data Dictionary** prevents the validation from becoming a "monologue of analysts" (Machado).

* **Consistency:** Developers and users share the same field definitions.
* **Scalability:** Provides a clear map for migrating from spreadsheets to a robust SQL database in the future.
* **Efficiency:** Speeds up maintenance and prevents information silos.

> **Pro-Tip:** A well-documented model in Power BI, supported by a clear Data Dictionary, ensures the long-term robustness of the **Flexempresta** project.

![alt text](<Data Logical Model - PBI.png>)
