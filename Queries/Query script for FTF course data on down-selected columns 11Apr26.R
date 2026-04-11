# Query script for FTF course data (11Apr26)
# using down-selected columns 

library(DBI)
con.ds <- DBI::dbConnect(odbc::odbc(), 
                         Driver = "Oracle in instantclient_23_0", 
                         Host = "ocm-campus01.it.utah.edu", 
                         SVC = "biprodusr.sys.utah.edu",
                         DBQ = "//ocm-campus01.it.utah.edu:2080/biprodusr.sys.utah.edu",
                         UID = Sys.getenv("userid"),
                         PWD = Sys.getenv("pwd"),
                         Port = 2080)


###########
## QUERY ##
###########


# First time freshmen
# Undergraduate students 
# Term extract in E or S (no snapshots)
# Down-selected columns based on report, 
#  "Column Selection for COMBINED_COURSE_V"
# Column added based on presence in COMBINED_DEGREE_V

queryStart <- Sys.time()
courseData <- dbGetQuery(con.ds, "
SELECT 
 TERM,
 EOTDATE,
 EMPLID,
 SUBJECT_CD,
 CATNBR,
 SECTION,
 TITLE,
 UNITS,                  
 GRADE, 
 INSTEMPLID,   
 SCHEDFLAG,              
 AUTOENROLL,
 COMPONENT,              
 GENED,                   
 ONLINECOURSE,           
 IVC,                     
 IVC_HYBRID,             
 COURSE_MODALITY,         
 INSTRUCTION_MODE,       
 HYBRIDCOURSE,            
 USHE_COURSE_LEVEL,      
 ACAD_COLLEGE_CD,         
 ACAD_DEPARTMENT_CD,     
 ACAD_DIVISION_CD,       
 DIVISION,               
 VP_CD,                   
 PS_ACAD_GROUP,          
 COURSELOCATION,          
 CONTACTMINUTES,         
 TEAMTAUGHT,              
 XLIST,                  
 BEGTIME1,                
 DAYS1,                  
 ENDTIME1,                
 CLASSLOC1,              
 CLASSLOCBUILDNAME1,      
 CLASSLOCBUILDROOM1,     
 SERVICELEARNING,         
 GRADEGPA,               
 CLASSENROLLMENTCAPACITY, 
 TERM_NBR,
 STUDENTCAREER,
 deg.DEGREECAREER,
 CASE WHEN deg.EMPLID IS NOT NULL THEN 'TRUE' ELSE 'FALSE' END AS IN_DEGREE_TABLE
FROM OBIA.COMBINED_COURSE_V main
LEFT JOIN (
  SELECT DISTINCT EMPLID
  FROM OBIA.COMBINED_DEGREE_V
) deg ON main.EMPLID = deg.EMPLID  
WHERE 
 TERMEXTRACT IN ('E','S')
 AND main.EMPLID IN (
  SELECT EMPLID
  FROM OBIA.FTF_DEMO_V
)
;"
)

queryEnd <- Sys.time()

print("Query complete") 
print(queryEnd - queryStart)
saveRDS(courseData, here::here("Data", "courseData_11Apr26.rds"))


