---
output:
  html_document:
    toc: yes
  theme: united
  html_notebook: default
  pdf_document:
    toc: yes
---

# Getting started with R

<p style="text-align:center;"><img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/Rlogo.png" alt="R Logo" width="20%"></p>
<br>

<div align="center">
<iframe width="500" height="310" src="https://www.youtube.com/embed/ZrQXjeP-0t4" frameborder="0" allowfullscreen></iframe>
</div>
<br>

In this course, we will work with the statistical software package <b>R</b>. Please make sure R is already installed on your computer before the tutorials start. The Comprehensive R Archive Network (CRAN) contains compiled versions of the program that are ready to use free of charge: 

* [Download R](http://cran.r-project.org) [FREE download]

<b>RStudio</b> provides a graphical user interface (GUI) that makes working with R easier. You can also download RStudio for free:

* [Download R Studio](https://www.rstudio.com/products/rstudio/download/#download) (Windows, Linux, OSX, …).

The R Studio software is built on top of R, which means that you can use R without R Studio, but you cannot use R Studio without R. The reason why we will use R Studio is that it provides a nicer user interface compared to the standard R interface. There are several advantages of R over other statistical software packages:

* It`s free
* A lot of free training material
* Runs on a variety of platforms (Windows, Linux, OSX, …)
* Contains statistical routines not yet available in other programs.
* Active global community (e.g., <a href="https://www.r-bloggers.com/" target="_blank">https://www.r-bloggers.com/</a>).
* Many specialized user-written packages.
* It has its own journal (e.g., <a href="http://journal.r-project.org" target="_blank">http://journal.r-project.org</a>).
* Highly integrated and interfaces to other programs.
* It is becoming increasingly popular among practitioners.
* It is a valuable skill to have on the job market.
* It is not as complicated as you might think.
* R is powerful.
* …

## How to download and install R and RStudio

The following video gives you an overview of how to download and install the R and R Studio software.  

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/SAxhoYIt7pk" frameborder="0" allowfullscreen></iframe>
</div>

## The R Studio interface 

The following video gives you an introduction to the R Studio interface.  

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/dGFJjUiclZ8" frameborder="0" allowfullscreen></iframe>
</div>

## Functions

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/FgIdsSKYVSM" frameborder="0" allowfullscreen></iframe>
</div>

When analyzing data in R, you will access most of the functionalities by calling functions. A <b>function</b> is a piece of code written to carry out a specified task (e.g., the ```lm()```-function to run a linear regression). It may or may not accept arguments or parameters and it may or may not return one or more values. Functions are generally called like this:


```r
function_name(arg1 = val1, arg2 = val2, ...)
```

To give you an example, let's use the built-in ```seq()```-function to generate a sequence of numbers. RStudio has some nice features that help you when writing code. For example, when you type "se" and hit TAB, a pop-up shows you possible completions. The more letters you type in, the more precise the suggestions will become and you will notice that after typing in the third letter, a pop-up with possible completions will appear automatically and you can select the desired function using the ↑/↓ arrows and hitting ENTER. The pop-up even reminds you of the arguments that a function takes. If you require more details, you may either press the F1 key or type in ```?seq``` and you will find the details for the function in the help tab in the lower right pane. When you have selected the desired function from the pop-up, RStudio will automatically add matching opening and closing parentheses (i.e., go from ```seq``` to ```seq()```). Within the parentheses you may now type in the arguments that the function takes. Let's use ```seq()``` to generate a sequence of numbers from 1 to 10. To do this, you may include the argument names (i.e., ```from = ```, ```to = ```), or just the desired values in the correct order.  
An important thing to note is that R is case-sensitive, meaning that ```Seq()``` and ```seq()``` are viewed as two different functions by R.


```r
seq(from = 1, to = 10) #creates sequence from 1 to 10
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
seq(1,10) #same result
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

Note that if you specify the argument names, you may enter them in any order. However, if do not include the argument names you must adhere to the order that is specified for the respective function. 


```r
seq(to = 10,from = 1) #produces desired results
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
seq(10,1) #produces reversed sequence
```

```
##  [1] 10  9  8  7  6  5  4  3  2  1
```

## Packages

Most of the R functionalities are contained in distinct modules called <b>packages</b>. When R is installed, a small set of packages is also installed. For example, the Base R package contains the basic functions which let R function as a language: arithmetic, input/output, basic programming support, etc.. However, a large number of packages exist that contain specialized functions that will help you to achieve specific tasks. To access the functions outside the scope of the pre-installed packages, you have to install the package first using the ```install.packages()```-function. For example, to install the ggplot2 package to create graphics, type in ```install.packages("ggplot2")```. Note that you only have to install a package once. After you have installed a package, you may load it to access its functionalities using the ```library()```-function. E.g., to load the ggplot2-package, type in ```library(ggplot2)```. 

The number of R packages is rapidly increasing and there are many specialized packages to perform different types of analytics. 
<p style="text-align:center;">
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/rpackages.png" alt="DSUR cover" height="300"  />&nbsp;
</p>


## A typical R session

1. Open RStudio. 

2. Make sure that your <b>working directory</b> is set correctly. The working directory is the location where R will look for files you would like to load and where any files you write to disk will be saved. If you open an existing R script from a specific folder, this folder will, by default, be the working directory. You can check your working directory by using the ```getwd()```-function. In case you wish to change your working directory, you can use the ```setwd()```-function and specify the desired location (i.e., ```setwd(path_to_project_folder)```). Notice that you have to use ```/``` instead of ```\``` to specify the path (i.e., Windows paths copied from the explorer will not work before you change the backward slashes with forward slashes). Alternatively, you can set the working directory with R-Studio by clicking on the "Sessions" tab and selecting "Set Working Directory".

3. Load your data that you wish to analyze (using procedures that we will cover later) 

4. Perform statistical analysis on your data (using methods that we will cover later)

5. Save your <b>workspace</b>. The R workspace is your current working environment incl. any user-defined objects (e.g., data frames, functions). You can save an image of the current workspace to a file called ”.RData”. In fact, RStudio will ask you automatically if you would like to save the workspace when you close the program at the end of the session. In addition, you may save an image of the workspace at any time during the session using the ```save.image()```-function. This saves the workspace image to the current working directory. When you re-open R from that working directory, the workspace will be loaded, and all these things will be available to you again. You may also save the image to any other location by specifying the path to the folder explicitly (i.e., ```save.image(path_to_project_folder)```). If you open R from a different location, you may load the workspace manually using the ```load("")```-function which points to the image file in the respective directory (e.g., ```load("path_to_project_folder/.RData")```. 
<br>
<br>

::: {.infobox_orange .hint data-latex="{hint}"}
Although it is quite common, saving your workspace is not always required. Especially when you save your work in an R script file (which is highly recommended), you will be able to restore your latest results by simply executing the code contained therein again. This also prevents you from carrying over potential mistakes from one session to the next.
:::
<br>

## Getting help

<p style="text-align:center;">
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/need_a_minute.JPG" alt="errors" height="250"  /><br>
Source: <a href="https://github.com/allisonhorst/stats-illustrations" target="_blank">Allison Horst</a>
</p>

* Errors & warnings: because R is interactive, consider errors your friends!
* Most importantly: the more time you spend using R, the more comfortable you become with it and it will be easier to see its  advantages 
* Built-in R tutorial: type in “help.start()” to get to the official R tutorial
* Questions regarding specific functions: type in “?function_name” to get to the help page of specific functions (e.g., “?lm” gives you help on the lm() function)
* Video tutorials: Make use of one of the many video tutorials on YouTube (e.g., [http://www.r-bloggers.com/learn-r-from-the-ground-up](http://www.r-bloggers.com/learn-r-from-the-ground-up/)[/](https://www.youtube.com/watch?v=9ZrAYxWPN6c))
* R Cheatsheets: Cheat sheets make it easy to learn about and use some popular packages (<a href="https://www.rstudio.com/resources/cheatsheets/" target="_blank">https://www.rstudio.com/resources/cheatsheets/</a>). They can also be accessed from within RStudio under the "help" menu
