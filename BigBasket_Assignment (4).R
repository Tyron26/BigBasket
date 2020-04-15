install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)

################################################
## Import the data
################################################

DT = read.csv("BigBasket.csv")
dim(DT)
#################################
## Data Cleaning
#################################

# Retain the /rows have no missing values across all the columns
DT <- DT[complete.cases(DT), ]
DT= DT[!is.na(DT$Description),]
dim(DT)

# Drop the commas in the item name
# It would cause confusion for the basket analysis packages
DT$Items = gsub(",", " ", DT$Description)

DropList <- c('Other Vegetables', 'Other Dals')
DT = DT[!(DT$Description %in% DropList), ]

#######################################
## Prepare the data into a suitable
## format for the packages to work with
#######################################
# Create a basket data (BD)
# Concatenate the transaction items (paste function), and separate them by comma
BD = aggregate(Items~Order, data = DT, paste, collapse = ",")

head(BD)
## Drop the Order variable
BD$Order = NULL

## To process the data in arules, you should export the BD data, and import
## it using read.transactions() fucntion

write.csv(BD,"BD_Basket.csv", quote = FALSE, row.names = FALSE)

# Import the data again using read.transactions() fucntion
BDarules <- read.transactions("BD_Basket.csv", format = 'basket', sep=',')

# Now BDarules is ready for arules package to process. 
