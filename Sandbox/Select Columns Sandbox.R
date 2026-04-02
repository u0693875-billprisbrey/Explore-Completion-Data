# Select Columns Sandbox

########## 
## LOAD ## 
########## 

gradData <- readRDS(here::here("Data", "gradData_early_pull.rds"))


# Determine similarity between two columns

detSim <- function(col1,col2) {
  
  testTable <- table(col1,col2) |>
    as.data.frame.matrix()
  
  # Every row and every column has exactly one non-zero cell
  identicalTest <- 
    all(apply(testTable, 1, function(x) sum(x > 0) == 1)) &&
    all(apply(testTable, 2, function(x) sum(x > 0) == 1))
  
  if(identicalTest) {return(print("Identical"))}
  
  # return row and columns that are off 
  
  offRow <- apply(testTable, 1, function(x) sum(x > 0)) |> (\(x){which(x>1)})()
  offCol <- apply(testTable, 2, function(x) sum(x > 0)) |> (\(x){which(x>1)})()
  
  # percentage difference
  row_max_sum <- sum(apply(testTable, 1, max))
  col_max_sum <- sum(apply(testTable, 2, max))
  row_sim <- row_max_sum / sum(testTable)
  col_sim <- col_max_sum / sum(testTable)
  
  return(list(sim = min(row_sim, col_sim), row = offRow, col = offCol))
}

detSim(gradData$MAJOR_CD, gradData$MAJOR) # 0.997
detSim(gradData$MAJOR_SHORT, gradData$MAJOR) #0.88 # wow!
detSim(gradData$FIRST_GEN_STATUS_CD, gradData$FIRST_GEN_STATUS) # IDENTICAL

# Man, that "major" one is getting to me
# I almost want to run every column against every other one
#    ...and see if there are interesting errors here.
# Like, does it matter that MAJOR_SHORT and MAJOR aren't identical?

detSim(gradData$DEPARTMENT_SHORT, gradData$COLLEGE_SHORT) # 0.38 # as expected  

# I don't need every column against every other
# But there are groups of columns that I'm interested in

# Now I want a larger function where I can feed in the names,
# and do the combinatorics

createCombinatorics <- function(vec) {
  
  full_grid <- expand.grid(vec,vec,stringsAsFactors = FALSE)
  reduced_grid <- full_grid[full_grid$Var1 < full_grid$Var2,]
  
  return(reduced_grid)
  
}

c("ACAD_COLLEGE_CIP_CD", "COLLEGE_SHORT", "SNAP_MAJORCOLL") |>
createCombinatorics() |>
  (\(comb){
    setNames(
  lapply(1:nrow(comb),
         function(y){
           detSim(gradData[, comb[y,"Var1"]], gradData[,comb[y,"Var2"]])
         }
         ),
  paste(comb[,"Var1"],comb[,"Var2"])
    )
  })()

# ok, not bad!
# not great, but also not bad

# I can def feed some 'families' into here  

# This will make a nice little report.

# I'm ready to graduate to QMD 


