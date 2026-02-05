# Logical Modeling

## 1. What is a Logical Model?
The logical model is a structured representation of how data will be organized in a database. It serves as an intermediary between the abstract business needs (Conceptual Model) and the technical implementation (Physical Model).

* **Entities:** Represent real-world objects or concepts (e.g., Book, User) that become **Tables**.
* **Attributes:** Characteristics that describe an entity (e.g., Title, Email) that become **Columns**.
* **Goal:** To translate business requirements into an organized structure that ensures data efficiency and consistency.

---

## 2. Transition: From Conceptual to Logical
The transition is the process of moving from high-level ideas to a technical blueprint. This stage is essential for:
* **Defining Data Types:** Specifying if a field is an Integer, String, or Date.
* **Key Identification:** Formally establishing the **Primary Key (PK)** and **Foreign Keys (FK)**.
* **Implementation Readiness:** Creating a precise map that guides the Physical Model (SQL).

---

## 3. Naming Conventions and Ambiguity
When designing tables, it is common to find entities with similar attributes (e.g., `name`, `email`). In the Logical Model, naming these columns uniquely is a best practice to avoid confusion during future database queries.

### 3.1 Case Study: Employees vs. Customers
Using specific identifiers prevents ambiguity when tables are joined:

| Table | Generic Attribute | Recommended Logical Name | Reason |
| :--- | :--- | :--- | :--- |
| **Employees** | `name` | `name_employee` | Distinguishes staff from customers in reports. |
| **Customers** | `name` | `name_customer` | Ensures clarity for sales and marketing data. |
| **Employees** | `email` | `email_employee` | Prevents errors in internal communications. |

### 3.2 Benefits of Precise Naming
* **SQL Clarity:** Instant recognition of which entity a column belongs to.
* **Error Prevention:** Reduces risks during data updates or deletions.
* **Self-Documenting:** The database structure becomes easier for the team to understand.