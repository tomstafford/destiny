# ---------- you need this library for calculating beta weights
#if(!require(QuantPsyc)){install.packages("QuantPsyc")}
#library(QuantPsyc)

" #this is the internals of the lm.betas function
betas <- function (MOD) 
{
    b <- summary(MOD)$coef[-1, 1]
    sx <- sd(MOD$model[-1])
    sy <- sd(MOD$model[1])
    beta <- b * sx/sy
    return(beta)
}
"
        
# ---------- Setting Path
setwd("/home/tom/Dropbox/university/expts/destiny")

#load the data
dat = read.csv("forR.csv")

#regression model
slope.lm <- lm(CR_slope ~ max_plays + space25 + assists_rate+ grimZ+ eventEntropy25, data = dat)
summary(slope.lm)

#beta weights - the easy way - if you have installed QuantPsych
#lm.beta(slope.lm)

#print(dat$CR_slope)

#the hard way
datZ <- data.frame
datZ <- dat$CR_slope
datZ$CR_intercept<-scale(dat$CR_intercept,center=TRUE,scale=TRUE)
datZ$CR_slope<-scale(dat$CR_slope,center=TRUE,scale=TRUE)
datZ$max_plays<-scale(dat$max_plays,center=TRUE,scale=TRUE)
datZ$space25<-scale(dat$space25,center=TRUE,scale=TRUE)
datZ$assists_rate<-scale(dat$assists_rate,center=TRUE,scale=TRUE)
datZ$grimZ<-scale(dat$grimZ,center=TRUE,scale=TRUE)
datZ$eventEntropy25<-scale(dat$eventEntropy25,center=TRUE,scale=TRUE)

slope.lmZ <- lm(CR_slope ~ max_plays + space25 + assists_rate+ grimZ+ eventEntropy25, data = datZ)

summary(slope.lmZ)


write.csv(summary(slope.lmZ)$coefficients[,1], file = "slope_betas.csv")
write.csv(summary(slope.lmZ)$coefficients[,2]*1.96,file="slope_se.csv")

intercept.lmZ <- lm(CR_intercept ~ max_plays + space25 + assists_rate+ grimZ+ eventEntropy25, data = datZ)

summary(intercept.lmZ)


write.csv(summary(intercept.lmZ)$coefficients[,1], file = "intercept_betas.csv")
write.csv(summary(intercept.lmZ)$coefficients[,2]*1.96,file="intercept_se.csv")

