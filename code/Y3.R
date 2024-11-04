#### Modifying and Combining Data Sets ####

# Stacking Data Sets using rbind ----
#The rbind function concatenates or stacks two or more datasets with all of the 
#same variables but different observations.

# specify the new data set in the left hand side, then list names of the old data
# sets you want to combine:

#newdataset <- rbind(data-set-1,...,data-set-n)

#All old datasets must contain the same set of variables and in the same order.

#loading in example data sets:
(southentrance <-read.table("./data/South.dat",
                            head =FALSE,col.names=c("Entrance","PassNumber","PartySize","Age")))
(northentrance<-read.table("./data/North.dat",
                           head =FALSE,col.names=c("Entrance","PassNumber","PartySize","Age","Lot")))

#southernentrance data is missing lot variable, fill with NA's:
southentrance$Lot <-NA
#now bind the two data sets into 1:
both <-rbind(southentrance,northentrance)

both$AmountPaid <-c(0,35,27)[cut(both$Age,breaks=c(-99,3,65,999),label=FALSE)]


# Interleaving data sets using merge ----
#we usually have similar sets of variables, not identical or not in the same order
# you instead can use merge to fill in missing values, change order, and combine data sets

# specify the new data set as a new object. Then add names of two old data sets.
#the order will be determined by the order of the list of old data sets
#if one data set has a variable the others don't, then NAs will be filled in
# new-data-set = merge(data-set-1, data-set-2, all=TRUE)

#all=TRUE denotes that all observations will be returned, whether they are from 
#the first or the second data set. 

interleave <- merge(southentrance, northentrance, all = TRUE)

#Combining data sets using a one-to-one match merge ----

# when you want to match observations from two data sets, combine them into one
#important to have a matching variable to ensure the observations stay together
# example: merge patient data with billing data, you would use the patient ID as a matching variable.

#First name the new data set to hold the results, follow with a merge function, and
#list the data sets to be combined. Use the by argument to indicate the common variables:
# new-data-set = merge(data-set-1,data-set-2, by=variable-list)

#read in two matched data sets:
descriptions <- read.fwf("./data/Chocolate.dat",
                         widths = c(4, 10, 46),
                         col.names = c("CodeNum", "Name", "Description"))
descriptions <- na.omit(descriptions)

sales <- read.table("./data/chocsales.dat", header = FALSE,
                    col.names = c("CodeNum", "PiecesSold"))

#merge by common variable, codenum
merge(sales,descriptions, by = "CodeNum", all = T)
#all obs included whther they matched or not

# Combining data sets using a one-to-many match merge ----
# Sometimes you need to combine two data sets by matching one observation from one data set with more than one
 #observation in another. For example: many obs for one site

#  new-data-set=merge(data-set-1, data-set-2, by = variable-list, all.x = T/F, all.y = T/F)

#The order of the data sets in the merge function matters. all.x=T and all.y=F mean that extra observations from
#data-set-1 will be added to the results, even if there is no matching observation in data-set-2 using the by variable.
#This is termed left outer join. all.x=F and all.y=T means the same for data-set-2, is termed right outer join. When both
#are ”T”, it is the default full outer join between two data frames.

regular <- read.fwf("./data/Shoe.dat", widths = c(15, 9, 6),
                    col.names = c("Style", "ExerciseType", "RegularPrice"))
regular <- na.omit(regular)
discount <- read.table("./data/Disc.dat", header = FALSE,
                       col.names=c("ExerciseType", "Adjustment"))

levels(regular$ExerciseType) <- levels(discount$ExerciseType)

prices <- merge(regular, discount, by="ExerciseType", all.x = TRUE)

prices$Newprice <- with(prices, round(RegularPrice * (1- Adjustment)))  #adjustment didn't get added in new data frame


# Merging summary statistics with original data ----
# summarize your data using aggregate, and put the results in a new dataset.
#Then merge the summarized data back with the original data using a one-to-many 
#match merge.

#example:
shoes <-read.fwf("./data/Shoesales.dat",
                 widths=c(15,9,6),col.names=c("Style","ExerciseType","Sales"))
shoes<-na.omit(shoes)

summarydata<-aggregate(Sales~ExerciseType,data=shoes,FUN=sum)  #function equals sum

names(summarydata)[2]<-"Total"  #column 2 named total, filled with sum
summarydata

#now combine with old data to calculate percentage of sales
shoesummary<-merge(shoes,summarydata,by="ExerciseType",all.x=TRUE)
shoesummary$Percent<-with(shoesummary,Sales*100/Total)
shoesummary #percentage of each type of shoe, by its type

#Adding Margins to a data set ----

#You may also need to summarize all variables corresponding to each observations, especially when all
#variables are recorded on the same scale. To do this,you will need to treat a data frame as a matrix and use 
#rowMeans function to average over the columns instead of rows, put the results in a new data set
#or combine it with the original

#for example with a data set of different people as the observations, and columns as the seasons
frame <-read.table("./data/sales.txt",header=TRUE,as.is="name")
#calculate each persons average sales and departure from grand mean:
people<-rowMeans(frame[,2:5]) #mean of columns 2-5
(peopleeffect <-people-mean(people)) #everyones means, averaged
#season means
(season<-colMeans(frame[,2:5]))
#dataframe to summarize seasonal effects
newrow<-frame[1,]
newrow[1,1]<-"SeasonalEffect"
newrow[1,2:5]<-season-mean(season)


newframe<-frame
newframe[,2:5]<-frame[,2:5]-mean(season)
data.frame(rbind(newframe,newrow),
           people=c(peopleeffect,mean(people)))

#Changing observations to variables using reshape2 ----
#now we can flip data, reshape2 transposes data sets turning obs into variables
#and variables into observations

#Example:
# you have data for baseball players and you have a column for type of data - 
#salary or batting average, you end up having multiple obs/per person
#we want to change batting average and salary into variables

library(reshape2)
baseball <- read.table("./data/Transpos.dat",
                       head = FALSE, col.names = c("Team", "Player", "Type", "Entry"))
#first use melt to add obs for each "entry", this makes data set longer
baseball.m <- melt(baseball,
                   idvars=c("Team", "Player", "Type"), measure.vars = "Entry")
head(baseball.m)

# The data are then transposed using the dcast function.
dcast(baseball.m, Team+Player~Type)
