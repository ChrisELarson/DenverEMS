library(tidyverse)
library(MASS)
library(lubridate)
library(AER)
library(caret)


#Missing Values resolved in this data set, Calls prefiltered
raw<- read.csv("C:\\Users\\Clars\\Desktop\\ProjectRawData\\all_vars_05_may.csv")

#Factoring Variables
cols<- c('broncos','rockies','nuggets','precip')

raw[,cols]<- data.frame(apply(raw[cols],2, as.factor))
raw$wday<-as.factor(raw$wday)
levels(raw$wday)<- c('Sun','Mon','Tues','Wed','Thurs',
                     'Fri','Sat')
raw$Hour<-as.factor(raw$Hour)
raw$Month<-as.factor(raw$Month)
raw$hr_index<-as.factor(raw$hr_index)

levels(raw$Month)<-c('Jan','Feb','Mar','Apr','May','Jun',
                     'Jul','Aug','Sep','Oct','Nov','Dec')
levels(raw$precip)<-c('F','T')
levels(raw$nuggets)<-c('n','y')
levels(raw$broncos)<-c('n','y')
levels(raw$rockies)<-c('n','y')

Full_Model<- glm.nb(n ~ Year + pick + hr_index + 
                      Temp + precip + broncos + rockies + nuggets 
                    + Spring + Summer + M_Th + Fri, data = raw)

with(Full_Model, cbind(res.deviance = deviance, df = df.residual, 
                   p = pchisq(deviance, df.residual, lower.tail = F)))

mHour<- glm.nb(n ~ Year + pick + Hour + 
                 Temp + precip + broncos + rockies + nuggets 
               + Spring + Summer + M_Th + Fri, data = raw)

interact<- glm.nb(n ~ Year + pick + Hour + 
                    Temp + precip + broncos + 
                    rockies + nuggets + M_Th + Fri 
                  + Temp*precip, data = raw)
 summary(interact)


with(mHour, cbind(res.deviance = deviance, df = df.residual, 
                       p = pchisq(deviance, df.residual, lower.tail = F)))

#StepwiseAIC
step.model<- stepAIC(interact, direction = 'both', trace = FALSE)
   summary(step.model)
 
#Final Variables   

FinalModel<- glm.nb(n ~ Year + pick + Hour + Temp + precip 
                    + broncos + M_Th + Fri + Temp*precip,
                    data = raw)
 summary(FinalModel)

GOF<- with(FinalModel, cbind(res.deviance = deviance, df = df.residual,
                        p = pchisq(deviance, df.residual, lower.tail = F)))
 
#Cross Validation, Full vs Base Vs Final
 
 train_control<- trainControl(method = 'cv', number = 10)
 
 Full<-train(n ~ Year + pick + Hour + Temp + precip +
               broncos + rockies + nuggets + M_Th +
               Fri + Temp*precip,
            data = raw,
            trControl = train_control,
            method = 'glm.nb')
 print(Full)
 
 Base<-train(n ~ Hour,
            data = raw,
            trControl = train_control,
            method = 'glm.nb')
 print(Base)
 
 Final<-train(n ~ Year + pick + Hour + Temp +
                precip + broncos + M_Th + Fri + Temp*precip,
              data = raw,
              trControl = train_control,
              method = 'glm.nb')
 print(Final)
 
 #Confidence Invertvals for the Final model
 CI<- cbind(Estimate = coef(FinalModel), confint(FinalModel))
  CI

hope<- cbind(summary(FinalModel)$coef,  confint(FinalModel))
 hope
#Incidence Rate Ratios
  round(exp(CI),8)
  



