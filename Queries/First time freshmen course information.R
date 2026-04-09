# Course Information for First Time Freshmen 


library(DBI)
con.ds <- DBI::dbConnect(odbc::odbc(), 
                         Driver = "Oracle in instantclient_23_0", 
                         Host = "ocm-campus01.it.utah.edu", 
                         SVC = "biprodusr.sys.utah.edu",
                         DBQ = "//ocm-campus01.it.utah.edu:2080/biprodusr.sys.utah.edu",
                         UID = Sys.getenv("userid"),
                         PWD = Sys.getenv("pwd"),
                         Port = 2080)

########################
## FTF THAT GRADUATED ##
########################

queryStart <- Sys.time()
courseData_ftf_grad <- dbGetQuery(con.ds, "
SELECT *
  FROM OBIA.COMBINED_COURSE_V
WHERE EMPLID IN (
  SELECT EMPLID
  FROM OBIA.FTF_DEMO_V
)
AND EMPLID IN (
  SELECT EMPLID
  FROM OBIA.COMBINED_DEGREE_V
  WHERE DEGREECAREER = 'U'
);"
)

queryEnd <- Sys.time()

print("Query complete") 
print(queryEnd - queryStart)
saveRDS(courseData_ftf_grad, here::here("Data", "courseData_8Apr26_graduated_ftf.rds"))


################################
## FTF THAT HAVEN'T GRADUATED ##
################################


queryStart <- Sys.time()
courseData_ftf_not_grad <- dbGetQuery(con.ds, "
SELECT *
  FROM OBIA.COMBINED_COURSE_V
WHERE EMPLID IN (
  SELECT EMPLID
  FROM OBIA.FTF_DEMO_V
)
AND EMPLID NOT IN (
    SELECT EMPLID
    FROM OBIA.COMBINED_DEGREE_V
    WHERE DEGREECAREER = 'U'
    AND EMPLID IS NOT NULL
);"
)

queryEnd <- Sys.time()

print("Query complete")      
print(queryEnd - queryStart)
saveRDS(courseData_ftf_not_grad, here::here("Data", "courseData_8Apr26_NOT_graduated_ftf.rds"))

