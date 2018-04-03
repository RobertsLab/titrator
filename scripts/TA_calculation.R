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
A10_concentration <- 0.100215 #mol/kg


#Enter voltage cutoffs
#These values are constants.
pH3.0 <- 228.57
pH3.5 <- 200

# mols to umols conversion

mol_to_umol <- 1000000

# Sample mass (grams)
mass1 <- 50.001
mass2 <- 50.0118
mass3 <- 50.0011
mass4 <- 
mass5 <- 
mass6 <- 
mass7
mass8

#Read files
data1 <- read_csv(file = "20180206_IO01_bubbling.csv")
data2 <- read.csv(file = "20180206_IO02_bubbling.csv")
data3 <- read.csv(file = "20180206_IO03_bubbling.csv")
data4 <- read.csv(file = "")
data5 <- read.csv(file = "")
data6 <- read.csv(file = "")
data7 <- read.csv(file = "")
data8 <- read.csv(file = "")

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
