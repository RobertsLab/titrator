#
# This script is currently under development.
# It is non-functional.
# 20180206 SJW
#


#################
#install.packages("tidyverse")
#install.packages("whoami")

# Load necessary libraries. 
library(whoami)
library(tidyverse)

# Extracts current Windows username.
win_user <- username()

# Set working directory to titrator calibration data Git repo.
setwd(file.path("c:/Users/", win_user, "/gitrepos/RobertsLab/titrator/data/cal_data/"))

# Set up list/array comparisons of files in folder.

# Operate on newly added file.


cal_data_file <- 'data/cal_data/example_pH_calibration.csv'


### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
cal_data <- read.table(cal_data_file, header = FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(cal_data_file, sep = ',')) - 1)), fill = TRUE)

# Set constants
pH_buffers <-c(4, 7, 10) #Vector of pH buffers used for calibration.
pH3.5_3.0 <-c(3.5, 3.0) #Vector of titration endpoint pH values

# Calculate mean voltages (E) for each pH buffer
mean_E_pH4.0
mean_E_pH7.0
mean_E_pH10.0


# Determine y intercept and slope of best fit line

buffers_E <-c(168.8, -5.5, -182.2)

model<-lm(buffers_E ~ pH_buffers)
coef(model)[2]*pH3.5_3.0+coef(model)[1]
