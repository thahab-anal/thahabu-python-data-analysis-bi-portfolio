# 📊 Superstore Sales - Beginner Power BI Project

## 🧠 Project Overview
This project is part of my **Data Analytics Portfolio** and demonstrates how to model, clean, and visualize data using **Microsoft Power BI**.  
The goal is to explore company sales data and uncover insights such as total revenue, profit distribution, and market performance.

---

## 📂 Source
**File:** `superstore data.csv`  
**Path:**  `thahabu-python-data-analysis-bi-portfolio/powerbi_portfolio_projects/superstore_sales_basic_level/`

---

## 🎯 Business Questions to Answer

1. What were the total sales for the company?  
2. Which market generated the most sales on average?  
3. What were the profits by segment, and which segment had the most profit?

---

## 🪄 Steps Followed

### 1️⃣ Data Import
- Imported the `superstore data.csv` dataset into **Power BI Desktop**.
---

### 2️⃣ Data Transformation (Power Query)
- Adjusted headers and cleaned the dataset.
- **Challenge:** Power BI’s default “Use First Row as Headers” only promotes the first row,  
  but here we needed to dynamically promote a *specific row* as headers.

#### 💡 Solution: Promote a Dynamic Header Row
```m
let
    Source = #"Changed Type",
    HeaderRowIndex = List.PositionOf(Table.Column(Source, "Column1"), "Order ID"),
    HeaderRow = Table.Range(#"Changed Type", 1, 1),
    HeaderList = Record.ToList(HeaderRow{0}),
    output = Table.RenameColumns(Source, List.Zip({Table.ColumnNames(Source), HeaderList}))
in
    output
```
🧹 Remove the Duplicate Header Row from Data
```m
let
    Source = #"Renamed Column Names",
    HeaderRowIndex = List.PositionOf(Table.Column(Source, "Order ID"), "Order ID"),
    Output = Table.RemoveRows(Source, HeaderRowIndex)
in
    Output
```
### 3️⃣ Data Modeling

Changed data types appropriately.

Created calculated columns:
Year = YEAR('Orders'[Order Date])
Month = FORMAT('Orders'[Order Date], "MMM")

Created DAX measures:
Total Sales = SUM('Orders'[Sales])
Net Profit 2016 = CALCULATE(SUM('Orders'[Profit]), YEAR('Orders'[Order Date]) = 2016)

### 4️⃣ Visualizations

Built an interactive Power BI report with the following visuals:

Visualization	Purpose
📈 Line Chart	Total Sales by Year
📊 Table	Category-wise Sales
🗺️ Map	Top 5 Countries by Average Sales
🥧 Pie Chart	Sales by Segment

### 5️⃣ 🧩 Key Learnings

How to make any row a header dynamically using Power Query M.

Cleaning, transforming, and modeling data efficiently.

Writing DAX calculated columns and measures.

Building visuals for storytelling and insights.

### 6️⃣ 🧰 Tools Used

Power BI Desktop

Power Query

DAX (Data Analysis Expressions)
