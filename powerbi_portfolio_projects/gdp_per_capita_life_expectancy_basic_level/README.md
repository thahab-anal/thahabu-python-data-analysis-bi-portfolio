# Life Expectancy and GDP Variation Over Time

## Project Summary
This project explores the relationship between **Life Expectancy** and **GDP per Capita** across different regions using the Gapminder dataset.  
The aim is to analyze how economic prosperity relates to population health and visualize trends over time using various Power BI charts.  
Additionally, a Correlation Coefficient is calculated to quantify the relationship between health and wealth.

## Source File
- **Dataset:** SampleDataWS (Gapminder dataset)
- **Data Description:** Columns include Country, Year, Region, Life Expectancy, GDP per Capita, and Income Bands.
- **Tool Used:** Power BI

## Data Preparation Steps
1. Imported the Gapminder dataset **SampleDataWS**.
2. Replaced errors with proper values in the error columns.
3. Updated the datatypes according to the column values.
4. Saved and reloaded the dataset for analysis.

## Visualizations Created
1. **Scatter Chart** – Life Expectancy vs. GDP per Capita across regions and over time.
2. **Clustered Bar Chart** – Regional comparisons of GDP per Capita and Life Expectancy.
3. **Stacked Bar Chart** – GDP per Capita growth trends over time by region.
4. **Horizontal Stacked Bar Chart** – Average GDP trends based on income bands over time.

## Correlation Analysis
To quantify the relationship between Health and Wealth, a **Correlation Coefficient** measure was created in DAX.

### DAX Formula
```DAX
Correlation Coefficient = 
VAR AVG_X = AVERAGE(SampleDataWS[Life Expectancy])
VAR AVG_Y = AVERAGE(SampleDataWS[GDP_Per_Capita])
VAR Numerator = SUMX(SampleDataWS, (SampleDataWS[Life Expectancy]-AVG_X)*(SampleDataWS[GDP_Per_Capita]-AVG_Y))
VAR Denominator = SQRT(
    (SUMX(SampleDataWS, ((SampleDataWS[Life Expectancy]-AVG_X)^2))) *
    (SUMX(SampleDataWS, ((SampleDataWS[GDP_Per_Capita]-AVG_Y)^2)))
)
RETURN DIVIDE(Numerator, Denominator)
```

### Result
- **Correlation Coefficient = 0.46**
- Interpretation: There is a slight positive correlation between Life Expectancy and GDP per Capita.  
  As GDP per Capita increases, Life Expectancy tends to increase slightly as well.

## Questions Answered
1. How does Life Expectancy vary by region and over time?
2. Which regions show the highest GDP per Capita growth?
3. Is there a measurable relationship between GDP per Capita and Life Expectancy?
4. How do income bands influence the average GDP trend?
