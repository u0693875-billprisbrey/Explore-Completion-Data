# Initial Course Sandbox

courseData <- readRDS(here::here("Data", "courseData_8Apr26_graduated_ftf.rds"))

dim(courseData)
# [1] 3719806     128

# wow

index <- sample(1:nrow(courseData), 0.1*nrow(courseData)) # 10% sample

View(courseData[index,])


table(courseData[,"EMPLID"]) |> hist() # centered around 100  (!) rows per student!

> table(courseData[,c("GRADE", "TERMEXTRACT" )]) |> proportions()
TERMEXTRACT
GRADE            C            E            S
0.000000e+00 6.095556e-02 3.431264e-03
A  0.000000e+00 3.553405e-01 3.739312e-02
A- 0.000000e+00 1.186385e-01 1.084706e-02
B  0.000000e+00 7.921623e-02 7.158043e-03
B- 0.000000e+00 4.361864e-02 4.090154e-03
B+ 0.000000e+00 8.075017e-02 7.329880e-03
C  0.000000e+00 2.826114e-02 2.681530e-03
C- 0.000000e+00 1.400853e-02 1.292607e-03
C+ 0.000000e+00 2.745941e-02 2.663471e-03
CR 1.641753e-06 4.805302e-02 3.970306e-03
D  5.472510e-07 7.212768e-03 6.846110e-04
D- 0.000000e+00 2.846253e-03 2.790980e-04
D+ 0.000000e+00 4.952622e-03 4.810336e-04
E  0.000000e+00 1.534601e-02 1.780755e-03
EU 0.000000e+00 2.250296e-03 3.967570e-04
F  0.000000e+00 1.149227e-05 0.000000e+00
I  0.000000e+00 3.291715e-03 3.951152e-04
NC 0.000000e+00 2.415019e-03 2.413377e-04
P  0.000000e+00 3.929262e-03 1.149227e-04
T  0.000000e+00 2.626258e-03 5.778971e-04
V  1.641753e-05 1.488523e-04 9.303267e-06
W  6.183937e-05 1.204664e-02 7.223713e-04

# Looks like I need to observe this in my query:
TERMEXTRACT IN ('E','S')
# makes me wonder what information is in 'C'


# Lots of repeat/redundant columns.  Looks like a lot of information
# is duplicated in the tables.

# where was the number of credits earned?

sampleIDs <- sample(courseData$EMPLID, 10) |> unique()

termExtract_Filter <- courseData$TERMEXTRACT %in% c("E","S")
View(courseData[courseData$EMPLID == sampleIDs[1] & termExtract_Filter,])

# I kinda want to calculate "UNITS" and "GPA" per college or department and 
# see if I can predict which college their degree comes from.
# It should obviously follow, but then I'd look at the ones 
# it couldn't predict accurately.  Were these major changes?

# I wonder if I could drill down to building and class location or times.
# Why is class detail empty for sampleIDs[1] "01354367" ?

# I've worked with this data before, so I wish it was more readily familiar
# to me. Student course feedback should have taught me about team teaching.  
# Where's the data dictionary?

# Also I certainly don't need all of these columns.
# Make me wish I could, rather than relying on this "kitchen sink" data warehouse with a million columns,
# access the data tables that describe the things individually so I can query detail as needed. 


# Should I do detSim here, or just accept from the work on the graduation data?

# Let's calculate a GPA, and conclude there.

weighted.mean(courseData$GRADEGPA[courseData$EMPLID == sampleIDs[1] & termExtract_Filter],
              courseData$UNITS[courseData$EMPLID == sampleIDs[1] & termExtract_Filter],
              na.rm = TRUE
              )

setNames(
lapply(sampleIDs, function(x){
  
  weighted.mean(courseData$GRADEGPA[courseData$EMPLID == x & termExtract_Filter],
                courseData$UNITS[courseData$EMPLID == x & termExtract_Filter],
                na.rm = TRUE
  )
  
}),
nm = sampleIDs)

$`01354367`
[1] 3.427419

$`00762668`
[1] 3.590566

$`00898728`
[1] 2.776712

$`00487025`
[1] 3.632877

$`01207554`
[1] 3.297175

$`00658883`
[1] 3.762712

$`01192033`
[1] 3.769403

$`01090746`
[1] 3.359223

$`00671188`
[1] 3.978182

$`01046553`
[1] 3.941877


# let's compare to the gradData now


gradData <- readRDS(here::here("Data", "gradData_7Apr26.rds"))

gradData[gradData$EMPLID %in% sampleIDs, c("EMPLID", "UOFUGPA")] |>
  (\(x){x[match(sampleIDs, x[[1]]),]})()

EMPLID UOFUGPA
74784  01354367   3.427
35091  00762668   3.360
45783  00898728   3.436
12443  00487025   3.700
66286  01207554   3.151
122781 00658883   3.750
64895  01192033   3.769
58646  01090746   3.359
26598  00671188   3.970
55648  01046553   3.968

# Happily, some of these are exact.
# Others are a little different.
# Some are way different.

# This makes me think of transfer and AP credits.

# Let's do units and GPA

  lapply(sampleIDs, function(x){
    
    gpa <- weighted.mean(courseData$GRADEGPA[courseData$EMPLID == x & termExtract_Filter],
                  courseData$UNITS[courseData$EMPLID == x & termExtract_Filter],
                  na.rm = TRUE)
    units <- sum(courseData$UNITS[courseData$EMPLID == x & termExtract_Filter])
    
    return(data.frame(emplid = x, gpa = gpa, units = units))
    
  }) |>
  (\(x){do.call(rbind,x)})()
  
gradData[gradData$EMPLID %in% sampleIDs, c("EMPLID", "UOFUGPA", "UOFUGPAUNITS")] |>
  (\(x){x[match(sampleIDs, x[[1]]),]})()

# ok, that's worse.

# I honestly want to accurately trace a student's journey through the U.
# I should be able to describe before, during, and end result.  

# Next --- and why not ---

# Let's compare and see how far and how many are off

# after 15min, I abandoned the full data.  That'll have to be a background job.

# Let's do a sample of 1,000 of them

allEmplid <- unique(courseData$EMPLID)

emplid1000 <- sample(courseData$EMPLID, 1000) |> unique()

courseCalc <- lapply(emplid1000, function(x){
  
  gpa <- weighted.mean(courseData$GRADEGPA[courseData$EMPLID == x & termExtract_Filter],
                       courseData$UNITS[courseData$EMPLID == x & termExtract_Filter],
                       na.rm = TRUE)
  units <- sum(courseData$UNITS[courseData$EMPLID == x & termExtract_Filter])
  
  return(data.frame(emplid = x, gpa = gpa, units = units))
  
}) |>
  (\(x){do.call(rbind,x)})()

compCalc <- gradData[gradData$EMPLID %in% emplid1000, c("EMPLID", "UOFUGPA", "UOFUGPAUNITS")] |>
  (\(x){x[match(emplid1000, x[[1]]),]})()

theDiff <- merge(courseCalc, compCalc, by.x = "emplid", by.y = "EMPLID")

hist(theDiff$gpa - theDiff$UOFUGPA)
summary(theDiff$gpa - theDiff$UOFUGPA)
Min.    1st Qu.     Median       Mean    3rd Qu. 
-1.0505000 -0.1009394 -0.0096154 -0.0583962  0.0002692 
Max. 
0.9769167 

# eh could be worse

#summary(theDiff$units - theDiff$UOFUGPAUNITS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#  -6.00    4.00   13.00   28.92   35.12  290.50       1
  
# Really missing some thing here 
  
# What next?

# ideas:
#  - Complete the column "detSim" (write that report)
#  - New query with the term=E,S and the down-selected columns
#  - New query is all FTF students, with a grad/not grad flag
#  - Be able to fully calculate/duplicate/explain:
#     - GPA
#     - Units
#     - Transfer units / AP credits 

# Why are so many classroom details missing?
# 

# let's investigate the key (...?)



