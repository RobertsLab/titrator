### Load filename for downstream use
cal_data_file <- '2018-03-16T10_19_31_pH_calibration_7_4_10_T303.csv'

# Extract calibration date.
# Uses substring to parse out original data format, followed by gsub to remove dashes.
cal_date <- gsub('-', '', substr(cal_data_file, 1, 10))

# Extract LabX task ID value from filename.
cal_task <- substr(cal_data_file, 43, as.numeric(nchar(cal_data_file) - 4))


### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
cal_data <- read.table(cal_data_file, header = FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(cal_data_file, sep = ',')) - 1)), fill = TRUE)

### Set constants
## headers
# t = time (s)
# E = voltage (mV)
# T = temperature (C)
pH_data_headers <- c("t", "E", "T")

pH_buffers <-c(4, 7, 10) #Vector of pH buffers used for calibration.
pH3.5_3.0 <-c(3.5, 3.0) #Vector of titration endpoint pH values


### Calculate mean voltages (E) for each pH buffer; this data is in column 2
mean_E_pH4.0 <- mean(as.numeric(cal_data[202:231,2]))
mean_E_pH7.0 <- mean(as.numeric(cal_data[169:198,2]))
mean_E_pH10.0 <- mean(as.numeric(cal_data[235:264,2]))

### Determine y intercept and slope of best fit line
# Calculate mean voltages (E) of each buffer
buffers_mean_E <-c(mean_E_pH4.0, mean_E_pH7.0, mean_E_pH10.0)

# Run linear model of voltages and corresponding pH buffer
model<-lm(buffers_mean_E ~ pH_buffers)

# Use coef of model to extract the best fit slope ((model)[2]) and y intercept ((model)[1]).
# Use those values (voltages in mV = E) to determine voltages for pH3.5 & pH3.0
E_pH3.5_3.0 <- coef(model)[2]*pH3.5_3.0+coef(model)[1]