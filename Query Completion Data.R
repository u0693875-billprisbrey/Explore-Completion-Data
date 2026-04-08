# Query Completion Data

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

if(FALSE){

queryStart <- Sys.time()
gradData <- dbGetQuery(con.ds, "
                       SELECT
                          EMPLID,
                          DEGREEDATE
                       FROM
                          OBIA.COMBINED_DEGREE_V
                       ")
queryEnd <- Sys.time()
print(queryEnd - queryStart)
print(queryEnd - queryStart)
print(queryEnd - queryStart)

stop("End query here")      

}

queryStart <- Sys.time()
gradData <- dbGetQuery(con.ds, "
                       SELECT
                          EMPLID,
                          DEGREEDATE,
                          FULLNAME,
                          SEX,
                          ETHNICITY,
                          
                          DEGREETYPE,
                          DEGREENAME,
                          DEGREETERM,
                          
                          MAJOR_CD,
                          MAJOR,
                          MAJOR_SHORT,
                          
                          
                          
                          
                          
                          COLLEGE_SHORT,
                          
                          
                          
                          ACAD_DEPARTMENT_CD, 
                          
                          
                          
                          
                          
                          
                          DIVISION_SHORT,
                          
                          
                          ACAD_DIVISION_TYPE,
                          
                          VP_CD,
                          
                          
                          
                          
                          TRANSFERFROMINSTATE,
                          MATH950,
                          FIRST_GEN_STATUS_CD,
                          FIRST_GEN_STATUS,
                          
                          IPEDSCOMPYEAR,
                          IPEDSRATEYEAR,
                          
                          AGE,
                          FA_PELL,
                          NBRTERMSATTENDED,
                          
                          UOFUGPAUNITS,
                          UOFUGPA,
                          DEGREEUOFUGPA,
                          BIRTHDATE
                      FROM
                      OBIA.COMBINED_DEGREE_V
                      WHERE
                      DEGREECAREER = 'U'
                       ")
queryEnd <- Sys.time()

# What is this column?
# Section Divider: OLD,

print("Query complete")      

saveRDS(gradData, here::here("Data", "gradData_7Apr26.rds"))


if(FALSE) { # removed colums and old query

#  ACAD_DIVISION_CD,
#  DIVISION_CD,
#  DIVISION,
#  DIVISION_FORMAL,
#  ACAD_DIVISION_CIP_CD,
#  ACAD_COLLEGE_CIP_CD,
#  COLLEGE_CD,
#  SNAP_MAJORCOLL,
#  DEPARTMENT,
#  DEPARTMENT_SHORT,
#  DEPARTMENT_FORMAL,
#  DEPARTMENT_CD,
#  ACAD_DEPARTMENT_CIP_CD,
#  MAJOR_ACAD_ORG_CD,
#  SNAP_MAJORDEPT,
#  MAJOR_LONG,
#  MAJOR_GROUP,
#  CIP_CD,
#  SNAP_MAJORCDE,
#  SNAP_MAJORNAME,
#  SNAP_CIP,
  
#  DEGREECAREER,
#  ACAD_DIVISION_REG_SUPP,
#  ACAD_DEPARTMENT_REG_SUPP,
  
#  IPEDLEVEL,
  
#  ACAD_DEPARTMENT_TYPE,
  
#  MAJOR_MIN_UNITS,
#  ROLLUP_SORT_ORDER,
#  MINUNITSREQUIRED,
  
#  ALT_ID,
  
# DEGREELEVEL,

# MAJOR_LEVEL_CD,
# MAJOR_LEVEL,
# IPEDS_LEVEL_CD,
# IPEDS_LEVEL,
# DEGREE_TYPE_CD,
# MATR_FLAG,

# VP,
# VP_SHORT,
# VP_FORMAL,
# ACAD_COLLEGE_CD,
# COLLEGE,


# COLLEGE_FORMAL,
# ACAD_COLLEGE_REG_SUPP,
# ACAD_COLLEGE_TYPE,

queryStart <- Sys.time()
creditLoad <- dbGetQuery(con.ds, "
SELECT
  TERM,
  EMPLID,
  SUM(UNITS) AS UNITS
FROM
  OBIA.COMBINED_COURSE_V
WHERE 
  TERMEXTRACT IN ('E','S')
  AND EMPLID IN (
        SELECT EMPLID
        FROM OBIA.FTF_DEMO_V
      )
GROUP BY
  TERM,
  EMPLID
  ; 
                       ")

}
