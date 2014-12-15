noaafile<-"StormData.csv.bz2"
##download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",noaafile)
noaadtraw<-read.csv(bzfile(noaafile))
cols<-c("BGN_DATE","STATE","EVTYPE","FATALITIES","INJURIES","PROPDMG","PROPDMGEXP","CROPDMG","CROPDMGEXP","REFNUM")
noaadt<-noaadtraw[,cols]
summary(noaadt)

amtIdentifier<-c("","?","0","2","B","k","K","m","M")
amtIdentifier<-data.frame(sym=c("","-","?","+","0","1","2","3","4","5","6","7","8","B","h","H","K","m","M"),
                          conv=c(0,0,0,0,0,0,0,0,0,0,0,0,0,1000000000,100,100,1000,1000000,1000000))

noaadtclean<-merge(noaadt,amtIdentifier,by.x="PROPDMGEXP",by.y="sym")
##change the column name
names(noaadtclean)[11]<-"PROPDMGEXPCONV"

noaadtclean<-merge(noaadtclean,amtIdentifier,by.x="CROPDMGEXP",by.y="sym")
##change the column name
names(noaadtclean)[12]<-"CROPDMGEXPCONV"

##now apply thousand,million multiplier to Property and Crop data
noaadtclean[,"PROPDMG"]<-noaadtclean[,"PROPDMG"]*noaadtclean[,"PROPDMGEXPCONV"]
noaadtclean[,"CROPDMG"]<-noaadtclean[,"CROPDMG"]*noaadtclean[,"CROPDMGEXPCONV"]

##Since one the of the questions is about economic damage add the property damage and crop damage into variable
EcoDamage<-noaadtclean[,"PROPDMG"] + noaadtclean[,"CROPDMG"]
noaadtclean<-cbind(noaadtclean,EcoDamage)

##Since one the of the questions is about Health damage add the fatalities and injuries into variable
HealthHarm<-noaadtclean[,"INJURIES"] + noaadtclean[,"FATALITIES"]
noaadtclean<-cbind(noaadtclean,HealthHarm)

noaadtclean$Month<-format(as.Date(noaadtclean[,3],format="%m/%d/%Y"), "%b")
noaadtclean$Year<-format(as.Date(noaadtclean[,3],format="%m/%d/%Y"), "%Y")

##plot(x=noaadtclean$BEG_DATE,y=noaadtclean$EVTYPE,type="h")


