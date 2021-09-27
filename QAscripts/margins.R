customer_data <- data.frame(gender = c("m", "f", "f", "f"), conversion = c("y", "n", "y", "y"))
(customer_table <- table(customer_data))
## No margin
prop.table(customer_table)
# Same as division by sum over all values:
customer_table / sum(customer_table)

## Row margin = 1
prop.table(customer_table,1)
# Same as division by sum over each row
customer_table / rowSums(customer_table)
# `apply` also takes a margin and applies a function to the corresponding dimension
# t() swaps rows and columns to get the same output format
t(apply(customer_table, 1, function(row) row / sum(row)))

## Column margin = 2
prop.table(customer_table,2)
# Same as division by sum over each column
apply(customer_table, 2, function(col) col / sum(col))
