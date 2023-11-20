# Roni Koitermaa 19.11.2023
# Create student alcohol consumption data set.

library(tidyverse)
library(dplyr)

# data source: [1] http://www.archive.ics.uci.edu/dataset/320/student+performance
student_mat <- read.csv("./data/student-mat.csv", sep=';')
student_por <- read.csv("./data/student-por.csv", sep=';')

# data set has dimensions 395 x 33 (33 variables for each student)
dim(student_mat)
# data set has dimensions 649 x 33 (33 variables for each student)
dim(student_por)

# data for mathematics students
str(student_mat)
# data for portuguese language students
str(student_por)

# both data sets contain columns (descriptions based on [1]):
# school: school student attends (chr)
# sex: sex of the student (M/F)
# age: age of the student (int)
# address: where student lives, urban or rural (U/R)
# famsize: number of family members, <= 3 or > 3 (LE3/GT3)
# Pstatus: parent lives together/apart (T/A)
# Medu: mother education level (0-4)
# Fedu: father education level (0-4)
# Mjob: father job (chr)
# Fjob: mother job (chr)
# reason: why student attends this school (chr)
# guardian: guardian of student (mother/father/other)
# traveltime: commute time (1-4)
# studytime: weekly study time (1-4)
# failures: number of failed classes (int)
# schoolsup: extra educational support from school (yes/no)
# famsup: educational support from family (yes/no)
# paid: extra paid classes (yes/no)
# activities: extra-curricular activities (yes/no)
# nursery: attended nursery school (yes/no)
# higher: wants to go into higher education (yes/no)
# internet: has internet (yes/no)
# romantic: in romantic relationship (yes/no)
# famrel: quality of family relationships (1-5)
# freetime: amount of free time outside of school (1-5)
# goout: how much goes out with friends (1-5)
# Dalc: alcohol consumption on workdays (1-5)
# Walc: alcohol consumption during weekends (1-5)
# health: student health (1-5)
# absences: number of absences (int)
# G1: first period grade (0-20)
# G2: second period grade (0-20)
# G3: final grade (0-20)

# columns that are different by class
free_cols <- c("failures",
               "paid",
               "absences",
               "G1", "G2", "G3")

# student identification columns
join_cols <- setdiff(colnames(student_por), free_cols)

# join students in math and portuguese classes by id columns
math_por <- inner_join(student_mat, student_por, by = join_cols, 
                       suffix = c(".math", ".por"))

# 370 rows, 39 variables (27 + 6 math + 6 por)
dim(math_por)
# separate columns .math .por for each column in free_cols
str(math_por)

# add id column data
alc <- select(math_por, all_of(join_cols))
# calculate free_cols means (Exercise 3)
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  # add free_cols (calculated as mean for mat and por for numeric variables)
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

# add column alc_use as the average between weekday and weekend use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# add column high_use, TRUE when average use exceeds 2
alc <- mutate(alc, high_use = alc_use > 2)

# 370 rows, 35 columns (33 + alc_use + high_use), data ok
glimpse(alc)

# write to disk
write_csv(alc, "./data/alc.csv")
