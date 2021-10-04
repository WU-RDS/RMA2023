small_value <- 0.0000000000000000000001
not_small_value <- 0.001
large_value <- 10000000000000000000000
not_large_value <- 100
small_value
not_small_value
large_value
not_large_value
# You want all digits to be shown: bias towards fixed notation
options(scipen = 999)
small_value
not_small_value
large_value
not_large_value
# You want shorter output: bias towards scientific notation
options(scipen = -3)
small_value
not_small_value
large_value
not_large_value

# `scipen = 0` will print the number and up to 4 characters (-1 -> 3, etc) (including the `.`) in fixed notation
options(scipen = 0)
4 * 10^-3
4 * 10^4

4 * 10^-4
4 * 10^5

# With -5 even single digit numbers are printed in scientific notation 1 * 10^0
options(scipen = -5)
1

options(scipen = -4)
1
10
