library(ggstatsplot)
set.seed(1)
mydata <- data.frame(counts = rpois(100, 50000))

# The `binwidth` controls the range over which the number of observations are counted
# If it is too small only very few observations will be aggregated in each bin
gghistostats(
  data = mydata, 
  x = counts,
  binwidth = 2, # => too small
)

# If all/most of the observations are in a few bins the bindwith might be too large
gghistostats(
  data = mydata, 
  x = counts, binwidth = 1000, # => too large
)

# We get a much better summary by choosing an appropriate binwidth 
# What an appropriate bin width is depends on the data
gghistostats(
  data = mydata, 
  x = counts, binwidth = 100, # => appropriate
)


