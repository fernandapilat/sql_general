# Physical Data Model

## 1. Target DBMS: MySQL
For this project, the chosen platform is **MySQL**, a leading relational database management system (RDBMS).

* **Open Source Solution:** It is a highly attractive option for organizations due to the absence of licensing fees, offering professional-grade features with high cost-efficiency.
* **Performance and Reliability:** It serves as a robust environment for translating Relational Algebra into high-speed data processing and storage.

---

## 2. Modeling Dictionary (Nomenclature Transition)
To bridge the gap between theoretical design and physical implementation, the following nomenclature mapping will be applied:

| Conceptual / Logical Model | **Physical Model (MySQL)** |
| :--- | :--- |
| Entity | **Table** |
| Attribute | **Column** |
| Tuple / Record | **Row** |
| Primary Key | **Primary Key (PK)** |
| Foreign Key | **Foreign Key (FK)** |
| Business Rule | **Constraints / Triggers** |

---

## 3. Data Types Mapping
Selecting the correct data type is critical for storage optimization and query performance. In MySQL, we translate our logical attributes into specific physical types:

### 3.1 Numeric Types
* **INTEGER:** Used for whole numbers. We choose between `TINYINT`, `SMALLINT`, `INT`, or `BIGINT` depending on the required range (e.g., `TINYINT` for small ages, `BIGINT` for global transaction IDs).
* **DECIMAL / NUMERIC:** Used for exact fixed-point values. **Mandatory for financial data** to avoid rounding errors.
* **FLOAT / DOUBLE:** For floating-point numbers where scientific precision is needed but slight imprecision is acceptable.

### 3.2 String Types (Text)
* **CHAR:** Fixed-length strings. Ideal for data with consistent sizes (e.g., State Codes like 'SP' or 'RJ').
* **VARCHAR:** Variable-length strings. The standard choice for names, emails, and most text-based attributes.
* **TEXT:** Used for large blocks of data (e.g., descriptions or logs), available in sizes from `TINYTEXT` to `LONGTEXT`.



### 3.3 Date and Time Types
* **DATE:** For dates without time (`YYYY-MM-DD`).
* **TIME:** For time without date (`HH:MM:SS`).
* **DATETIME / TIMESTAMP:** For combining both. `TIMESTAMP` is frequently used for "Created At" or "Updated At" record tracking.

### 3.4 Logical and Spatial Types
* **BOOLEAN:** In MySQL, this is an alias for `TINYINT(1)`. It stores `0` for **False** and `1` for **True**.
* **SPATIAL (GEOMETRY/POINT):** Used for geographic coordinates and GPS data.

---

## 4. Keys vs. Indexes: The Pillar of Physical Modeling
Understanding the distinction between keys and indexes is vital for balancing **data integrity** (reliability) and **query performance** (speed).

### 4.1 Why is it important to learn the difference?
* **Integrity (Keys):** Prevents duplicate data and ensures that relationships between tables (like a Customer and their Orders) never break.
* **Performance (Indexes):** Allows the database to find a single record among millions in milliseconds.
* **Cost of Maintenance:** Every index adds a small "cost" to write operations (`INSERT`, `UPDATE`), so we must design them strategically.

### 4.2 Deep Dive into Key Types (Examples)
Using a standard **Customers Table**, we can categorize keys based on their role in the physical design:

| Key Type | Description | Practical Example (Customer Table) |
| :--- | :--- | :--- |
| **Candidate Key** | Any unique column that could be the PK. | `id_customer`, `CPF`, and `Email`. |
| **Primary Key (PK)** | The chosen main identifier for the table. | `id_customer` (chosen for performance). |
| **Alternative Key** | A candidate key NOT chosen as the PK. | `CPF` and `Email` (marked as `UNIQUE`). |
| **Foreign Key (FK)** | A link to a PK in another table. | `id_city` pointing to the `Cities` table. |
| **Composite Key** | A key made of two or more columns. | `(area_code + phone_number)` to ensure uniqueness. |



### 4.3 Fundamental Differences

| Feature | **Keys** | **Indexes** |
| :--- | :--- | :--- |
| **Main Goal** | Enforce Business Rules & Integrity. | Optimize Data Retrieval Speed. |
| **Implementation** | Logic/Constraint (`NOT NULL`, `UNIQUE`). | Physical Data Structure (B-Tree). |
| **Write Impact** | Minimal (checks for violations). | Can slow down writes (updates index files). |

### 4.4 Practical Comparison (SQL Implementation)

| SQL Command | Type | Purpose | Behavior |
| :--- | :--- | :--- | :--- |
| `PRIMARY KEY` | **Key + Index** | Identity & Integrity | Prohibits duplicates and NULLs; creates a fast map. |
| `UNIQUE` | **Key + Index** | Business Rule | Prohibits duplicates (Alternative Key). |
| `CREATE INDEX` | **Index ONLY** | Performance | Does NOT enforce rules (unless unique), just speeds up `SELECT`. |

**Why not use only Indexes?**
If we use only a non-unique index on CPF, the database would find the data quickly but would **allow** two people to have the same CPF, destroying our data integrity. **Keys are for Rules; Indexes are for Speed.**

### 4.5 The "Price" of Performance: Index Maintenance

As a Data Analyst, it's crucial to understand that indexes are not "free." They follow a **Trade-off Principle**:

* **Benefit (SELECT):** Drastic reduction in query time (seconds to milliseconds).
* **Cost (INSERT/UPDATE/DELETE):** Increased processing time. The DBMS must keep the index sorted every time a record is added, modified, or removed.

**Analyst's Takeaway:** * **Read-heavy systems** (like an E-commerce or BI Dashboard): Use many indexes to speed up searches.
* **Write-heavy systems** (like Log trackers or Sensor data): Use minimal indexes to avoid "choking" the database during data ingestion.

---

## 5. Integrity Constraints: Ensuring Data Quality
Integrity constraints are a set of rules enforced by the DBMS to prevent accidental damage to the database, ensuring that data remains accurate and reliable.

### 5.1 Entity Integrity (Primary Keys)
* **Rule:** Every table must have a **Primary Key**, and it **cannot be NULL**.
* **Goal:** Ensures that every row (record) can be uniquely identified.

### 5.2 Referential Integrity (Foreign Keys)
* **Rule:** A **Foreign Key (FK)** must always point to a valid, existing **Primary Key (PK)** in another table.
* **Goal:** Prevents "orphan records" (e.g., an Order that belongs to a non-existent Customer).
* **Actions:** * `ON DELETE CASCADE`: If the parent is deleted, all children are deleted automatically.
    * `ON DELETE RESTRICT`: Prevents deletion of the parent if children exist.

### 5.3 Domain Integrity (Data Validation)
* **NOT NULL:** Forces a column to always have a value (e.g., Name is mandatory).
* **UNIQUE:** Prevents duplicates but is not the main PK (e.g., Email or CPF).
* **CHECK:** Validates if the data follows a logical expression (e.g., `Price > 0`).
* **DEFAULT:** Automatically fills the column with a value if none is provided.



---

## 6. Practical Physical Implementation (SQL Script)
This script combines everything: Data Types, Keys, Indexes, and Integrity Constraints.

```sql
-- Creating the "Cities" table first (The Parent Table)
CREATE TABLE cities (
    id_city INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(100) NOT NULL,
    state_code CHAR(2) NOT NULL
);

-- Creating the "Customers" table (The Child Table)
CREATE TABLE customers (
    id_customer INT AUTO_INCREMENT,      -- PK: Identity
    cpf VARCHAR(11) NOT NULL,            -- Candidate/Alternative Key
    name VARCHAR(100) NOT NULL,          -- NOT NULL: Mandatory field
    email VARCHAR(100),
    age INT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- DEFAULT: Auto-fill
    id_city INT,                         -- Field for the Foreign Key
    
    -- Defining Integrity Rules (Constraints)
    PRIMARY KEY (id_customer),           -- Entity Integrity
    UNIQUE (cpf),                        -- Uniqueness (Key/Index)
    UNIQUE (email),                      -- Alternative Key
    
    -- Referential Integrity: Linking to Cities
    CONSTRAINT fk_customer_city 
        FOREIGN KEY (id_city) REFERENCES cities(id_city)
        ON DELETE RESTRICT,              -- Safety: Can't delete city with active customers
        
    -- Domain Integrity: Logical Validations
    CONSTRAINT check_age CHECK (age >= 18)
);

-- Performance Optimization (Secondary Index)
-- Speed up searches by Name without enforcing a uniqueness rule
CREATE INDEX idx_customer_name ON customers (name);
```