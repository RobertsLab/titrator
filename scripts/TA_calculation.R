###############
# THIS IS INCOMPLETE
# USABLE, BUT POOR - REQUIRES DATA GROOMING BY HAND
#
#
#
###############

#install.packages("seacarb")
#install.packages("XLConnect")
#install.packages("XLConnectJars")
#install.packages("tidyverse")



library(seacarb)
library(XLConnect)
library(tidyverse)

# Set working directory.
# Will need to be altered based on user and computing operating system.
setwd("c:/Users/sam/Downloads/")

# Acid titrant constants
#Batch A10
A10_density <- function(temperature) {
  1.02882 - (0.0001067*temperature) - (0.0000041*(temperature)^2)
}
A10_concentration <- 0.100215 #mol/kg


#Enter voltage cutoffs
#These values are constants.
pH3.0 <- 228.57
pH3.5 <- 200

# mols to umols conversion

mol_to_umol <- 1000000

# Load file
## Enter path to desired titration data file.
data_file <- '2018-03-16T12_55_28_TA_titration_T306.csv'

# Column headers
# V is volumen in mL
# t is time in seconds
# E is voltage in mV
# T is temperature in C
# dV/dT is change in voltage divided by change in temperature
headers <- c("V", "t", "E", "T", "dV/dT", "S", "weight")


### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
data1 <- read.table(data_file, header = FALSE, stringsAsFactors = FALSE, na.strings = "NaN", fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(data_file, sep = ',')))), fill = TRUE)


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
# Stores as a list, which will be useful for assigning data to each sample name later on.
sample_names <- substr(sample_list, 14, as.numeric(nchar(sample_list))-1)
sample_names_list <- list()
for (item in 1:length(sample_names)){
  sample_names_list[[item]] <- sample_names[item]
}

### Extract samples weights

# Pulls the weight field by searching for rows with "Sample size".
weights_with_units <- data1[grep("^Sample size", data1$V1), 2]

# Determines the string length by converting to characters and counting the characters.
# Uses grep to search for rows in column 1 that begin with "Sample size".
# Subtracts two from character length to account for "<space>g" at end of entry.
weight_char_counts <- weights_with_units %>% 
  nchar() %>% 
  as.numeric() - 2

# Removes the last two characters from the weight field (<space>g)
# of each entry in the weights_with_units vector.
sample_weights <- as.numeric(substr(weights_with_units,1,weight_char_counts))


### Parse out necessary info from two-part titration

# Identify rows that contain "TitrationEP1" text in column 2
EP1_titrations_rows <- grep("^TitrationEP1", data1$V2)
# Identify rows that contain "TitrationEP2" text in column 2
EP2_titrations_rows <- grep("^TitrationEP2", data1$V2)

# Create list of endpoint 1 (EP1) titrations
# Will be used to store EP1 final volumes
EP1_Vf <- list()
for (row in 1:length(EP1_titrations_rows)){
  EP1_Vf[[row]] <- paste("EP1_Vf_", row, sep = "")
}

# Pull out final EP1 volumes
# Final EP1 volumes are the row before the beginning of each EP2 titration data set; thus, subtract "1" from each EP2 titration row value
for (item in 1:length(EP1_titrations_rows)){
  EP1_Vf[[item]]<- data1[(EP2_titrations_rows[item]-1), 1]
}

#Convert EP1_Vf values to numeric.
EP1_Vf <- sapply(EP1_Vf, as.numeric)


### Parse out EP2 data.

# Beginning of data == EP2 row#+2
# End of data == the next EP1 titration row - 2
# UNLESS
# Last entry - which selects to end of file (e.g. tail(data1, (nrow(data1))
for (item in 1:length(EP2_titrations_rows)){
  if (item == length(EP2_titrations_rows)){
    sample_names_list[[item]]<- tail(data1, (nrow(data1) - (EP2_titrations_rows[item]+1)))
  } else {
    sample_names_list[[item]]<- data1[(EP2_titrations_rows[item]+2):(EP1_titrations_rows[item+1]-2),]
  }
}


# Convert all data frames in sample_names_list to numeric
# Add column names (headers) to each data frame in sample_names_list list
for (item in 1:length(sample_names_list)){
  sample_names_list[[item]] <- as.data.frame(sapply(sample_names_list[[item]], as.numeric))
  colnames(sample_names_list[[item]]) <- headers
}


# Determine total acid added to each sample
# First, start to loop through each data frame in the sample_names_list
# For each data frame:
# - set acid volume
# - calculate the acid added in the final titration
# - while loop to:
# -- calculate cumulative acid added at each titration endpoint
# - determine final cumulative acid amount and assign to last row of data frame
# -- write output file for each sample to current directory
for (item in 1:length(sample_names_list)){
  total_acid_vol <- EP1_Vf[[item]]
  final_acid_addition <- sample_names_list[[item]][nrow(sample_names_list[[item]]), "V"] - sample_names_list[[item]][(nrow(sample_names_list[[item]]) - 1), "V"]
  row <- 1
  while (row < nrow(sample_names_list[[item]])){
    total_acid_vol <- total_acid_vol + ((sample_names_list[[item]][row+1, "V"] - sample_names_list[[item]][row, "V"]))
    sample_names_list[[item]][row, "V"] <- total_acid_vol
    row <- row + 1
  }
  sample_names_list[[item]][nrow(sample_names_list[[item]]), "V"] <- total_acid_vol + final_acid_addition
}




# Use dplyr library to filter data for use in seacarb library:
# temperature data (T) and convert to vector (.$T)
# potential data (T) and convert to vector (.$E)
# volume data (V) and convert to vector (.$V)

data1_T <- data1 %>%filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data1_E <- data1 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data1_volume <- data1 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data2_T <- data2 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data2_E <- data2 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data2_volume <- data2 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data3_T <- data3 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data3_E <- data3 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data3_volume <- data3 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data4_T <- data4 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data4_E <- data4 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data4_volume <- data4 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data5_T <- data5 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data5_E <- data5 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data5_volume <- data5 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data6_T <- data6 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data6_E <- data6 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data6_volume <- data6 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data7_T <- data7 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data7_E <- data7 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data7_volume <- data7 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V

data8_T <- data8 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
data8_E <- data8 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
data8_volume <- data8 %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V


#Calculates TA for designated sample
TA_01 <- mol_to_umol*(at(S=33.481, T=data1_T, C=A10_concentration, d=A10_density, weight=mass1, E=data1_E, volume=data1_volume))
TA_02 <- mol_to_umol*(at(S=33.481, T=data2_T, C=A10_concentration, d=A10_density, weight=mass2, E=data2_E, volume=data2_volume))
TA_03 <- mol_to_umol*(at(S=33.481, T=data3_T, C=A10_concentration, d=A10_density, weight=mass3, E=data3_E, volume=data3_volume))
TA_04 <- mol_to_umol*(at(C=A10_concentration, d=A10_density, S=35, T=data4_T, weight=mass4, E=data4_E, volume=data4_volume))
TA_05 <- mol_to_umol*(at(C=A10_concentration, d=A10_density, S=35, T=data5_T, weight=mass5, E=data5_E, volume=data5_volume))
TA_06 <- mol_to_umol*(at(C=A10_concentration, d=A10_density, S=35, T=data6_T, weight=mass6, E=data6_E, volume=data6_volume))
TA_07 <- mol_to_umol*(at(C=A10_concentration, d=A10_density, S=35, T=data7_T, weight=mass7, E=data7_E, volume=data7_volume))
TA_08 <- mol_to_umol*(at(C=A10_concentration, d=A10_density, S=35, T=data8_T, weight=mass8, E=data8_E, volume=data8_volume))
