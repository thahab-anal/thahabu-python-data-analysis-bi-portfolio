# DATAQUEST Learning Analytics

## Project Summary
This project analyzes lesson completions, survey reponse scores  to understand learner engagement, course quality, opputunities of improvement.

## Source File
- **Files:** course_lessons.csv, lesson_progress.csv, nps_data.csv
  **Path:**  `\thahabu-python-data-analysis-bi-portfolio\powerbi_portfolio_projects\DataQuest_Learning_Analytics`
- **Data Description:** Columns include CourseID, Lesson ID, Course Completion status, Course started date, Survey response score.
- **Tool Used:** Power BI
---

## 🎯 Business Questions to Answer

Which lessons drive positive or negative learner experience
Which lessons require improvement based on NPS and completion rates
How response distribution affects the reliability of NPS
Patterns in course popularity and completion behavior
Data-driven recommendations to improve overall learning outcomes

---

## 🪄 Steps Followed

### Data Import and transformation (Power Query)
- Imported the datasets course_lessons.csv, nps_data.csv, lesson_progress.csv
- Promoted Headers
- Coverted datatype of lesson_id as Text
- Replaced Lesson ID null with 1 in course_lessons.csv
- Removed duplicate rows in lesson_progress
- Removed Rows with Lesson_id null in lesson_progress and nps dataset in powerquery.
---

### Data Modeling
Created data model by joining lessonId of course_lessons with lesson_progress and nps  dataset.
Created another Table using DAX and Joined lessonID of this new table with course_lesson table and maintained reliable integrity
Created necessary DAX measures(Listed key measures below)

### Visualizations

Built an interactive Power BI report with the following visuals:

KPI Cards for completion rate ,lesson completion metrics, Total Survey responses, Overall NPS
Line Chart to show Completion rate over time, and NPS score by Time
Scatter Plot to show How correlated course popularity and completion rate, also between NPS Score and Number of responses
Distribution buckets of completion rate and Score distributions through Histogram
Table details about the lesson ID and Top and bottom performing lessons

### Key Learnings

How to create DAX summary table
How to create Top/Bottom Rank with dynamic ranking through filters.
How to create bins

### Tools Used

Power BI Desktop
Power Query
DAX (Data Analysis Expressions)


### Key DAX Measures

lesson_completion_rate DAX Table:

```DAX
lesson_completion_rate = 
SUMMARIZE(lesson_progress,
lesson_progress[lesson_id],
"total_starts",COUNTROWS(lesson_progress),
"total_completes",COALESCE(CALCULATE(COUNTROWS(lesson_progress),lesson_progress[is_complete]=True),0))
```

Completion Rate

``` DAX
Completion_rate = DIVIDE(CALCULATE(COUNTROWS(lesson_progress),lesson_progress[is_complete] = TRUE),COUNTROWS(lesson_progress))
```
Lesson Completions
``` DAX
Lesson Completions = CALCULATE(COUNTROWS(lesson_progress),lesson_progress[is_complete]=TRUE)
```
NPS

``` DAX
NPS = DIVIDE([Promoters] -[Detractors],COUNTROWS(nps_data),0)
```

NPS Group
``` DAX
NPS Group = 
VAR score = nps_data[score]
RETURN SWITCH (TRUE(), score<=6,"Detractors",
nps_data[score]<=8,"Passives",
nps_data[score]<=10,"Promoters")
```

NPS RANK

``` DAX
NPS RANK = 
VAR CurrentLessonID = SELECTEDVALUE(course_lessons[lesson_id])
VAR CurrentNPS = [NPS]
RETURN
IF(
    NOT(ISBLANK(CurrentLessonID)) && NOT(ISBLANK(CurrentNPS)) && [Percentage of Total Response]>0.01,
    RANKX(
        FILTER( ALL(course_lessons[lesson_id]),
                VAR CurrentLessonID = course_lessons[lesson_id]
                VAR CurrentNPS = CALCULATE([NPS])
                RETURN(NOT(ISBLANK(CurrentLessonID)) && NOT(ISBLANK(CurrentNPS)) && [Percentage of Total Response]>0.01)),
                CALCULATE([NPS]),
                ,
                ASC,
                Dense),
    BLANK())
```
Percentage of Total Response
``` DAX
Percentage of Total Response = DIVIDE(COUNT(nps_data[response_id]),CALCULATE(COUNT(nps_data[response_id]),ALL(nps_data)),0)
``` 

Response RANK

```
Response RANK = 
RANKX(ALL(course_lessons[lesson_id]),
    CALCULATE(COUNT(nps_data[response_id])),
    ,ASC,DENSE)
```