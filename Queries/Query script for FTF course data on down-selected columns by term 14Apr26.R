# Query script for FTF course data (14Apr26)
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

####################
## QUERY OF TERMS ##
####################

courseTerms <- dbGetQuery(con.ds, "
SELECT DISTINCT
 TERM
FROM OBIA.COMBINED_COURSE_V main
WHERE 
 main.TERMEXTRACT IN ('E','S')
 AND main.EMPLID IN (
  SELECT EMPLID
  FROM OBIA.FTF_DEMO_V
 )
  ;"
)                          
                          
courseTerms <- courseTerms[[1]] |>
  (\(x){
    
  substr(x,2,3) |>
  as.numeric() |>
  (\(y){order(y, decreasing = TRUE)})() |>
  (\(z){x[z] })()
   })()
    
###########
## QUERY ##
###########


# First time freshmen
# Undergraduate students 
# Term extract in E or S (no snapshots)
# Down-selected columns based on report, 
#  "Column Selection for COMBINED_COURSE_V"
# Column added based on presence in COMBINED_DEGREE_V
# Pulling one term at a time

mainQueryStart <- Sys.time()
print(mainQueryStart)

lapply(courseTerms[19:21], function(term) { 

  queryStart <- Sys.time()
  print(queryStart)
  
courseData <- dbGetQuery(con.ds, paste("
SELECT DISTINCT
 TERM,
 EOTDATE,
 main.EMPLID,
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
    CASE WHEN main.EMPLID IN (
    SELECT DISTINCT EMPLID
    FROM OBIA.COMBINED_DEGREE_V
    WHERE DEGREECAREER = 'U'
  ) THEN 'TRUE' ELSE 'FALSE' END AS IN_DEGREE_TABLE
 
FROM OBIA.COMBINED_COURSE_V main
WHERE 
 main.TERMEXTRACT IN ('E','S')
 AND main.EMPLID IN (
  SELECT EMPLID
  FROM OBIA.FTF_DEMO_V
)
AND main.TERM = ", term,"
;", sep = ""
))

# RESTORED
#  INSTEMPLID,   

queryEnd <- Sys.time()

print(paste(term, "Query complete")) 
print(queryEnd - queryStart)
saveRDS(courseData, here::here("Data", "Terms_14Apr26", paste("courseData", term, "14Apr26.rds", sep="_")))

})

mainQueryEnd <- Sys.time()
print(mainQueryEnd)
print(mainQueryEnd - mainQueryStart)
