## ------------------------------------------------------------------------------------------------------------------------------------------------
# <- this is a comment and is ignored by the R-interpreter
seq(from = 1, to = 10) #creates sequence from 1 to 10
seq(1,10) #same result


## ------------------------------------------------------------------------------------------------------------------------------------------------
seq(to = 10,from = 1) #produces desired results
seq(10,1) #produces reversed sequence


## ------------------------------------------------------------------------------------------------------------------------------------------------
# Only run for the first time:
# install.packages("tidyverse")
# Run to load package:
library("tidyverse")
# Now we can use functionality provided by "tidyverse"
# We will see in the coming lectures how the following code works:
ggplot(economics, aes(x = date, y = pop)) +
  geom_line()


