Inventory Dashboard – ABC Analysis
Project Summary

This project provides a comprehensive view of inventory performance, including ABC classification, total stock analysis, vendor performance, and warranty tracking. It enables stakeholders to understand stock distribution, high-value items, vendor efficiency, and warranty compliance.

Source File

Files: inventory_master.csv, inventory_transaction.csv, vendor_data.csv, warranty_data.csv
Path: \thahabu-data-analytics\Inventory_Analysis

Tool Used: Power BI

🎯 Business Questions to Answer

Which items fall into A/B/C categories based on stock value and transaction volume?

How is the total stock distributed across categories and items?

Which items have active or expired warranties?

What actionable insights can improve inventory management and vendor decisions?

🪄 Steps Followed
Data Import and Transformation (Power Query)

Imported the datasets inventory_master.csv, inventory_transaction.csv, vendor_data.csv, warranty_data.csv.

Promoted headers and cleaned null values.

Standardized data types: ItemID as Text, Date columns as Date.

Removed duplicate rows and irrelevant data.


Data Modeling

Created Data Model view, By joining Fact tables like Inventory Master, Inventory Transactions, Warranty Tracking with Dimesnion tables Item, Vendor.
Created Date Table using Calendar function and created Year and Month columns to form hierarchy

Visualizations

KPI Cards: Total stock, In Stock ready to sell items, Obsolete inventory, ABC Class by transaction value, active/expired warranties, top vendors.

Bar/Column Charts: ABC classification by stock value and transaction volume.

Line Charts: Stock trends over time.

Pie Charts: To get the ABC trasaction Value

Tree Map and filter: To filter ABC items by Stock Value

scatter Chart: To get the correlation between Stock value and transaction value

Tables: Item-level details by category and location

Key Learnings

Implemented ABC analysis using DAX.

Tools Used

Power BI Desktop

Power Query

DAX (Data Analysis Expressions)

Key DAX Measures

ABC Classification by Stock Value

ABC_Stock = 
SWITCH(
    TRUE(),
    [Cumulative_Stock_Value] <= 0.8, "A - High Value Stock",
    [Cumulative_Stock_Value] <= 0.95, "B - Medium Value Stock",
    "C - Low Value Stock"
)


Total Stock

Total_Stock = SUM(inventory_master[CurrentStock])

High Value Obsolete Items

High Value Obsolete Items = 
VAR Filtered = FILTER(
        ALL(inventory_master),
        [ABC Class by Stock]="A - High Value Stock"
       
    )
RETURN
    CALCULATE(
        COUNTROWS(
        inventory_master),
        FILTER(Filtered,
        inventory_master[Status]="Obsolete")
    )


Cumulative Transaction %

Cumulative Transaction % = 
VAR Numerator = [Cumulative Transaction Value]
VAR Denominator = CALCULATE([Transaction Item Value],ALL(inventory_transactions))
RETURN 
 DIVIDE(Numerator,Denominator,0)


Cumulative Transaction Value

Cumulative Transaction Value = 
VAR current_rank = [Transaction Value Rank]
RETURN 
SUMX(
    FILTER(
        ALL('Item'),
        [Transaction Value Rank]<= current_rank),
        CALCULATE([Transaction Item Value]))


Cumulative Stock Value = 
VAR current_rank = [Item Rank]
RETURN
SUMX(
    FILTER(
        ALLSELECTED(inventory_master),
        [Item Rank]<=current_rank),
    CALCULATE([Item Value]))


High Value Stock But Medium or Low Transaction = CALCULATE(COUNTROWS('Item'),
FILTER('Item',
 [ABC Class by Stock] ="A - High Value Stock" && 
 ([ABC Class by Transaction] ="B - Medium Value Transaction" ||
  [ABC Class by Transaction] ="C - Low Value Transaction")))


In Stock Amount = CALCULATE([Item Value],FILTER(inventory_master, inventory_master[Status]="In Stock"))


Item Rank = RANKX(ALL(inventory_master),[Item Value],,DESC)


Item Value = SUMX(inventory_master,inventory_master[UnitCost]*inventory_master[Quantity])

Items to reorder = CALCULATE(COUNTROWS(inventory_master),FILTER(inventory_master,inventory_master[Quantity]<=inventory_master[ReorderPoint]))


Low Value Stock But High Value Transaction = 
SUMX(
    inventory_master,
    IF(
        [ABC Class by Stock] = "C - Low Value Stock" &&
        [ABC Class by Transaction] = "A - High Value Transaction",
        1,
        0
    )
)

Under Stock Items = CALCULATE([Total Items], FILTER(inventory_master, inventory_master[Quantity] <= inventory_master[ReorderPoint]))