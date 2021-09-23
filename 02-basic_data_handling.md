---
output:
  html_document:
    toc: yes
  theme: united
  html_notebook: default
  pdf_document:
    toc: yes
---

# Data handling

This chapter covers the basics of data handling in R.

## Basic data handling

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/01-basic_data_handling.R)
:::

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/Q7AdksOeawU" frameborder="0" allowfullscreen></iframe>
</div>
<br>

### Creating objects

Anything created in R is an object. You can assign values to objects using the assignment operator ``` <-```:


```r
x <- "hello world" #assigns the words "hello world" to the object x
#this is a comment
```

Note that comments may be included in the code after a ```#```. The text after ```#``` is not evaluated when the code is run; they can be written directly after the code or in a separate line.

To see the value of an object, simply type its name into the console and hit enter:


```r
x #print the value of x to the console
```

```
## [1] "hello world"
```

You can also explicitly tell R to print the value of an object:


```r
print(x) #print the value of x to the console
```

```
## [1] "hello world"
```

Note that because we assign characters in this case (as opposed to e.g., numeric values), we need to wrap the words in quotation marks, which must always come in pairs. Although RStudio automatically adds a pair of quotation marks (i.e., opening and closing marks) when you enter the opening marks it could be that you end up with a mismatch by accident (e.g., ```x <- "hello```). In this case, R will show you the continuation character “+”. The same could happen if you did not execute the full command by accident. The "+" means that R is expecting more input. If this happens, either add the missing pair, or press ESCAPE to abort the expression and try again.

To change the value of an object, you can simply overwrite the previous value. For example, you could also assign a numeric value to "x" to perform some basic operations: 


```r
x <- 2 #assigns the value of 2 to the object x
print(x)
```

```
## [1] 2
```

```r
x == 2  #checks whether the value of x is equal to 2
```

```
## [1] TRUE
```

```r
x != 3  #checks whether the value of x is NOT equal to 3
```

```
## [1] TRUE
```

```r
x < 3   #checks whether the value of x is less than 3
```

```
## [1] TRUE
```

```r
x > 3   #checks whether the value of x is greater than 3
```

```
## [1] FALSE
```

Note that the name of the object is completely arbitrary. We could also define a second object "y", assign it a different value and use it to perform some basic mathematical operations:


```r
y <- 5 #assigns the value of 2 to the object x
x == y #checks whether the value of x to the value of y
```

```
## [1] FALSE
```

```r
x*y #multiplication of x and y
```

```
## [1] 10
```

```r
x + y #adds the values of x and y together
```

```
## [1] 7
```

```r
y^2 + 3*x #adds the value of y squared and 3x the value of x together
```

```
## [1] 31
```

<b>Object names</b>

Please note that object names must start with a letter and can only contain letters, numbers, as well as the ```.```, and ```_``` separators. It is important to give your objects descriptive names and to be as consistent as possible with the naming structure. In this tutorial we will be using lower case words separated by underscores (e.g., ```object_name```). There are other naming conventions, such as using a ```.``` as a separator (e.g., ```object.name```), or using upper case letters (```objectName```). It doesn't really matter which one you choose, as long as you are consistent.

### Data types

The most important types of data are:


Data type   | Description	 
-------------   | --------------------------------------------------------------------------
Numeric   | Approximations of the real numbers,  $\normalsize\mathbb{R}$ (e.g., mileage a car gets: 23.6, 20.9, etc.)
Integer   | Whole numbers,  $\normalsize\mathbb{Z}$ (e.g., number of sales: 7, 0, 120, 63, etc.)
Character   | Text data (strings, e.g., product names)
Factor    | Categorical data for classification (e.g., product groups)
Logical   | TRUE, FALSE
Date    | Date variables (e.g., sales dates: 21-06-2015, 06-21-15, 21-Jun-2015, etc.)

Variables can be converted from one type to another using the appropriate functions (e.g., ```as.numeric()```,```as.integer()```,```as.character()```, ```as.factor()```,```as.logical()```, ```as.Date()```). For example, we could convert the object ```y``` to character as follows:


```r
y <- as.character(y)
print(y)
```

```
## [1] "5"
```

Notice how the value is in quotation marks since it is now of type character. 

Entering a vector of data into R can be done with the ``` c(x1,x2,..,x_n)``` ("concatenate") command. In order to be able to use our vector (or any other variable) later on we want to assign it a name using the assignment operator ``` <-```. You can choose names arbitrarily (but the first character of a name cannot be a number). Just make sure they are descriptive and unique. Assigning the same name to two variables (e.g. vectors) will result in deletion of the first. Instead of converting a variable we can also create a new one and use an existing one as input. In this case we omit the ```as.``` and simply use the name of the type (e.g. ```factor()```). There is a subtle difference between the two: When converting a variable, with e.g. ```as.factor()```, we can only pass the variable we want to convert without additional arguments and R determines the factor levels by the existing unique values in the variable or just returns the variable itself if it is a factor already. When we specifically create a variable (just ```factor()```, ```matrix()```, etc.), we can and should set the options of this type explicitly. For a factor variable these could be the labels and levels, for a matrix the number of rows and columns and so on.  


```r
#Numeric:
top10_track_streams <- c(163608, 126687, 120480, 110022, 108630, 95639, 94690, 89011, 87869, 85599) 

#Character:
top10_artist_names <- c("Axwell /\\ Ingrosso", "Imagine Dragons", "J. Balvin", "Robin Schulz", "Jonas Blue", "David Guetta", "French Montana", "Calvin Harris", "Liam Payne", "Lauv") # Characters have to be put in ""

#Factor variable with two categories:
top10_track_explicit <- c(0,0,0,0,0,0,1,1,0,0)
top10_track_explicit <- factor(top10_track_explicit, 
                               levels = 0:1, 
                               labels = c("not explicit", "explicit"))

#Factor variable with more than two categories:
top10_artist_genre <- c("Dance","Alternative","Latino","Dance","Dance","Dance","Hip-Hop/Rap","Dance","Pop","Pop")
top10_artist_genre <- as.factor(top10_artist_genre)

#Date:
top_10_track_release_date <- as.Date(c("2017-05-24", "2017-06-23", "2017-07-03", "2017-06-30", "2017-05-05", "2017-06-09", "2017-07-14", "2017-06-16", "2017-05-18", "2017-05-19"))

#Logical
top10_track_explicit_1 <- c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE)  
```

In order to "call" a vector we can now simply enter its name:


```r
top10_track_streams
```

```
##  [1] 163608 126687 120480 110022 108630  95639  94690  89011  87869  85599
```

```r
top_10_track_release_date
```

```
##  [1] "2017-05-24" "2017-06-23" "2017-07-03" "2017-06-30" "2017-05-05"
##  [6] "2017-06-09" "2017-07-14" "2017-06-16" "2017-05-18" "2017-05-19"
```

In order to check the type of a variable the ```class()``` function is used.


```r
class(top_10_track_release_date)
```

```
## [1] "Date"
```

### Data structures

Now let's create a table that contains the variables in columns and each observation in a row (like in SPSS or Excel). There are different data structures in R (e.g., Matrix, Vector, List, Array). In this course, we will mainly use <b>data frames</b>. 

<p style="text-align:center;"><img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/dataframe.JPG" alt="data types" height="320"></p>

Data frames are similar to matrices but are more flexible in the sense that they may contain different data types (e.g., numeric, character, etc.), where all values of vectors and matrices have to be of the same type (e.g. character). It is often more convenient to use characters instead of numbers (e.g. when indicating a persons sex: "F", "M" instead of 1 for female , 2 for male). Thus we would like to combine both numeric and character values while retaining the respective desired features. This is where "data frames" come into play. Data frames can have different types of data in each column. For example, we can combine the vectors created above in one data frame using ```data.frame()```. This creates a separate column for each vector, which is usually what we want (similar to SPSS or Excel).


```r
music_data <- data.frame(top10_track_streams, 
                         top10_artist_names, 
                         top10_track_explicit, 
                         top10_artist_genre, 
                         top_10_track_release_date, 
                         top10_track_explicit_1)
```

#### Accessing data in data frames

When entering the name of a data frame, R returns the entire data frame: 


```r
music_data # Returns the entire data frame
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE"},{"1":"94690","2":"French Montana","3":"explicit","4":"Hip-Hop/Rap","5":"2017-07-14","6":"TRUE"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE"},{"1":"87869","2":"Liam Payne","3":"not explicit","4":"Pop","5":"2017-05-18","6":"FALSE"},{"1":"85599","2":"Lauv","3":"not explicit","4":"Pop","5":"2017-05-19","6":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Hint: You may also use the ```View()```-function to view the data in a table format (like in SPSS or Excel), i.e. enter the command ```View(data)```. Note that you can achieve the same by clicking on the small table icon next to the data frame in the "Environment"-window on the right in RStudio. 

Sometimes it is convenient to return only specific values instead of the entire data frame. There are a variety of ways to identify the elements of a data frame. One easy way is to explicitly state, which rows and columns you wish to view. The general form of the command is ```data.frame[rows,columns]```. By leaving one of the arguments of ```data.frame[rows,columns]``` blank (e.g., ```data.frame[rows,]```) we tell R that we want to access either all rows or columns, respectively. Here are some examples:  


```r
music_data[ , 2:4] # all rows and columns 2,3,4
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["top10_artist_names"],"name":[1],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[2],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[3],"type":["fct"],"align":["left"]}],"data":[{"1":"Axwell /\\\\ Ingrosso","2":"not explicit","3":"Dance"},{"1":"Imagine Dragons","2":"not explicit","3":"Alternative"},{"1":"J. Balvin","2":"not explicit","3":"Latino"},{"1":"Robin Schulz","2":"not explicit","3":"Dance"},{"1":"Jonas Blue","2":"not explicit","3":"Dance"},{"1":"David Guetta","2":"not explicit","3":"Dance"},{"1":"French Montana","2":"explicit","3":"Hip-Hop/Rap"},{"1":"Calvin Harris","2":"explicit","3":"Dance"},{"1":"Liam Payne","2":"not explicit","3":"Pop"},{"1":"Lauv","2":"not explicit","3":"Pop"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
music_data[ ,c("top10_artist_names", "top_10_track_release_date")] # all rows and columns "top10_artist_names" and "top_10_track_release_date"
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["top10_artist_names"],"name":[1],"type":["chr"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[2],"type":["date"],"align":["right"]}],"data":[{"1":"Axwell /\\\\ Ingrosso","2":"2017-05-24"},{"1":"Imagine Dragons","2":"2017-06-23"},{"1":"J. Balvin","2":"2017-07-03"},{"1":"Robin Schulz","2":"2017-06-30"},{"1":"Jonas Blue","2":"2017-05-05"},{"1":"David Guetta","2":"2017-06-09"},{"1":"French Montana","2":"2017-07-14"},{"1":"Calvin Harris","2":"2017-06-16"},{"1":"Liam Payne","2":"2017-05-18"},{"1":"Lauv","2":"2017-05-19"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
music_data[1:5, c("top10_artist_names", "top_10_track_release_date")] # rows 1 to 5 and columns "top10_artist_names"" and "top_10_track_release_date"
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_artist_names"],"name":[1],"type":["chr"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[2],"type":["date"],"align":["right"]}],"data":[{"1":"Axwell /\\\\ Ingrosso","2":"2017-05-24","_rn_":"1"},{"1":"Imagine Dragons","2":"2017-06-23","_rn_":"2"},{"1":"J. Balvin","2":"2017-07-03","_rn_":"3"},{"1":"Robin Schulz","2":"2017-06-30","_rn_":"4"},{"1":"Jonas Blue","2":"2017-05-05","_rn_":"5"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

You may also create subsets of the data frame, e.g., using mathematical expressions:


```r
  music_data[top10_track_explicit == "explicit",] # show only tracks with explicit lyrics  
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"94690","2":"French Montana","3":"explicit","4":"Hip-Hop/Rap","5":"2017-07-14","6":"TRUE","_rn_":"7"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
  music_data[top10_track_streams > 100000,] # show only tracks with more than 100,000 streams  
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","_rn_":"5"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
  music_data[top10_artist_names == 'Robin Schulz',] # returns all observations from artist "Robin Schulz"
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","_rn_":"4"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
  music_data[top10_track_explicit == "explicit",] # show only explicit tracks
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"94690","2":"French Montana","3":"explicit","4":"Hip-Hop/Rap","5":"2017-07-14","6":"TRUE","_rn_":"7"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The same can be achieved using the ```subset()```-function


```r
  subset(music_data,top10_track_explicit == "explicit") # selects subsets of observations in a data frame
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"94690","2":"French Montana","3":"explicit","4":"Hip-Hop/Rap","5":"2017-07-14","6":"TRUE","_rn_":"7"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
  #creates a new data frame that only contains tracks from genre "Dance" 
  music_data_dance <- subset(music_data,top10_artist_genre == "Dance") 
  music_data_dance
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","_rn_":"1"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","_rn_":"6"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
  rm(music_data_dance) # removes an object from the workspace
```

You may also change the order of the variables in a data frame by using the ```order()```-function


```r
#Orders by genre (ascending) and streams (descending)
music_data[order(top10_artist_genre,-top10_track_streams),] 
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","_rn_":"2"},{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","_rn_":"1"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","_rn_":"6"},{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"},{"1":"94690","2":"French Montana","3":"explicit","4":"Hip-Hop/Rap","5":"2017-07-14","6":"TRUE","_rn_":"7"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","_rn_":"3"},{"1":"87869","2":"Liam Payne","3":"not explicit","4":"Pop","5":"2017-05-18","6":"FALSE","_rn_":"9"},{"1":"85599","2":"Lauv","3":"not explicit","4":"Pop","5":"2017-05-19","6":"FALSE","_rn_":"10"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

#### Inspecting the content of a data frame

The ```head()``` function displays the first X elements/rows of a vector, matrix, table, data frame or function.


```r
head(music_data, 3) # returns the first X rows (here, the first 3 rows)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","_rn_":"3"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The ```tail()``` function is similar, except it displays the last elements/rows.


```r
tail(music_data, 3) # returns the last X rows (here, the last 3 rows)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]}],"data":[{"1":"89011","2":"Calvin Harris","3":"explicit","4":"Dance","5":"2017-06-16","6":"TRUE","_rn_":"8"},{"1":"87869","2":"Liam Payne","3":"not explicit","4":"Pop","5":"2017-05-18","6":"FALSE","_rn_":"9"},{"1":"85599","2":"Lauv","3":"not explicit","4":"Pop","5":"2017-05-19","6":"FALSE","_rn_":"10"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```names()``` returns the names of an R object. When, for example, it is called on a data frame, it returns the names of the columns. 


```r
names(music_data) # returns the names of the variables in the data frame
```

```
## [1] "top10_track_streams"       "top10_artist_names"       
## [3] "top10_track_explicit"      "top10_artist_genre"       
## [5] "top_10_track_release_date" "top10_track_explicit_1"
```

```str()``` displays the internal structure of an R object. In the case of a data frame, it returns the class (e.g., numeric, factor, etc.) of each variable, as well as the number of observations and the number of variables. 


```r
str(music_data) # returns the structure of the data frame
```

```
## 'data.frame':	10 obs. of  6 variables:
##  $ top10_track_streams      : num  163608 126687 120480 110022 108630 ...
##  $ top10_artist_names       : chr  "Axwell /\\ Ingrosso" "Imagine Dragons" "J. Balvin" "Robin Schulz" ...
##  $ top10_track_explicit     : Factor w/ 2 levels "not explicit",..: 1 1 1 1 1 1 2 2 1 1
##  $ top10_artist_genre       : Factor w/ 5 levels "Alternative",..: 2 1 4 2 2 2 3 2 5 5
##  $ top_10_track_release_date: Date, format: "2017-05-24" "2017-06-23" ...
##  $ top10_track_explicit_1   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

```nrow()``` and ```ncol()``` return the rows and columns of a data frame or matrix, respectively. ```dim()``` displays the dimensions of an R object.


```r
nrow(music_data) # returns the number of rows 
```

```
## [1] 10
```

```r
ncol(music_data) # returns the number of columns 
```

```
## [1] 6
```

```r
dim(music_data) # returns the dimensions of a data frame
```

```
## [1] 10  6
```

```ls()``` can be used to list all objects that are associated with an R object. 


```r
ls(music_data) # list all objects associated with an object
```

```
## [1] "top_10_track_release_date" "top10_artist_genre"       
## [3] "top10_artist_names"        "top10_track_explicit"     
## [5] "top10_track_explicit_1"    "top10_track_streams"
```

#### Append and delete variables to/from data frames

To call a certain column in a data frame, we may also use the ```$``` notation. For example, this returns all values associated with the variable "top10_track_streams":
  

```r
music_data$top10_track_streams
```

```
##  [1] 163608 126687 120480 110022 108630  95639  94690  89011  87869  85599
```

Assume that you wanted to add an additional variable to the data frame. You may use the ```$``` notation to achieve this:


```r
# Create new variable as the log of the number of streams 
music_data$log_streams <- log(music_data$top10_track_streams) 
# Create an ascending count variable which might serve as an ID
music_data$obs_number <- 1:nrow(music_data)
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["log_streams"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["obs_number"],"name":[8],"type":["int"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","7":"12.00523","8":"1","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","7":"11.74947","8":"2","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","7":"11.69924","8":"3","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","7":"11.60844","8":"4","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","7":"11.59570","8":"5","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","7":"11.46834","8":"6","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

To delete a variable, you can simply create a ```subset``` of the full data frame that excludes the variables that you wish to drop:


```r
music_data <- subset(music_data,select = -c(log_streams)) # deletes the variable log streams 
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["top_10_track_release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["obs_number"],"name":[7],"type":["int"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","7":"1","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","7":"2","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","7":"3","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","7":"4","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","7":"5","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","7":"6","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

You can also rename variables in a data frame, e.g., using the ```rename()```-function from the ```plyr``` package. In the following code "::" signifies that the function "rename" should be taken from the package "plyr". This can be useful if multiple packages have a function with the same name. Calling a function this way also means that you can access a function without loading the entire package via ```library()```.


```r
library(plyr)
music_data <- plyr::rename(music_data, c(top10_artist_genre="genre",top_10_track_release_date="release_date"))
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["obs_number"],"name":[7],"type":["int"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","7":"1","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","7":"2","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","7":"3","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","7":"4","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","7":"5","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","7":"6","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Note that the same can be achieved using:


```r
names(music_data)[names(music_data)=="genre"] <- "top10_artist_genre"
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["top10_artist_genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["obs_number"],"name":[7],"type":["int"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","7":"1","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","7":"2","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","7":"3","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","7":"4","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","7":"5","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","7":"6","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Or by referring to the index of the variable:


```r
names(music_data)[4] <- "genre"
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["top10_track_streams"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["top10_artist_names"],"name":[2],"type":["chr"],"align":["left"]},{"label":["top10_track_explicit"],"name":[3],"type":["fct"],"align":["left"]},{"label":["genre"],"name":[4],"type":["fct"],"align":["left"]},{"label":["release_date"],"name":[5],"type":["date"],"align":["right"]},{"label":["top10_track_explicit_1"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["obs_number"],"name":[7],"type":["int"],"align":["right"]}],"data":[{"1":"163608","2":"Axwell /\\\\ Ingrosso","3":"not explicit","4":"Dance","5":"2017-05-24","6":"FALSE","7":"1","_rn_":"1"},{"1":"126687","2":"Imagine Dragons","3":"not explicit","4":"Alternative","5":"2017-06-23","6":"FALSE","7":"2","_rn_":"2"},{"1":"120480","2":"J. Balvin","3":"not explicit","4":"Latino","5":"2017-07-03","6":"FALSE","7":"3","_rn_":"3"},{"1":"110022","2":"Robin Schulz","3":"not explicit","4":"Dance","5":"2017-06-30","6":"FALSE","7":"4","_rn_":"4"},{"1":"108630","2":"Jonas Blue","3":"not explicit","4":"Dance","5":"2017-05-05","6":"FALSE","7":"5","_rn_":"5"},{"1":"95639","2":"David Guetta","3":"not explicit","4":"Dance","5":"2017-06-09","6":"FALSE","7":"6","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


<br><br>

::: {.infobox_orange .hint data-latex="{hint}"}
Note that the data handling approach explained in this chapter uses the so-called 'base R' dialect. There are other dialects in R, which are basically different ways of achieving the same thing. Two other popular dialects in R are 'data.table' and the 'tidyverse' see e.g., [here](https://wetlandscapes.com/blog/a-comparison-of-r-dialects/) and [here](https://atrebas.github.io/post/2019-03-03-datatable-dplyr/). Once you become more advanced, you may want to look into the other dialects to achieve certain tasks more efficiently. For now, it is sufficient to be aware that there are other approaches to data handling and each dialect has it's strengths and weaknesses. We will be mostly using 'base R' for the tutorial on this website.   
:::

