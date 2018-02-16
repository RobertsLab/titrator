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


# Determine y intercept and slope of best fit line

pH_buffers <-c(4, 7, 10)
pH3.5_3.0 <-c(3.5, 3.0)
buffers_E <-c(168.8, -5.5, -182.2)

model<-lm(buffers_E ~ pH_buffers)
coef(model)[2]*pH3.5_3.0+coef(model)[1]
