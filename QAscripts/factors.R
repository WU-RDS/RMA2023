group <- c("C", "B", "B", "A")
group <- factor(group, 
                levels = c("A", "B", "C"), 
                labels = c("Group A", "Group B", "Group C"))
group

# 1. mistake: some groups are not named in `levels` and `labels`
group <- c("C", "B", "B", "A")
group <- factor(group, 
                levels = c("A", "B"), 
                labels = c("Group A", "Group B"))
group

# 2. mistake: the code creating the factor is run twice overwriting the original variable
group <- c("C", "B", "B", "A")
group <- factor(group, 
                levels = c("A", "B", "C"), 
                labels = c("Group A", "Group B", "Group C"))
levels(group) # Not the original ones!!!
group <- factor(group, 
                levels = c("A", "B", "C"), 
                labels = c("Group A", "Group B", "Group C"))
group

# Remedy: use as.factor and fct_recode  
group <- c("C", "B", "B", "A")
group <- as.factor(group)
group <- as.factor(group)
group

library(forcats)
group <- fct_recode(group, "Group C" = "C", "Group A" = "A")
group
group <- fct_recode(group, "Group C" = "C", "Group A" = "A")
group

# 3. mistake : converting from `factor` to `integer`/`numeric` directly
values <- c(42, 34, 56)
values <- as.factor(values)
as.numeric(values)

# Remedy: Convert to character first
as.numeric(as.character(values))
