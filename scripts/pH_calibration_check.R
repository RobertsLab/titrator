install.packages("tidyverse")
install.packages("whoami")
library(whoami)
library(tidyverse)

# Extracts current Windows username
win_user <- username()

# Set working directory to titrator calibration data Git repo.
setwd(file.path("c:/Users/", win_user, "/gitrepos/RobertsLab/titrator/data/cal_data/"))

