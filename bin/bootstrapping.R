library(boot)
#https://www.statmethods.net/advstats/bootstrapping.html
rsq <- function(formula, data, indices) { # r squared statistic only, can pick other things
  d <- data[indices,] # allows boot to select sample
  fit <- lm(formula, data=d)
  return(summary(fit)$r.square)
} 

results <- boot(data=mtcars, statistic=rsq,R=10, formula=mpg~wt+disp)
results1 <- boot(data=mtcars, statistic=rsq,R=100, formula=mpg~wt+disp)
results2 <- boot(data=mtcars, statistic=rsq,R=1000, formula=mpg~wt+disp)
results3 <- boot(data=mtcars, statistic=rsq,R=10000, formula=mpg~wt+disp)

plot(results)
plot(results1)
plot(results2)
plot(results3)

boot.ci(results3, type="bca")
mtcars
