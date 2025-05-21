# 🍉 Bitter Melons: A Transparent Review Aggregator Database

Bitter Melons is an independent, SQL-based review aggregation system that redefines how film and TV reviews are collected, processed, and analyzed. Designed as a response to concerns over biased review platforms, it offers a fully normalized database schema, analytical views, and automated data migration tools.

## 🎯 Project Goals

- Provide an **unbiased review aggregation** platform free from content producer influence.
- Implement a scalable and **normalized relational database** (BCNF-compliant).
- Calculate custom metrics like the **Sweetness Index** for critics and audiences.
- Assign meaningful certifications: `🍯 HoneyDew`, `🛑 HoneyDon't`, `Sweet`, and `Sour`.
- Enable powerful analytics through **SQL views**, **procedures**, **functions**, and **triggers**.

## 🗂️ Features

- ✅ Normalized schema (BCNF) with comprehensive entity relationships
- 🍯 Sweetness index & melon certification system
- 🧠 Advanced SQL Views for analytics:
  - Compare critic vs. audience reception
  - Top-rated movies by genre
  - Most active critics
- ⚙️ Stored procedures and triggers:
  - Auto-linking movie metadata
  - Sweetness index & certification calculations
  - Migration logs and validation constraints
- 🚀 Automated data migration from source datasets (Rotten Tomatoes Kaggle dataset)

## 🧱 Tech Stack

- **Database**: MySQL
- **Source Data**: [Rotten Tomatoes Movies and Critic Reviews Dataset](https://www.kaggle.com/datasets/stefanoleone992/rotten-tomatoes-movies-and-critic-reviews-dataset)
- **Language**: SQL (DDL, DML, Views, Functions, Procedures, Triggers)

## 🖼️ ER Diagram (Simplified)
{}


## 📊 Example Queries

- Find critically acclaimed classics
- Identify critic-audience rating gaps
- Top genres by HoneyDew certifications
- Most active and influential critics

## 🚀 Setup & Usage

1. Clone this repository
2. Import the schema SQL file into MySQL
3. Run `CALL table_creation();` and `CALL master_table_insertions();`
4. Use `CALL migrate_movies_data();` to migrate movies data
5. Use and `CALL migrate_reviews_data_all(batch, size);` for data loading
6. Explore predefined views and test sample queries

## 📚 License & Acknowledgements

- Created by **Dharmik Vara** as part of MSc Computer Science coursework at University College Dublin.
- Special thanks to Stefano Leone for the dataset and Prof. Tony Veale for academic guidance.
- Licensed for educational and non-commercial use.

---

## 📬 Contact

For questions or collaborations, feel free to reach out via GitHub or email.

