
times <- data.frame(
    hours = c(rgamma(100,10, 1), rgamma(100, 15,1), rgamma(100, 30,1)), 
    group = c(rep("LONGNAME", 100), rep("B", 100), rep("C", 100))
    )
anova <- aov(hours~group, data=times)
library(multcomp)
anova$model$group <- as.factor(anova$model$group)
tukeys <- glht(anova, linfct = mcp(group = "Tukey"))
# if one of the groups has a long name it will not be shown correctly by default
plot(tukeys)
# we can change the margin using the `par` function with the `mar` argument
# The numbers are c(bottom, left, top, right)
par(mar=c(5,7,4,4))
plot(tukeys)
# This also works for other plots of course!
