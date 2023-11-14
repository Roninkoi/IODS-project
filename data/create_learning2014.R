# Roni Koitermaa 13.11.2023
# Create learning2014 data set.

library(readr)

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)

# dim(learning2014)
# data set has dimensions 183 x 60 (60 variables for each student)

# str(learning2014)
# data set contains columns:
# gender: gender of the student (M/F)
# age: age of the student (years)
# attitude: global attitude towards statistics (int)
# points: total points of the student (int)
# measurement parameters:
# Aa-Af, Ca-Ch, Da-Dj, D[number], SU[number], ST[number] (int)

# calculate variables based on http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt

# seeking meaning
d_sm <- learning2014$D03 + learning2014$D11 + learning2014$D19 + learning2014$D27
# relating ideas
d_ri <- learning2014$D07 + learning2014$D14 + learning2014$D22 + learning2014$D30
# use of evidence
d_ue <- learning2014$D06 + learning2014$D15 + learning2014$D23 + learning2014$D31

# lack of purpose
su_lp <- learning2014$SU02 + learning2014$SU10 + learning2014$SU18 + learning2014$SU26
# unrelated memorising
su_um <- learning2014$SU05 + learning2014$SU13 + learning2014$SU21 + learning2014$SU29
# syllabus-boundness
su_sb <- learning2014$SU08 + learning2014$SU16 + learning2014$SU24 + learning2014$SU32

# organized studying
st_os <- learning2014$ST01 + learning2014$ST09 + learning2014$ST17 + learning2014$ST25
# time management
st_tm <- learning2014$ST04 + learning2014$ST12 + learning2014$ST20 + learning2014$ST28

# surface learning score of the student (mean)
surf <- (su_lp + su_um + su_sb)
surf <- surf / 12
# deep learning score of the student (mean)
deep <- (d_sm + d_ri + d_ue)
deep <- deep / 12
# strategic learning score of the student (mean)
stra <- (st_os + st_tm)
stra <- stra / 8

# attitude (mean)
attitude <- learning2014$Attitude / 10

# create data set, include only points > 0
learning14_data <- filter(data.frame(gender=learning2014$gender,
                              age=learning2014$Age,
                              attitude=attitude,
                              deep=deep,
                              stra=stra,
                              surf=surf,
                              points=learning2014$Points),
                          points > 0)

path <- "data/learning2014.csv"
# write data set to file
write_csv(learning14_data, path)

# read data set from file we just created
learning14_test <- read_csv(path)

str(learning14_test) # check structure of data
head(learning14_test, 5) # check first few rows

# learning2014.csv contains 166 rows and 7 columns, data looks ok
