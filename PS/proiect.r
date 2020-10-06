# Description
# This data gives peak accelerations measured at various observation stations for 23 earthquakes 
# in California. The data have been used by various workers to estimate the attenuating affect of 
# distance on ground acceleration.



# [,1]	event	numeric	Event Number
# [,2]	mag	numeric	Moment Magnitude
# [,3]	station	factor	Station Number
# [,4]	dist	numeric	Station-hypocenter distance (km)
# [,5]	accel	numeric	Peak acceleration (g)

head(attenu)

# check the data class of the variables
sapply(attenu, data.class)


# 1
# mean
attenuEventMean <- mean(attenu$event) #mean event
attenuMagMean <- mean(attenu$mag) #mean mag 
attenuDistMean <- mean(attenu$dist) #mean dist
attenuAccelMean <- mean(attenu$accel) #mean accel


class(attenu$station) #factor
levels(attenu$station) #117 levels
length(levels(attenu$station)) #117

is.ordered(attenu$station) #false

#variance 
attenuEventVar <- var(attenu$event) #var event
attenuMagVar <- var(attenu$mag) #var mag
attenuDistVar <- var(attenu$dist) #var dist
attenuAccelVar <- var(attenu$accel) #var accel

#taking care of missing data
#attenu$station = ifelse(is.na(attenu$station), 
#                        ave(attenu$station, FUN = function(x) mean(x, na.rm = TRUE)),
#                        attenu$station) #if na is in station we replace it with the mean of existing values


#quartiles 
QEvent <- quantile(attenu$event) #quartiles event
QMag <- quantile(attenu$mag) #quartiles mag
QDist <- quantile(attenu$dist) #quartiles dist
QAccel <- quantile(attenu$accel) #quartiles attenu


boxplot(attenu, xlab = "attenu variables", ylab = "")

boxplot(attenu$event, horizontal = TRUE, main = "attenu event")
boxplot(attenu$mag, horizontal = TRUE, main = "attenu mag")
boxplot(attenu$dist, horizontal = TRUE, main = "attenu dist")
boxplot(attenu$accel, horizontal = TRUE, main = "attenu accel")

#dataSet <- attenu[,c('event','mag', 'station', 'dist', 'accel')]

# 2
# build linear regression models
linearModMD <- lm(mag ~ dist, data = attenu) 
print(linearModMD)
linearModMA <- lm(mag ~ accel, data = attenu)
print(linearModMA)
linearModDA <- lm(dist ~ accel, data = attenu)
print(linearModDA)

linearModDM <- lm(dist ~ mag, data = attenu)
print(linearModDM)
linearModAM <- lm(accel ~ mag, data = attenu)
print(linearModAM)
linearModAD <- lm(accel ~ dist, data = attenu)
print(linearModAD)



#mag ~ dist 
linearMod <- linearModMD
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
#modelCoeffs
#print(modelCoeffs)
std.error <- modelCoeffs["dist", "Std. Error"]  # get std.error for dist
beta.estimate <- modelCoeffs["dist", "Estimate"]  # get beta estimate for dist
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorMD = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)



# mag ~ accel
linearMod <- linearModMA
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
#modelCoeffs
std.error <- modelCoeffs["accel", "Std. Error"]  # get std.error for accel
beta.estimate <- modelCoeffs["accel", "Estimate"]  # get beta estimate for accel
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorMA = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)



# dist ~ accel
linearMod <- linearModDA
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
std.error <- modelCoeffs["accel", "Std. Error"]  # get std.error for accel
beta.estimate <- modelCoeffs["accel", "Estimate"]  # get beta estimate for accel
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorDA = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)

# dist ~ mag
linearMod <- linearModDM
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
std.error <- modelCoeffs["mag", "Std. Error"]  # get std.error for mag
beta.estimate <- modelCoeffs["mag", "Estimate"]  # get beta estimate for mag
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorDM = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)


# accel ~ mag
linearMod <- linearModAM
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
std.error <- modelCoeffs["mag", "Std. Error"]  # get std.error for mag
beta.estimate <- modelCoeffs["mag", "Estimate"]  # get beta estimate for mag
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorAM = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)

# accel ~ dist
linearMod <- linearModAD
modelSummary <- summary(linearMod)  # capture model summary as an object
r.squared <- modelSummary$r.squared #r squared
adjr.squared <- modelSummary$adj.r.squared #adjusted r squared
f_statistic <- summary(linearMod)$fstatistic[1]  # fstatistic
modelCoeffs <- modelSummary$coefficients  # model coefficients
std.error <- modelCoeffs["dist", "Std. Error"]  # get std.error for dist
beta.estimate <- modelCoeffs["dist", "Estimate"]  # get beta estimate for dist
t_value <- beta.estimate / std.error  # calc t statistic
aic <- AIC(linearMod)
bic <- BIC(linearMod)
p_value <- 2 * pt(-abs(t_value), df = nrow(attenu) - ncol(attenu))  # calc p Value
f <- summary(linearMod)$fstatistic  # parameters for model p-value calc
model_p <- pf(f[1], f[2], f[3], lower = FALSE)
vectorAD = c(r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic,
             p_value)

print("r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic, p_value")

#calculez cele mai bune valori din vectori
bestr.squared <- max(vectorMD[1], vectorMA[1], vectorDA[1], vectorDM[1], vectorAM[1], vectorAD[1])
bestAdjr.squared <- max(vectorMD[2], vectorMA[2], vectorDA[2], vectorDM[2], vectorAM[2], vectorAD[2])
bestf_statistic <- max(vectorMD[3], vectorMA[3], vectorDA[3], vectorDM[3], vectorAM[3], vectorAD[3])
beststd.error <- min(abs(c(vectorMD[4], vectorMA[4], vectorDA[4], vectorDM[4], vectorAM[4], vectorAD[4]))) # closest to 0
bestAic <- min(vectorMD[6], vectorMA[6], vectorDA[6], vectorDM[6], vectorAM[6], vectorAD[6])
bestBic <- min(vectorMD[7], vectorMA[7], vectorDA[7], vectorDM[7], vectorAM[7], vectorAD[7])

bestr.squared
bestAdjr.squared
bestf_statistic
beststd.error
bestAic
bestBic

print("r.squared, adjr.squared, f_statistic, std.error, t_value, aic, bic, p_value")
vectorMD
vectorMA
vectorDA
vectorDM
vectorAM
vectorAD

# 3 of best values are for linearModMD and 3 for lindearModAD
plot(mag ~ dist, data = attenu)
abline(linearModMD)
library(ggplot2)
ggplot(attenu, aes(x = dist, y = mag)) + geom_point() + stat_smooth(method = "lm", col = "navy")


#However, we can create a quick function that will pull the data out of a linear regression, 
#and return important values (R-squares, slope, intercept and P value) at the top of a nice ggplot 
#graph with the regression line.
ggplotRegression <- function (fit) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("Adj R2 = ", signif(summary(fit)$adj.r.squared, 5), 
                       "Intercept =", signif(fit$coef[[1]],5 ),
                       " Slope =", signif(fit$coef[[2]], 5),
                       " P =", signif(summary(fit)$coef[2,4], 5))) #row 2 column 4
  # paste - concatenate strings
  # signif rounds the values in its first argument to the specified number of significant digits.
}

ggplotRegression(linearModMD)
ggplotRegression(linearModDM)
ggplotRegression(linearModMA)
ggplotRegression(linearModAM)
ggplotRegression(linearModDA)
ggplotRegression(linearModAD)

summary(linearModMD)$coef[[1]]