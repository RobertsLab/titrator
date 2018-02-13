library(seacarb)
library(XLConnect)
library(tidyverse)
library(whoami)

# Extracts current Windows username.
win_user <- username()

### Set working directory.
# Set working directory to titration data Git repo.
setwd(file.path("c:/Users/", win_user, "/gitrepos/RobertsLab/titrator/data/titration_data"))

# Acid titrant constants
#Batch A10
A10_density <- 1.02449 # g/cm^3
A10_concentration <- 0.100215 # mol/kg

# CRM constants
#Batch 168
CRM168_TA <- 2207.62 # umol/kg
CRM168_salinity <- 33.481 # PSU (~g/kg)


#Enter voltage cutoffs
#These values are constants.
pH3.0 <- 228.57
pH3.5 <- 200

# mols to umols conversion

mol_to_umol <- 1000000

data_file <- '2018-02-09T14_50_38_TA_titration_T232.csv'

data1 <- read.table(data_file, header = FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(data_file, sep = ',')) - 1)), fill = TRUE)





# Pulls total sample number from Row 2, Col. 2, position 11.
# Converts from string to number.
# Data export must be Raw Data & Total Measured Values.
total_samples <- as.numeric(data1[2,2] %>% substr(11,11))



### Extracts weight from first sample



# Pulls the weight field by searching for rows with "Sample size".
weights_with_units <- data1[grep("^Sample size", data1$V1), 2]

# Then determines the string length by converting to characters and counting the characters.
# Subtracts two from character length to account for "<space>g" at end of entry.
weight_char_counts <- data1[grep("^Sample size", data1$V1), 2] %>% 
  nchar() %>% 
  as.numeric() - 2

# Removes the last two characters from the weight field (<space>g)
sample_weights <- as.numeric(substr(weights_with_units,1,weight_char_counts))
                             



