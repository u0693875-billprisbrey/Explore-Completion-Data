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

gradData <- dbGetQuery(con.ds, "
                       SELECT
                          EMPLID,
                          DEGREEDATE,
                          FULLNAME,
                          SEX,
                          ETHNICITY,
                          DEGREECAREER,
                          DEGREETYPE,
                          DEGREENAME,
                          DEGREETERM,
                          
                          MAJOR_CD,
                          MAJOR,
                          MAJOR_SHORT,
                          MAJOR_LONG,
                          MAJOR_GROUP,
                          CIP_CD,
                          
                          MAJOR_ACAD_ORG_CD,
                          
                          COLLEGE_SHORT,
                          
                          ACAD_COLLEGE_CIP_CD,
                          ACAD_DEPARTMENT_CD,
                          DEPARTMENT,
                          DEPARTMENT_SHORT,
                          DEPARTMENT_FORMAL,
                          ACAD_DEPARTMENT_REG_SUPP,
                          ACAD_DEPARTMENT_TYPE,
                          ACAD_DEPARTMENT_CIP_CD,
                          ACAD_DIVISION_CD,
                          DIVISION,
                          DIVISION_SHORT,
                          DIVISION_FORMAL,
                          ACAD_DIVISION_REG_SUPP,
                          ACAD_DIVISION_TYPE,
                          ACAD_DIVISION_CIP_CD,
                          VP_CD,
                          COLLEGE_CD,
                          DEPARTMENT_CD,
                          DIVISION_CD,
                          IPEDLEVEL,
                          TRANSFERFROMINSTATE,
                          MATH950,
                          FIRST_GEN_STATUS_CD,
                          FIRST_GEN_STATUS,
                          SNAP_MAJORCDE,
                          SNAP_MAJORNAME,
                          SNAP_MAJORCOLL,
                          SNAP_MAJORDEPT,
                          SNAP_CIP,
                          IPEDSCOMPYEAR,
                          IPEDSRATEYEAR,
                          ALT_ID,
                          AGE,
                          FA_PELL,
                          NBRTERMSATTENDED,
                          MAJOR_MIN_UNITS,
                          ROLLUP_SORT_ORDER,
                          MINUNITSREQUIRED,
                          UOFUGPAUNITS,
                          UOFUGPA,
                          DEGREEUOFUGPA,
                          BIRTHDATE,
                          DEGREEDATE
                      FROM
                      OBIA.COMBINED_DEGREE_V
                      WHERE
                      DEGREECAREER = 'U'
                       ")
queryEnd <- Sys.time()

# What is this column?
# Section Divider: OLD,

print("Query complete")      

saveRDS(gradData, here::here("Data", "gradData_early_pull.rds"))


if(FALSE) { # removed colums and old query
  
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
