# Roni Koitermaa 3.12.2023
# Raw data set created using create_human_raw.R 
# (https://github.com/Roninkoi/IODS-project/blob/master/data/create_human_raw.R)
# Create human data set for week 5 using combined human development and 
# gender inequality data set.

# create raw data set
source("./data/create_human_raw.R")
# read this data
human <- read_csv("./data/human.csv")

# Explore dimensions and structure of the human data set.
# This data set consists of 195 rows, 19 variables.
dim(human)
# The data set contains human development and gender inequality data for
# different countries and regions (including the entire world). 
# These indicators can be used to assess development of countries in a number
# areas, including economic, health, education and equality.
# The variables are [min, max]:
# Country: Name of the country (or region)
# HDI.Rank: Human development index rank [1, 188]
# HDI: Human development index [0.35, 0.94]
# Life.Exp: Life expectancy [49, 84]
# Edu.Exp: Expected years of education [4, 20]
# Edu.Mean: Mean years of education [1, 13]
# GNI: Gross national income per capita [581, 123124]
# GNI.MinusRank: GNI minus HDI rank [-84, 47]
# GII.Rank: Gender inequality index rank [1, 188]
# GII: Gender inequality index [0.02, 0.74]
# Mat.Mor: Maternal mortality ratio [1, 1100]
# Ado.Birth: Adolescent birth rate [0.6, 204.8]
# Parli.F: Female representation in parliament (percent) [0, 58]
# Edu2.F: Population with secondary education (female) [0.9, 100]
# Edu2.M: Population with secondary education (male) [3, 100]
# Labo.F: Labour force participation rate (female) [14, 88]
# Labo.M: Labour force participation rate (female) [44, 96]
# Edu2.FM: Female/male secondary education ratio [0.2, 1.5]
# Labo.FM: Female/male labour force participation ratio [0.2, 1.0]
str(human)
summary(human)

# only select these 9 variables
human <- select(human, c("Country", "Edu2.FM", "Labo.FM", 
                         "Edu.Exp", "Life.Exp", "GNI", 
                         "Mat.Mor", "Ado.Birth", "Parli.F"))

# exclude all rows with undefined values
human <- na.omit(human)

# remove regions (last 7 rows), leaving just countries
human <- head(human, -7)

# 155 x 9
dim(human)

# save the data set to disk (overwrite)
write_csv(human, "./data/human.csv")
