# E-Commerce Sales SQL Project

This project is a comprehensive analysis of a sample e-commerce database. It includes the complete database schema (DDL), all sample data (DML), and a wide range of analytical SQL queries.

The project demonstrates SQL skills progressing from basic data retrieval to complex analysis involving joins, subqueries, and aggregations.

## 📊 Database Schema (ER Diagram)

The database consists of 6 tables designed to model a simple e-commerce business:

* **customers**: Stores customer information.
* **products**: Stores product catalog details.
* **orders**: Stores order header information linked to customers.
* **order_items**: The junction table linking orders and products.
* **payments**: Stores transaction data linked to orders.
* **product_reviews**: Stores customer reviews for products.

![E-Commerce Database ER Diagram](er_diagram.png)

## 🚀 How to Run This Project

1.  **Create the Database:** Run the entire `1_schema_and_data.sql` file in your MySQL environment (like MySQL Workbench). This single file will:
    * Create the `jagadeesh` database.
    * Create all 6 tables with their keys and constraints.
    * Insert all 400 orders, 50 products, 30 customers, and associated sample data.

2.  **Run the Analysis:** Open and run the queries in the `2_analysis_queries.sql` file. You can run these one by one to see the results for each business question.

## 🗂 Project File Contents

* **`1_schema_and_data.sql`**: Contains all the `CREATE TABLE` (DDL) and `INSERT INTO` (DML) statements required to build and populate the entire database from scratch.
* **`2_analysis_queries.sql`**: Contains over 30 analytical queries that answer specific business questions. The queries are structured in 6 levels:
    * **Level 1**: Basic `SELECT`, `WHERE`, and `ORDER BY`.
    * **Level 2**: Filtering with `LIKE`, `IN`, `BETWEEN`, and `IS NULL`.
    * **Level 3**: Aggregations using `COUNT`, `SUM`, `AVG`, and `GROUP BY`.
    * **Level 4**: Multi-table queries using `INNER JOIN` and `LEFT JOIN`.
    * **Level 5**: Advanced queries using Subqueries (scalar, column, and correlated).
    * **Level 6**: Set operations using `UNION` and `EXISTS`.
* **`er_diagram.png`**: The entity-relationship diagram for the database.
* **`workbench_model.mwb`**: The MySQL Workbench model file used to create the ER diagram.