# Description
# This data gives peak accelerations measured at various observation stations for 23 earthquakes 
# in California. The data have been used by various workers to estimate the attenuating affect of 
# distance on ground acceleration.



# [,1]	event	numeric	Event Number
# [,2]	mag	numeric	Moment Magnitude
# [,3]	station	factor	Station Number
# [,4]	dist	numeric	Station-hypocenter distance (km)
# [,5]	accel	numeric	Peak acceleration (g)


# ++++++++++++++++++ cerinta 1  ++++++++++++++++++ 
model <- attenu
plot(model)

#variabila event
event <- model$event
medie <- mean(event)
medie
varianta <- var(event)
varianta
q1 = quantile(event, 1/4)
q1
q2 = quantile(event, 2/4)
q2
q3 = quantile(event, 3/4)
q3
q4 = quantile(event, 4/4)
q4
mdn = median(event, na.rm = FALSE)
mdn #mediana este egala cu a doua quartila

#variabila mag
mag <- model$mag
medie <- mean(mag)
medie
varianta <- var(mag)
varianta
q1 = quantile(mag, 1/4)
q1
q2 = quantile(mag, 2/4)
q2
q3 = quantile(mag, 3/4)
q3
q4 = quantile(mag, 4/4)
q4
mdn = median(mag, na.rm = FALSE)
mdn #mediana este egala cu a doua quartila

#variabila station 
#nu calculez mean si var pt factor
station <- model$station

#variabila dist
dist <- model$dist
medie <- mean(dist)
medie
varianta <- var(dist)
varianta
q1 = quantile(dist, 1/4)
q1
q2 = quantile(dist, 2/4)
q2
q3 = quantile(dist, 3/4)
q3
q4 = quantile(dist, 4/4)
q4
mdn = median(dist, na.rm = FALSE)
mdn #mediana este egala cu a doua quartila

#variabila accel
accel <- model$accel
medie <- mean(accel)
medie
varianta <- var(accel)
varianta
q1 = quantile(accel, 1/4)
q1
q2 = quantile(accel, 2/4)
q2
q3 = quantile(accel, 3/4)
q3
q4 = quantile(accel, 4/4)
q4
mdn = median(accel, na.rm = FALSE)
mdn #mediana este egala cu a doua quartila

#boxplot
#boxplot(ist, data = attenu, main = "dist", horizontal = TRUE)
boxplot(dist ~ accel, data = attenu,  main = "dist - accel")
boxplot(accel ~ dist, data = attenu, main = "accel - dist")
boxplot(dist ~ mag, data = attenu, main = "dist - mag")
boxplot(mag  ~ dist, data = attenu, main = "mag - dist")



# ++++++++++++++++++ cerinta 2  ++++++++++++++++++ 
#regresie simpla
cor(attenu$mag, attenu$dist)
cor(attenu$dist, attenu$mag)
#cor(attenu$mag, attenu$accel)
#cor(attenu$accel, attenu$mag)
#cor(attenu$dist, attenu$accel)
#cor(attenu$accel, attenu$dist)

library(e1071)
par(mfrow=c(1, 2))  # divide graph area in 2 columns
plot(density(attenu$mag), main="Density Plot: mag", ylab="Frequency", sub=paste("Skewness:",
            round(e1071::skewness(attenu$mag), 2)))  # density plot for 'mag'
polygon(density(attenu$mag), col="red")
plot(density(attenu$dist), main="Density Plot: dist", ylab="Frequency", sub=paste("Skewness:",
            round(e1071::skewness(attenu$dist), 2)))  # density plot for 'dist'
polygon(density(attenu$dist), col="red")

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
par(mfrow = c(1, 1))
linearModMD <- lm(mag ~ dist, data = attenu) 
plot(x = dist, y = mag, col = "red")
abline(linearModMD, col = "blue")
ggplotRegression(linearModMD)

linearModMD <- lm(dist ~ mag, data = attenu) 
plot(x = mag, y = dist, col = "red")
abline(linearModMD, col = "blue")
ggplotRegression(linearModMD)

#regresie multipla
mag <- attenu$mag
dist <- attenu$dist
accel <- attenu$accel
event <- attenu$event

linMod <- lm(mag ~ dist + accel + event)
summary(linMod)
layout(matrix(c(1, 2, 3, 4), 2, 2)) # 4 graphs per page
plot(linMod)

linMod <- lm(dist ~ mag + accel + event)
summary(linMod)
layout(matrix(c(1, 2, 3, 4), 2, 2)) # 4 graphs per page
plot(linMod)



# ++++++++++++++++++++ cerinta 3 +++++++++++++++

# Weibull distribution
layout(matrix(c(1, 2), 1, 2))
# seq(from, to, by= )
t <- seq(0, 3.5, 1/10000)
#valori diferite ale parametrilor 
# Density
plot(t, dweibull(t, 0.5, 1), pch = ".", col = 2)
lines(t, dweibull(t, 1, 1), pch = ".", col = 3)
lines(t, dweibull(t, 1.5, 1), pch = ".", col = 4)
lines(t, dweibull(t, 5, 1), pch = ".", col = 5)
# distribution function
plot(t, pweibull(t, 0.5, 1), pch = ".", col = 2)
lines(t, pweibull(t, 1, 1), pch = ".", col = 3)
lines(t, pweibull(t, 1.5, 1), pch = ".", col = 4)
lines(t, pweibull(t, 5, 1), pch = ".", col = 5)


# Repartitia Weibull este folosita la:
# * analizele de fiabilitate, cum ar fi calculul timpului mediu pâna la defectarea unui dispozitiv.
# * prezicerea schibarilor tehnologice
# * in hidrologie, pentru evenimente extreme precum maxima anual a unei zile de precipitatii, debitul unui rau
# * meteorologie, pentru a descrie distributia vanturilor
# * strangerea de informatii de pe un site web - modeleaza timpul de cautare pe un site
# * asigurari generale, pentru a prezice revendicarile de reasigurare

