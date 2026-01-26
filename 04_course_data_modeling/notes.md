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

