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