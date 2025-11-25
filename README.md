# sap_abap_object_oriented - Sales Order Reporting

## Objective
To develop a reusable ABAP Object-Oriented backend service for Sales Order reporting that retrieves Sales Order header and item data from SAP standard SD tables (**VBAK / VBAP**) and exposes the data to multiple reporting outputs without repeating SELECT logic.

---

## Business Problem
Custom SAP reports often duplicate SELECT logic to fetch Sales Order details from VBAK and VBAP.  
This leads to:
- Repeated code across programs
- Inconsistent validation logic
- Increased maintenance effort

A centralized solution was required to standardize Sales Order retrieval and support multiple reporting formats.

---

## Solution Summary
A complete OOP-based Sales Order reporting framework was built with the capability to:
1. Accept Sales Order number as input
2. Validate the input and handle missing/invalid data
3. Retrieve header and item details from **VBAK / VBAP**
4. Return formatted internal tables to reporting components
5. Display the result using:
   - **OOPS ALV (interactive ALV)**
   - **SALV (standard ALV)**
6. Optionally update Sales Order enhancement tables (**ZORDH_04 / ZORDIT_04**) through a persistent class

---

## Architecture Components

### Backend Service (OOP Framework)
| Component | Responsibility |
|----------|----------------|
| Interface | Declares mandatory operations for Sales Order retrieval |
| Abstract Class | Provides reusable logic and enforces structure |
| Concrete / Child Class | Performs actual SELECT on VBAK / VBAP |
| Constructor | Initializes required runtime attributes |
| Singleton | Ensures a single shared instance of the service |
| Exception Class | Handles invalid/missing Sales Order input |
| Event + Handler | Executes error workflow for validation failures |
| Persistent Class | Demonstrates safe COMMIT / ROLLBACK updates to ZORDH_04 & ZORDIT_04 (**only component that performs write to Database**) |

### Reporting Components
| Component | SAP Class Used | Output |
|----------|----------------|--------|
| OOPS ALV Report | `CL_GUI_ALV_GRID` | Interactive / editable ALV grid |
| SALV Report | `CL_GUI_SALV_TABLE` | Standard read-only ALV list |

Both reporting components call the backend class — **no reporting component executes its own SELECT statement**.

---

## Functional Flow
**Process Flow**
| Step | Action |
|------|--------|
| 1 | User enters Sales Order number |
| 2 | Singleton returns OOP service instance |
| 3 | Framework retrieves data from VBAK / VBAP |
| 4 | Validation performed |
| 5 | If valid → ALV / SALV reporting |
| 6 | If invalid → Event → Handler |
| 7 | Optional → Persistent Class updates ZORDH_04 / ZORDIT_04 |

---

## Usage Example
```abap
lo_obj = zcl_so_factory=>get_instance( ).

"Retrieve Sales Order data
ls_header = lo_obj->get_date( iv_vbeln = '0000004711' ).
lt_items  = lo_obj->get_pm( iv_vbeln = '0000004711' ).
```

---

## SAP Tables Used
| Purpose                | Tables                                                        |
| ---------------------- | ------------------------------------------------------------- |
| Read (Standard SAP SD) | **VBAK — Sales Order Header**<br>**VBAP — Sales Order Items** |

---

## Results and Reporting Output
The retrieved Sales Order header and item details can be displayed using:

- OOPS ALV grid (interactive)
- SALV list (read-only)

Because both reports consume the same backend OOP service, the logic is centralized, reusable, and maintenance-friendly.

---

## Outcome
This project demonstrates the application of ABAP OOP to solve a real Sales Order reporting scenario with:
- Clean separation between business logic and UI logic
- No duplicate SELECT statements across reports
- Consistent validation and error handling
- Reporting versatility using both OOPS ALV and SALV

---

## Repository Value
This repository is a single Sales Order Reporting project, not a collection of unrelated exercises.  
Every project-related folder contributes to the end-to-end working solution aligned with SAP development standards.

---

### Additional Learning Components in Repository
Apart from the main Sales Order Reporting framework, this repository also contains additional subfolders demonstrating individual ABAP OOP concepts, which were practiced while building the project. These include:

| Folder | Demonstrated Concept |
|--------|----------------------|
| `ME_keyword` | Use of `ME` reference inside class methods |
| `alias` | Method/attribute aliases for improved readability |
| `types` | Defining local TYPE structures inside classes |
| `usual class` | Basic class implementation for conceptual clarity |

These folders are not part of the execution flow of the Sales Order Reporting framework, but they reflect hands-on learning of ABAP OOP concepts during the development process.
