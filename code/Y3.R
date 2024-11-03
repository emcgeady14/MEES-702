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
