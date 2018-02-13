install.packages("seacarb")
install.packages("whoami")
install.packages("tidyverse")
library(seacarb)
library(tidyverse)
library(whoami)

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


# Load file
data_file <- 'data/titration_data/example_data.csv'


### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
data1 <- read.table(data_file, header = FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(data_file, sep = ',')) - 1)), fill = TRUE)





# Pulls total sample number from Row 2, Col. 2, position 11.
# Converts from string to number.
# Data export must be Raw Data & Total Measured Values.
total_samples <- as.numeric(data1[2,2] %>% substr(11,11))


### Extract sample names

# Identifies rows starting with "Scope" in column 1
sample_name_positions <- grep("^Scope", data1$V1) 

# Subsets the entire data set based on a subset of sample_name_positions.
# Uses the length of the sample_name_positions vector divide by two because there are two entries per sample in the dataset.
sample_list <- data1[sample_name_positions[1:(length(sample_name_positions)/2)], 2] 

# Pulls out the actual sample names using the number of characters, minus 1 to get rid of ending ")" in cells, as the stop value for substr.
sample_names <- substr(sample_list, 14, as.numeric(nchar(sample_list))-1)


### Extracts weight from first sample



# Pulls the weight field by searching for rows with "Sample size".
weights_with_units <- data1[grep("^Sample size", data1$V1), 2]

# Ddetermines the string length by converting to characters and counting the characters.
# Uses grep to search for rows in column 1 that begin with "Sample size".
# Subtracts two from character length to account for "<space>g" at end of entry.
weight_char_counts <- weights_with_units %>% 
  nchar() %>% 
  as.numeric() - 2

# Removes the last two characters from the weight field (<space>g)
# of each entry in the weights_with_units vector.
sample_weights <- as.numeric(substr(weights_with_units,1,weight_char_counts))
                             




