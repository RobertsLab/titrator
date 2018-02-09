library(seacarb)
library(XLConnect)
library(tidyverse)

# Set working directory.
# Will need to be altered based on user and computing operating system.
setwd("c:/Users/sam/gitrepos/RobertsLab/titrator/data/titration_data/")

# Acid titrant constants
#Batch A10
A10_density <- 1.02449 #g/cm^3
A10_concentration <- 0.100215 #mol/kg


#Enter voltage cutoffs
#These values are constants.
pH3.0 <- 228.57
pH3.5 <- 200

# mols to umols conversion

mol_to_umol <- 1000000


data1 <- read.csv(file = "2018-02-09T11_53_39_TA_titration_T215.csv", header = FALSE, stringsAsFactors = FALSE)

# Pulls total sample number from Row 2, Col. 2, position 11.
# Converts from string to number.
# Data export must be Raw Data & Total Measured Values.
total_samples <- as.numeric(data1[2,2] %>% substr(11,11))



### Extracts weight from first sample



# Pulls the weight field by searching for rows with "Sample size".
weights_with_units <- data1[grep("^Sample size", data1$V1), 2]

# Then determines the string length by converting to characters and counting the characters.
# Subtracts two from character length to account for <space>g at end of entry.
weight_char_counts <- data1[grep("^Sample size", data1$V1), 2] %>% 
  nchar() %>% 
  as.numeric() - 2

# Removes the last two characters from the weight field (<space>g)
sample_weights <- as.numeric(substr(weights_with_units,1,weight_char_counts))
                             



