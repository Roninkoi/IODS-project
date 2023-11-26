# Roni Koitermaa 24.11.2023
# Create combined human development and gender inequality data set.

library(readr)

# https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# https://hdr.undp.org/system/files/documents/technical-notes-calculating-human-development-indices.pdf
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# human development data set
# 195 rows, 8 variables
dim(hd)
# HDI Rank,
# Country,
# Human Development Index (HDI),
# Life Expectancy at Birth,
# Expected Years of Education,
# Mean Years of Education,
# Gross National Income (GNI) per Capita,
# GNI per Capita Rank Minus HDI Rank
str(hd)
summary(hd)

# gender inequality data set
# 195 rows, 12 variables
dim(gii)
# GII Rank,
# Country,
# Gender Inequality Index (GII),
# Maternal Mortality Ratio,
# Adolescent Birth Rate,
# Percent Representation in Parliament,
# Population with Secondary Education (Female),
# Population with Secondary Education (Male),
# Labour Force Participation Rate (Female),
# Labour Force Participation Rate (Male)
str(gii)
summary(gii)

# metadata for variables: https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt
# rename columns in human development data
hd <- hd %>% 
  rename(
    HDI.Rank = `HDI Rank`,
    HDI = `Human Development Index (HDI)`,
    GNI = `Gross National Income (GNI) per Capita`,
    GNI.MinusRank = `GNI per Capita Rank Minus HDI Rank`,
    Life.Exp = `Life Expectancy at Birth`,
    Edu.Exp = `Expected Years of Education`,
    Edu.Mean = `Mean Years of Education`
  )

# rename columns in gender inequality data
gii <- gii %>% 
  rename(
    GII.Rank = `GII Rank`,
    GII = `Gender Inequality Index (GII)`,
    Mat.Mor = `Maternal Mortality Ratio`,
    Ado.Birth = `Adolescent Birth Rate`,
    Parli.F = `Percent Representation in Parliament`,
    Edu2.F = `Population with Secondary Education (Female)`,
    Edu2.M = `Population with Secondary Education (Male)`,
    Labo.F = `Labour Force Participation Rate (Female)`,
    Labo.M = `Labour Force Participation Rate (Male)`
  )

# create new variables in gii data set
# female to male ratio of secondary education
gii$Edu2.FM = gii$Edu2.F / gii$Edu2.M
# female to male ratio of labour force participation
gii$Labo.FM = gii$Labo.F / gii$Labo.M

# join hd and gii data sets by country (only including those in both)
human <- inner_join(hd, gii, by = "Country")

# save our new data set to disk
write_csv(human, "./data/human.csv")
