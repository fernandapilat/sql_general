# Study Notes

## MER vs. DER
In data modeling, it is common to confuse these two terms, but they represent different levels of a project: the **methodology** and the **visualization**.

---

## 1. MER (Entity-Relationship Model)
The **MER** is the **conceptual framework** or the "set of rules."

* **What it is:** A high-level theoretical model used to describe the data structures and business rules of a system.
* **Analogy with BPM:** It is like the **BPMN standard**. It defines *how* a process should be mapped (using tasks, gateways, events), but it is not the map itself.
* **Focus:** It focuses on the logic, the constraints, and the "how-to" of modeling.

## 2. DER (Entity-Relationship Diagram)
The **DER** is the **visual representation** or the "drawing."

* **What it is:** The graphic tool used to display the entities, attributes, and relationships defined by the MER.
* **Analogy with BPM:** It is the **Flowchart** itself. It is the final drawing you deliver to show how the process flows.
* **Focus:** It uses geometric shapes (Rectangles for Entities, Rhombuses for Relationships, Ellipses for Attributes) to provide a clear view of the data architecture.

---

## The Workflow
A database engineer follows this logical sequence:
1. **Mini-world:** Understands the "story" (the business process).
2. **MER:** Applies the "rules" of modeling to that story.
3. **DER:** Creates the "diagram" (the visual blueprint).

---

## Tooling: Visual Paradigm

The [**Visual Paradigm**](https://www.visual-paradigm.com/) is a professional CASE (Computer-Aided Software Engineering) tool used to create various types of diagrams.

* **ERD Tool:** Used to draw the **DER** (Entity-Relationship Diagram). Can be the Visual Paradigm or others, such as: ERwin, Microsoft Visio and Lucidchart.

---

## 3. Requirement Elicitation
**Requirement Elicitation** is the critical process of identifying exactly **what** needs to be built before the technical development begins. It acts as the blueprint for the project, ensuring the final database architecture aligns with business needs and prevents costly misunderstandings.

### Main Techniques
A database engineer uses a combination of techniques to transform the **Mini-world** (real-world business process) into data requirements:

* **Interviews:** Direct communication with stakeholders and users to uncover expectations through open-ended questions.
* **Questionnaires:** A structured method to collect data from a large group of people efficiently (requires clear questions and a pilot test).
* **Direct Observation:** Watching users perform their daily activities to identify "hidden" needs that they might forget to mention during an interview.

### Why It Matters
* **Eliminating Rework:** Identifying the correct requirements early saves time, money, and effort by avoiding late-stage changes.
* **Clear Communication:** It establishes a common language between the business (stakeholders) and the technical team (engineers).
* **Strategic Foundation:** Understanding the "story" behind the data ensures the final product is truly useful for the end user.

### Professional Insight (BPM Connection)
For a **Business Process Analyst**, this stage is equivalent to the **As-Is mapping**. While BPM focuses on the *flow* of activities, Requirement Elicitation focuses on the *data* generated and consumed by those activities.

## 4. Entities: Strong vs. Weak
In data modeling, we transition from abstract concepts to physical implementation, classifying entities based on their independence.

### Concepts and Mapping:
* **Entity (Conceptual/Logical):** Represents a real-world object or category. It becomes a **Table** in the Physical Model.
* **Attribute:** Represents the characteristics of an entity. It becomes a **Column** in the table.

### 1. Strong Entity
* **Definition:** An entity that exists independently of others. It has its own unique identifier (Primary Key).
* **Graphic Representation:** A standard rectangle with a single border.
* **Example:** `Customer` or `Bank Account`.

### 2. Weak Entity
* **Definition:** An entity that depends on a "strong" entity to exist. It cannot be uniquely identified by its attributes alone.
* **Graphic Representation:** A rectangle with a double border.
* **Example:** `Payment` (depends on a `Loan`).

| Conceptual (Entity) | Physical (Table) |
| :--- | :--- |
| Entity | Table |
| Attribute | Column / Field |
| Identifier | Primary Key (PK) |
| Instance | Row / Record |

## 5. Relationships and Degrees
Relationships are the logical connections between entities, representing how they interact within the business process.

### 5.1 Relationship Degrees
The degree represents the number of entities involved in a single relationship:

* **Unary (Recursive):** When an entity relates to itself. 
    * *Example:* An **Employee** manages another **Employee**.
* **Binary:** The most common type, involving two entities. 
    * *Example:* A **Customer** requests a **Loan**.
* **Ternary:** Involves three entities simultaneously. 
    * *Example:* A **Sales Rep** sells a **Loan Product** to a **Customer**.

### 5.2 Cardinality
Defines the numerical constraints of the relationship (how many instances on one side connect to the other):

* **One-to-One (1:1):** One record relates to exactly one other record.
* **One-to-Many (1:N):** One record can relate to multiple records on the other side.
* **Many-to-Many (N:N):** Multiple records on both sides can be interconnected.

### 5.3 Relationship Verbs (Semantic Mapping)
Choosing the right verb is essential for "reading" the diagram. Based on our financial model:

* **Sales Reps -> [Manage] -> Customer:** Specific staff responsible for client accounts.
* **Customer -> [Holds] -> Bank Account:** The client is the legal owner of the account.
* **Customer -> [Requests] -> Loan:** The process of applying for credit.
* **Loan -> [Generates] -> Payments:** The debt structure that creates installments.

> **⚠️ Relationship Constraint:**
> * **Restriction:** The direct relationship **[Entity A] -[Belongs to]-> [Entity B]** is prohibited because it creates data redundancy, as the association is already established through **[Other Entity]**.

### 5.4 Associative Entities
An **Associative Entity** is a relationship that the modeler chooses to treat as an entity. It is primarily used to resolve **Many-to-Many (N:N)** relationships.

* **Purpose:** It "breaks" a many-to-many link into two one-to-many (1:N) relationships, allowing the system to store specific data about the interaction itself.
* **Attributes:** Unlike a simple relationship, an associative entity can have its own attributes (e.g., date, status, or a specific ID).
* **Visual Representation:** In a Crow's Foot or Chen diagram, it is often shown as a diamond inside a rectangle.

**Practical Example in Flexempresta:**
If we have many **Employees** participating in many **Training** sessions, we create an associative entity called **Enrollment**.
* **Why?** Because the "Date of Completion" or "Grade" doesn't belong to the Employee or the Training alone, but to the *connection* between them.