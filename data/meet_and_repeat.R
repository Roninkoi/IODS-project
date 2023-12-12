# Roni Koitermaa 10.12.2023
# Create BPRS (brief psychiatric rating scale) and RATS (rat growth) data sets.

library(tidyverse)
library(dplyr)
library(tidyr)

bprs <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ", header = T)
rats <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="\t", header = T)

# explore structure and dimensions of BPRS data
# 40 rows, 11 variables
dim(bprs)
# treatment: treatment group
# subject: subject id
# week0-week8: brief psychiatric rating scale measured every week of treatment (0-8)
# based on 18 variables (each ranging 1-7)
str(bprs)
# summary of variables (BPRS per week)
summary(bprs)

# explore structure and dimensions of RATS data
# 16 rows, 13 variables
dim(rats)
# ID: rat id
# Group: diet group rat belongs to
# WD1, WD8, WD15, WD22, WD29, WD36, WD43, WD44, WD50, WD57, WD64: body weight
# of rat (grams) taken on days 1-64.
str(rats)
# summary of variables (weight per day)
summary(rats)

# convert to categorical variables
bprs$subject <- as.factor(bprs$subject)
bprs$treatment <- as.factor(bprs$treatment)
rats$ID <- as.factor(rats$ID)
rats$Group <- as.factor(rats$Group)

# convert BPRS to long form, sort by week
bprs_long <- pivot_longer(bprs, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  mutate(week = as.integer(substr(weeks, 5, length(weeks)))) %>%  arrange(week)

# convert RATS to long form, sort by time
rats_long <- pivot_longer(rats, cols = -c(ID, Group),
                          names_to = "Days", values_to = "Weight") %>%
  mutate(Time = as.integer(substr(Days, 3, length(Days)))) %>% arrange(Time)

# examine structure of long forms
# 360 rows, 5 variables (treatment, subject, weeks, bprs, week)
str(bprs_long)
# 176 rows, 5 variables (ID, Group, Days, Weight, Time)
str(rats_long)

# instead of summaries for a certain week/day, we now have summaries over all time
# BPRS in range [18, 95], mean 37.66
summary(bprs_long)
# Weight in range [225, 628], mean 384.5
summary(rats_long)

# write to disk
write_csv(bprs_long, "./data/bprs.csv")
write_csv(rats_long, "./data/rats.csv")
