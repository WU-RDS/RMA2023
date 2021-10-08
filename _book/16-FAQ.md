---
output:
  html_document: 
    toc: yes
    df_print: paged
  html_notebook: default
  pdf_document:
    toc: yes
---
<link rel="stylesheet" type="text/css" media="all" href="style.css" />



# (PART) FAQ {-}

# FAQ

In this section, we provide answers to questions that students of previous cohorts encountered. We grouped the answers by topic and hope that you will find the answers useful.  


## Common error messages

<img src="./images/off_on.jpg" width="40%" style="display: block; margin: auto;" />

### A general note on error messages {-}

We usually load data into a `data.frame` in our R Session (e.g., from a CSV file using `data <- read.csv("file.csv")`). It is important to note that this `data.frame` is not the original data file, but just a copy of the file that is stored on the hard drive. This means that any changes we make to the `data.frame` are **not** persistent/permanent and are **not** written to the original file (unless it is overwritten explicitly by using e.g., `write.csv(data, "file.csv")`, which we usually don't do). Therefore, it is important to write all commands in an R/Rmd file such that we can re-run the analysis the next time we open R and reproduce the results. This also means that if you cannot solve an issue using the suggested solutions to specific error messages mentioned on this page, it is completely safe to restart R or delete variables from the Global Environment. You just have to re-run our code to get the variables and results back. Therefore, your code files should always be fully reproducible using only the R/Rmd and data files. In addition your R/Rmd files should run linearly from the first to the last line and should not depend on "jumping" back and forth. The files that you obtain from us from this course are examples of reproducible files and in case you a stuck with a problem at a certain point, you can just save the code file and run it again up until the point where you were before the error occurred.   

This means that a general procedure for dealing with errors that cannot be solved in any other way would be as follows:

1. Save your code file and restart your R Session (Session -> Restart R in RStudio)
2. Go back to the beginning of your code file and run it line by line (`Ctrl-Enter` in RStudio)
3. If your error persists check the affected line for typos/differences in spelling. 
4. If the error occurs in a function make sure you are passing the arguments correctly (see help file for the function using `?FUNCTIONNAME`)
5. Look at all the variables in your Global Environment and make sure they are in the format you expect them to be (e.g., if a file you expect to be a data frame is really a specified as a data frame). 
6. See the list of common error messages for more explanations below 
7. Nothing helped: Ask in the forum. If possible with a screenshot that explains your issue, or - better yet - a [minimal reproducible example](https://community.rstudio.com/t/faq-how-to-do-a-minimal-reproducible-example-reprex-for-beginners/23061). 

In the following capitalized words are stand-ins for specific calls/symbols/functions.

### Error in file(file, "rt"): cannot open the connection {-}

This error message sometimes has an additional warning:

```
In addition: Warning message:
In file(file, "rt") :
  cannot open file 'FILE': No such file or directory
```

This error occurs either when a file name is not spelled correctly or the file is not in the directory where R is looking for it. You can check the directory R is looking at by executing the function `getwd()`. To set a new directory use `setwd(DIRECTORY)`. Note that you **cannot** just paste a path from Windows Explorer to `setwd` since the directory has to be in the format:

`setwd("C:/Users/USERNAME/Documents")` 

but Windows Explorer uses

`C:\Users\USERNAME\Documents` (i.e., change `\` to `/` in R when specifying the path)

Alternatively, you can set the directory in RStudio under Session -> Set Working Directory. Here "To Source File Location" will set the directory to wherever the currently open R file is stored.   

### Error: unexpected 'SYMBOL' in "CALL" {-}

Usually the `unexpectes SYMBOL` message is due to parentheses not being matched but it could also be any other symbol that R cannot interpret in the given context. Please check the line in which the error occurred for typos (especially too many/ too few symbols). Some common examples are:


```r
print("hello"))
```

```
## Error: <text>:1:15: unexpected ')'
## 1: print("hello"))
##                   ^
```
There is one too many closing parenthesis here. 


```r
1 +/ 2 # Too many symbols
```

```
## Error: <text>:1:4: unexpected '/'
## 1: 1 +/
##        ^
```
The "/" symbol may not follow the "+" symbol without any additional objects.


```r
1 2 # Missing symbol
```

```
## Error: <text>:1:3: unexpected numeric constant
## 1: 1 2
##       ^
```
The sequence with a space between numbers is not recognized by R. 


```r
x <- 3
2x # Missing symbol
```

```
## Error: <text>:2:2: unexpected symbol
## 1: x <- 3
## 2: 2x
##     ^
```
If you wanted to multiply x by 2 you would need to a the "*" symbol, as the following example shows. 



```r
2*x
```

```
## [1] 6
```

### Error in CALL : object of type 'closure' is not subsettable {-}

This error occurs usually when one tries to subset a function (either with `fun$element` or `fun[1]` where `fun` is a function). Check your variable (especially `data.frames`) names for typos! This happens when you run the following code, for example, since `mean` is a function:


```r
# Does not work:
means <- data.frame(value = c(1,2,3))
mean$value
```

```
## Error in mean$value: object of type 'closure' is not subsettable
```

instead of (i.e., correcting for the missing "s" to identify the data frame by its name)


```r
# Works:
means <- data.frame(value = c(1,2,3))
means$value
```

```
## [1] 1 2 3
```

or we give variables the same name as a function (which should generally be avoided) but have not created that variable yet:


```r
summary(aov)[[1]]
```

```
## Error in object[[i]]: object of type 'closure' is not subsettable
```

Make sure all the relevant code is run first:


```r
dat <- data.frame(value = c(1,2,3), group = c("a", "b", "b"))
aov <- aov(value~group, dat)
summary(aov)[[1]]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["Df"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Sum Sq"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["Mean Sq"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["F value"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["Pr(>F)"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"1.5","3":"1.5","4":"3","5":"0.3333333","_rn_":"group"},{"1":"1","2":"0.5","3":"0.5","4":"NA","5":"NA","_rn_":"Residuals"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

### Error in CALL_WITH_$: $ operator is invalid for atomic vectors {-}

This error occurs when we try to subset a vector using the `$` operator. Usually this occurs when we think an object is a `data.frame` with the variable in it but it is really a vector.


```r
x <- c(1,2,3)
x$a
```

```
## Error in x$a: $ operator is invalid for atomic vectors
```



```r
xdf <- data.frame(a = x)
xdf$a
```

```
## [1] 1 2 3
```

Note that this error can also occur as part of function calls when some variables are `NA`:


```r
library(psych)
xdf$group <- NA
mean(xdf$a, xdf$group)
```

```
## Error in mean.default(xdf$a, xdf$group): 'trim' must be numeric of length one
```

When you get this error make sure your data is in the format you expect it to be (e.g., using the `str` function). And that missing values (i.e., NA) are handles appropriately. 


```r
str(xdf)
```

```
## 'data.frame':	3 obs. of  2 variables:
##  $ a    : int  1 2 3
##  $ group: logi  NA NA NA
```
### Error in CALL: object 'NAME' not found {-}

This error occurs whenever you pass a variable name that is not assigned to some function. The error is for example:

`Error in plot(x): object 'x' not found`

If you just enter a variable name that is not assigned it looks like this:

`Error: object 'NAME' not found`

Check your code for typos and make sure you have run all the relevant lines of code before the one in which the error occurs!

### Error in CALL: could not find function "FUNCTION" {-}

This error occurs if a function name is either misspelled or some packages have not been loaded into the current session (`library(PACKAGENAME)`). You have to re-load all packages every time you restart R. For example if you **did not** load the `ggplot2` library but try to use the `ggplot` function:


```
## Error in detach(package:ggplot2): invalid 'name' argument
```


```r
ggplot(data)
```

```
## Error in ggplot(data): could not find function "ggplot"
```

If you are not sure which package provides a given function, try running:

`??FUNCTION`

with two `??` this will search the help files of all installed packages for `FUNCTION` (e.g., `??ggplot`).

### Error in CALL: incorrect number of dimension {-}

This error occurs when subsetting an object with the wrong number of dimension. For example if we have a vector `x` and try to get an element in the second dimension:


```r
x <- c(1,2,3)
x[1,1]
```

```
## Error in x[1, 1]: incorrect number of dimensions
```


```r
x[1]
```

```
## [1] 1
```

Note that `data.frame`s have two dimensions (each variable is a column, each observation a row) even if there is only one variable:


```r
x <- c(1,2,3)
data.frame(x)[1, 1]
```

```
## [1] 1
```

For multidimensional objects you can always check the size of each dimension using the `dim` function:


```r
dim(data.frame(x))
```

```
## [1] 3 1
```

For vectors `dim` will return `NULL`.


## Installation of R packages

### What are the different ways to install R packages? {-}

There are multiple ways to install a package:

* Enter `install.packages("PACKAGENAME")` in the console (attention: the name of the package needs to be in quotation marks)
* Go to the "Packages" pane in RStudio (lower right by default), then click on "Install", then enter the package name
* Using the two methods above would load the package from the official R server, the so-called Comprehensive R Archive Network (CRAN). There may be instances when you would like to install packages from other sources. This could be the case, for example, when a package is not available for the version of R that you are using. Sometimes an new version of R is released and some packages may require updating to be compatible with this new version. The updating process on the official server may take some time and usually the most recent version of a package are available from other sources, such as GitHub. Using the `devtools` package, you can install packages from GitHub directly: `devtools::install_github(repo = "USERNAME/PACKAGENAME")`. Of course, this requires the `devtools` package to be installed already; i.e., you need to run `install.packages("devtools")` first, if the `devtools` package is not installed yet. 

### I cannot install packages due to "Error in contrib.url(repos, "source")" or "Warning message: package ‘PACKAGENAME’ is not available for this version of R" {-}

1. Try adding the `repo` argument to the `install.packages` command as in the following example:

```R
install.packages("PACKAGENAME", repo="https://cloud.r-project.org/")
```

2. Try to install the package from GitHub directly using the `devtools` package.

For example to get the `devtools` package and install the `ggstatsplot` package from the GitHub-user `IndrajeetPatil` run the following code:

```R
install.packages("devtools")
devtools::install_github(
  repo = "IndrajeetPatil/ggstatsplot", # package path on GitHub ("username/packagename")
  dependencies = TRUE, # installs packages which ggstatsplot depends on
  upgrade_dependencies = TRUE # updates any out of date dependencies
)
```

3. In case you are using `knit`ting process of a R Markdown file, you should not install any packages from within the markdown file. Instead, install the packages first using a plain R script file and then load the package within the markdown file before clicking `knit` to compile the document.

### Some libraries with graphical output (e.g., summarytools, magick) fail to install/load properly on MacOS {-}

Some libraries require the [XQuartz](https://www.xquartz.org) window system for MacOS. After installing [XQuartz](https://www.xquartz.org) please restart your computer. If you get an error message including a message about the `magick` package try `install.packages("magick")` and if that fails `devtools::install_github("ropensci/magick", dependencies = TRUE)` might help.

### I cannot install some packages on MacOS {-}

1. When asked whether R should try to install a package from sources a package which needs compilation, enter "no" or "n".


<img src="./images/error.png" width="70%" style="display: block; margin: auto;" />

2.  If this doesn't solve the issue, try installing the free XCode package from the Apple Appstore, open a Terminal and enter "xcode-select --install". After that try to install the package again (answering "yes" to the question above). 

## Issues with statistics and data

### Why does a multi-item scale lead to increased reliability? {-}

"When combining several items into a scale, random error that is inherent in every item is averaged out, which leads to increased levels of reliability". There could, for example, be individual-level differences in the interpretation of certain items. When you have multiple items measuring the same underlying construct, these differences will average out. 

See [Diamantopoulos, Sarstedt, Fuchs, et al. (2012)](https://link.springer.com/article/10.1007/s11747-011-0300-3)

### Why can demeaning/standardization lead to missing values? {-}

Calculating statistics (e.g., mean, sd) using variables that include `NA`s will return an `NA` by default. There are a couple of options to address this problem. The missing values can be deleted from a variable using the `na.omit` function. Alternatively many functions offer the `na.rm` argument which will calculate the statistic disregarding `NA`s. For example, the following will result in NA: 


```r
x <- c(1,2,3, 5, NA)
mean(x)
```

```
## [1] NA
```
While the following disregards the NA values when computing the mean of the numeric vector: 


```r
x <- c(1,2,3, 5, NA)
mean(x, na.rm = TRUE)
```

```
## [1] 2.75
```

Note that the `scale` function automatically omits missing values when calculating the mean and standard deviation to standardize a variable.

See [missings.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/missings.R) for a sample script.

### The confidence interval (CI) of the mean seems very small compared to the dispersion of my sample. Can this be correct?  {-}

The confidence interval of the mean depends on both the variance of the variable and the the sample size:

$$
\sigma_{\bar x} = \frac{\sigma}{\sqrt{n}}
$$

Therefore even if the standard deviation of the data ($\sigma$) is large, we can get a narrow CI if we have a relatively large sample size.

See [confidenceinterval.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/confidenceinterval.R) for a simulation study.

## Errors related to specific methods

### Logistic regression {-}

#### When using logistic regression: Error in eval(family$initialize) : y values must be 0 <= y <= 1 {-}

When using logistic regression make sure all the values in the dependent variable (left hand side) are between $0$ and $1$


```r
dat <- data.frame(y = c(2,0,1), x = c(1,2,3))
glm(y ~ x , data = dat, family=binomial())
```

```
## Error in eval(family$initialize): y values must be 0 <= y <= 1
```

### When using logistic regression: Error in weights * y : non-numeric argument to binary operator {-}

This error occurs if a variable that is supposed to be numeric is a character


```r
dat$char_y <- c("1", "0", "1")
glm(char_y ~ x , data = dat, family=binomial())
```

```
## Error in weights * y: non-numeric argument to binary operator
```

## General settings and options

### Numbers are formatted weirdly {-}

By default R uses [scientific notation](https://en.wikipedia.org/wiki/Scientific_notation) for very large and very small numbers. We can control this behavior using `options(scipen=...)` where larger positive numbers will result in a wider range of values being printed in fixed notation (i.e., all digits) and negative numbers will result in more numbers being printed in scientific notation.

From `?options` we get:

> **scipen:**
integer. A penalty to be applied when deciding to print numeric values in fixed or exponential notation. Positive values bias towards fixed and negative towards scientific notation: fixed notation will be preferred unless it is more than scipen digits wider.

Scientific notation follows the following rule: $VeD \Rightarrow V \times 10^D$. 

Therefore, `options(scipen=-10)` would result in:


```r
options(scipen=-10)
29.3749592384
```

```
## [1] 2.937496e+01
```

And `options(scipen=10)` would result in:


```r
options(scipen=10)
29.3749592384
```

```
## [1] 29.37496
```

See also [scientificnotation.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/scientificnotation.R) for some examples.

Note that `options(digits=...)` also allows you to control the number of digits to be displayed for numeric values:


```r
options(digits = 12)
29.3749592384
```

```
## [1] 29.3749592384
```

## Data visualization/output issues

### How can the `geom` colors in a `ggplot` be changed? {-}

In general, there are two types of colors that can be changed. The `color` argument changes the line or border color (e.g., in a bar chart). The `fill` argument changes the filling color of a plot that has a rectangle-like area (e.g., barplot, histogram,  boxplot) that can be filled but does nothing for e.g., line plots. 

Colors can be specified either as an argument to the `ggplot` or `geom*` call directly as in `ggplot(data, aes(x = Genre, y = Freq), color = c("red", "green",...))` or as part of the aesthetics (`aes`). In the latter case, colors will automatically be assigned and a legend added if a categorical variable is provided as in `ggplot(table_plot_rel, aes(x = Genre,y = Freq, fill = Genre)) + geom_col()`. 

This is not to be confused with setting background/text colors as part of a theme. Themes can either be provided by a package (e.g., `library(ggthemes)`) or created by hand.

See [ggplotcolors.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/c3d8eb74b8ccd971318fb30f6ad5e7a4b04a7f93/QAscripts/ggplotcolors.R) for a sample script.

### Why are some histograms displayed differently? {-}

When plotting a histogram, there is an important parameter called `binwidth` which controls the range over which the number of observations are counted in each bin. If it is set to a too low value, each bin will only have very few observations and we get a large number of bins. If it is set to a value that is too high, we lump many observations together and get very few bins (in the extreme case only one). You may have to play around with different values to find the appropriate binwidth for your plot.  

See [histogrambins.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/histogrambins.R) for some examples.

### Some labels in plots are cut off. How can I extend the plot margins? {-}

If axis labels (e.g. names) are too long, they are cut off by the default margins of R plots. You can set margins manually in `ggplot2` as part of the `theme` settings in the following order: top, right, bottom, left. For example, to add 2cm margin to each side, we can use: 


```r
my_ggplot + 
  theme(plot.margin = margin(2, 2, 2, 2, "cm"))
```

In addition you can try to change the height and width when saving a ggplot (this usually works better):


```r
ggsave("myggplot.png", width = 10, height = 10, units = "cm")
```

Within an Rmd document you can set the with and height as part of the code chunk options using e.g., `fig.width=10, fig.height=10` [(see also here)](#rchunk)


## Issues with functions and function arguments

Generally, if you face an issue relating to a particular function, it is a good idea to check the details of a function, by typing `?FUNCTION` (e.g., `?mean`) and read the help file.

### Problems with `factor` and `as.factor` {-}

**1. Common mistake:** some groups are not named in `levels` and `labels` $\Rightarrow$ results in `NA` for omitted group like in the following example: 


```r
x <- c(0,0,0,1,0,2,0,1)
x <- factor(x, levels = c(0,1), labels = c("no","yes"))
x
```

```
## [1] no   no   no   yes  no   <NA> no   yes 
## Levels: no yes
```

In this example, you need to also consider "2" as a factor level to avoid setting the value of this observation to NA:


```r
x <- c(0,0,0,1,0,2,0,1)
x <- factor(x, levels = c(0,1,2), labels = c("no","yes","maybe"))
x
```

```
## [1] no    no    no    yes   no    maybe no    yes  
## Levels: no yes maybe
```

**2. Common mistake:** the code creating the factor is run twice overwriting the original variable $\Rightarrow$ results in `NA` for all values like in the following example:


```r
x <- c(0,0,0,1,0,2,0,1)
x <- factor(x, levels = c(0,1,2), labels = c("no","yes","maybe"))
x <- factor(x, levels = c(0,1,2), labels = c("no","yes","maybe"))
x
```

```
## [1] <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
## Levels: no yes maybe
```
As can be seen, by running the line of code specifying the factor variable twice, we first specify the factor variable correctly and then incorrectly overwrite this variable again. The second time we run the code, the values are set to NA because R looks from levels of 0,1, and 2 again, but these had already been replaced by the labels when the code was run for the first time. Hence, since there are no elements with the values of 0,1,2 anymore, these values are replaced by missing values.   

Note that this is usually a result of "jumping" back and forth in the code. Run your script from the top and make sure you do not create the factor twice. The second time the original levels do not exist anymore and thus all resulting values are missing without warning or error.

**Possible remedy**: name the factor variable you create differently from the source variable, e.g., 


```r
x <- c(0,0,0,1,0,2,0,1)
y <- factor(x, levels = c(0,1,2), labels = c("no","yes","maybe"))
y
```

```
## [1] no    no    no    yes   no    maybe no    yes  
## Levels: no yes maybe
```

In this case, you can always go back and re-run the code creating the factor variable from its original source if you have overwritten it accidentally. Otherwise you would need to re-run the entire code to get the original formating of the variable back. 

**3. Common mistake:** converting from `factor` to `integer`/`numeric` directly:

Internally factors are stored in increasing integers starting at $1$ each attached with a `label`. If we create a factor from an integer variable and then convert it back, this behavior might be surprising. 

**Possible remedy**: convert to `character` first since this will use the `label`s as values

See [factors.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/factors.R) for examples of each of the mistakes and remedies.

### How can I find an explanation of the output of a function? {-}

See the **Value** section of the help file for the function. You can get the help file by calling:

`?FUNCTION`

e.g.,

`?lm` or `?mean`

If the function is provided by a package you have to load the package first using the `library(...)` function. 
e.g.,


```r
library(Hmisc)
?rcorr 
```

### What does the `MARGIN` argument do? {-}

Some functions such as `apply` and `prop.table` take a `MARGIN` argument. This argument specifies over which dimension (e.g., rows = 1, columns = 2) a function should be applied. This is especially useful for multidimensional arrays such as matrices.


```r
m <- matrix(1:9, nrow=3)
m
```

```
##      [,1] [,2] [,3]
## [1,]    1    4    7
## [2,]    2    5    8
## [3,]    3    6    9
```

 e.g. we could get the `max` of each *row* with


```r
apply(m, 1, max)
```

```
## [1] 7 8 9
```

and the `max` of each *column* with


```r
apply(m, 2, max)
```

```
## [1] 3 6 9
```

See [margins.R](https://raw.githubusercontent.com/WU-RDS/MRDA2021/main/QAscripts/margins.R) for more examples.

## Issues with R Markdown

### I get an error when `knit`ting to PDF but it works for HTML  {-}

Try installing the `tinytex` library as follows before `knit`ing your document:


```r
install.packages('tinytex')
tinytex::install_tinytex()
```

### I am not sure where R-code, LaTeX math, and text go  {-}

In an Rmd document, there are 3 different environments, <a name="rchunk"></a>

**1. R-code** is enclosed in three ticks followed by \{r, [chunk-options](https://rmarkdown.rstudio.com/lesson-3.html#chunk-options)\} where the chunk options can include configuration for printing code and output as well as figures e.g.

> \```{r, echo = TRUE, warnings = FALSE}
> 
> print("Hello R!)
> 
> ```


```r
print("Hello R!")
```

```
## [1] "Hello R!"
```

**2. LaTeX math** can either be enclosed in single dollar signs \$x^2\$ $\Rightarrow x^2$ for in-line math or
in double dollar signs to put the math output on its own line

```  
$$ 
x^2
$$
``` 

$$
x^2
$$

For aligned multi-line equations we can add `\begin{aligned}` and `\end{aligend}`. The equations will be aligend at the `&` and a line is ended with `\\`.

    $$
    \begin{aligned}
    x &= 1 \\
    y &= 2 \\
    z = &3
    \end{aligned}
    $$

$$
\begin{aligned}
x &= 1 \\
y &= 2 \\
z = &3
\end{aligned}
$$

**3. Regular text** goes anywhere between those environments

## New questions

Couldn't find an answer to your question? In this case, you may use the forum on Learn\@wu to ask your question. We regularly update this section of the website and will   
