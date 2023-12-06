libname acuman '/home/u50078057/acuman';


PROC IMPORT DATAFILE="/home/u50078057/acuman/Acumen_Data_Analysis_Exercise.xlsx" 
            OUT=acuman.dataset
            DBMS=XLSX REPLACE;
  RANGE="Data$A1:I19104"; /* Specify the range of data you want to import */
  GETNAMES=YES; 
RUN;

DATA acuman.data; 
  SET acuman.dataset; 
  rename 
  	'Observation Number'n = Observation_Number
  	'Employee Id'n = Employee_Id
    'Sex (Male=1)'n = Sex
    'Hospital Visit This Quarter (1=Y'n = Hospital_Visit_This_Quarter
    'Health Score'n = Health_Score;
RUN;

PROC CONTENTS DATA=acuman.dataset;
RUN;

/* check for missing value */
PROC MEANS DATA=acuman.data NMISS;
RUN;

PROC PRINT DATA=acuman.data(obs=50);
  WHERE Race IS MISSING;
RUN;

PROC MEANS DATA=acuman.dataset;
RUN;

/* Create a table of demographic characteristics by quarter */

PROC TABULATE DATA=acuman.data Out=SummaryTable;
  CLASS Quarter Sex Race;
  VAR Age Salary Health_Score;

  TABLE Quarter,
        (N="Count" Age*Mean="Average Age" Salary*Mean="Average Salary" Health_Score*Mean="Average Health Score")
        Sex*(N="Count" Age*Mean="Average Age" Salary*Mean="Average Salary" Health_Score*Mean="Average Health Score")
        Race*(N="Count" Age*Mean="Average Age" Salary*Mean="Average Salary" Health_Score*Mean="Average Health Score");

  TITLE "Demographic Characteristics by Quarter";
RUN;

/* Create charts of demographic characteristics by quarter */

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Age_Mean / GROUP=Sex;
  TITLE "Average Age by Quarter and Gender";
RUN;

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Age_Mean / GROUP=Race;
  TITLE "Average Age by Quarter and Race";
RUN;

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Salary_Mean / GROUP=Sex;
  TITLE "Average Salary by Quarter and Gender";
RUN;

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Salary_Mean / GROUP=Race;
  TITLE "Average Salary by Quarter and Race";
RUN;

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Health_Score_Mean / GROUP=Sex;
  TITLE "Average Health Score by Quarter and Gender";
RUN;

PROC SGPLOT DATA=SummaryTable;
  SERIES X=Quarter Y=Health_Score_Mean / GROUP=Race;
  TITLE "Average Health Score by Quarter and Race";
RUN;


/* Descriptive statistics for Health Score by categorical variables */
PROC MEANS DATA=acuman.data;
  VAR Health_Score;
  CLASS Sex Race;
  OUTPUT OUT=HealthScoreStats MEAN=Mean_Health_Score N=N;
RUN;

/* Scatter plot for Age vs. Health Score */
PROC SGPLOT DATA=acuman.data;
  SCATTER X=Age Y=Health_Score / GROUP=Sex;
  TITLE "Scatter Plot: Age vs. Health Score by Gender";
  LABEL Age = "Age" Health_Score = "Health Score";
RUN;

/* Scatter plot for Salary vs. Health Score */
PROC SGPLOT DATA=acuman.data;
  SCATTER X=Salary Y=Health_Score / GROUP=Sex;
  TITLE "Scatter Plot: Salary vs. Health Score by Gender";
  LABEL Salary = "Salary" Health_Score = "Health Score";
RUN;

/* Scatter plot for Age vs. Health Score by Race */
PROC SGPLOT DATA=acuman.data;
  SCATTER X=Age Y=Health_Score / GROUP=Race;
  TITLE "Scatter Plot: Age vs. Health Score by Race";
  LABEL Age = "Age" Health_Score = "Health Score";
RUN;

/* Scatter plot for Salary vs. Health Score by Race */
PROC SGPLOT DATA=acuman.data;
  SCATTER X=Salary Y=Health_Score / GROUP=Race;
  TITLE "Scatter Plot: Salary vs. Health Score by Race";
  LABEL Salary = "Salary" Health_Score = "Health Score";
RUN;

/* Perform ANOVA for Health Score by Quarter */
PROC GLM DATA=acuman.data;
  CLASS Quarter;
  MODEL Health_Score = Quarter;
  MEANS Quarter / LSD; /* Optionally include LSD for post hoc pairwise comparisons */
  TITLE "ANOVA: Health Score by Quarter";
RUN;