---
knit: "bookdown::render_book"
new_session: TRUE
title: "Retail Marketing Analytics 2023"
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "An Introduction to Data Analytics Using R"
site: bookdown::bookdown_site
documentclass: book
favicon: "favicon.ico"
css: style.css
classoption:
  - twocolumn
---



# (PART) Course outline {-}

# Welcome! {-}

<p style="text-align:center;">
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/logo_wu.jpg" alt="logo_wu" height="140"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="logo_rds.png" alt="logo_rds" height="140"  />
</p>
<br>
Welcome to the course **Retail Marketing Analytics**! This course covers the conceptual foundations of data analysis techniques for marketing managers and applications of these methods to different data sets. The course will be delivered in parts using the **flipped classroom** teaching method. This means that students are required to familiarize themselves with the contents by means of **self-study** *before* each session (i.e., by going through the assigned materials on their own). This website is intended to aid the self-study process by providing you with explanations regarding the relevant concepts and methods in text and video format along with code files and commented outputs that will show you how to implement these methods using the **statistical software R**. 
<br><br>
The self-learning process will be complemented with compulsory in-person **weekly interactive sessions** in the PC lab, which provide ample opportunities to train the acquired knowledge and clarify points that require further discussion. 
<br><br>
The following pages outline the course schedule and explain how to use this tutorial in detail. If you have any questions, feel free to send me a short email.
<br>
<br>
Nils Wlömert
<br>
[nils.wloemert@wu.ac.at](mailto:nils.wloemert@wu.ac.at)


# Introduction {-}

## Course structure {-}

This course combines asynchronous teaching elements (e.g., texts and pre-recorded videos on this website) with synchronous elements (e.g., weekly in-person interactive sessions in the PC Lab). The syllabus consists of three main parts, as reflected by the structure of this website: 

1. **Lecture notes**: the lecture part will explain the theory behind the concepts and methods and provide you with example applications using the statistical software R.
2. **Individual assignments**: the individual assignments require you to apply the acquired knowledge to new data sets.
3. **Group project**: in the group you will design and conduct your own market research project and transfer the knowledge to a real business setting.

The general approach is that students will first familiarize themselves with the contents by going through the materials on their own. This **self-study** process is complemented with in-person **weekly interactive sessions** in the PC lab, which provide ample opportunities to ask questions and clarify points that require further discussion. The schedule for each of the three parts will be explained below. 

### Schedule {-}

#### In-person lecture {-}

The contents on this website are divided into weekly readings. To be able to follow the curriculum and complete the assignments, you need to read the materials assigned for the respective week. The relevant chapters are indicated in the table below. The weekly readings will be complemented with weekly interactive sessions in the PC lab, which provide you with an opportunity to ask questions about the assigned readings. **Please note that you need to go through the materials on your own in the week before the respective session.** For example, chapters 2, 3 & 4 will be discussed in the second session. The dates and times for the classroom sessions are indicated in the table below for each group separately. It is highly recommended to prepare questions or comments about the materials for these sessions that you think might be interesting and helpful to the class. As a preparation for the in-class discussions, you should go through the **Learning check** section at the end of each chapter. By working through these questions, you may self-assess your progress and identify knowledge gaps regarding the materials that were assigned for the previous week.        

<br>
**Lecture dates (5138)**
<br>
<table class=" lightable-paper lightable-hover" style='font-family: "Arial Narrow", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:left;"> Day </th>
   <th style="text-align:left;"> Time </th>
   <th style="text-align:left;"> Room </th>
   <th style="text-align:left;"> Topics </th>
   <th style="text-align:left;"> Chapters </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> April 20 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 08:00PM </td>
   <td style="text-align:left;"> TC.-1.61 </td>
   <td style="text-align:left;"> Introduction to the course <br>Basic concepts </td>
   <td style="text-align:left;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> April 27 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 08:00PM </td>
   <td style="text-align:left;"> TC.-1.61 </td>
   <td style="text-align:left;"> Introduction to R &amp; R Markdown </td>
   <td style="text-align:left;"> 2, 3, 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> May 04 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 08:00PM </td>
   <td style="text-align:left;"> TC.-1.61 </td>
   <td style="text-align:left;"> Introduction to inferential statistics <br>Hypothesis testing </td>
   <td style="text-align:left;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> May 11 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 09:00PM </td>
   <td style="text-align:left;"> TC.-1.61 </td>
   <td style="text-align:left;"> Supervised learning </td>
   <td style="text-align:left;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> May 25 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 09:00PM </td>
   <td style="text-align:left;"> TC.-1.61 </td>
   <td style="text-align:left;"> Unsupervised learning </td>
   <td style="text-align:left;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> June 01 </td>
   <td style="text-align:left;"> Thursday </td>
   <td style="text-align:left;"> 04:00PM - 06:00PM </td>
   <td style="text-align:left;"> Online </td>
   <td style="text-align:left;"> Exam </td>
   <td style="text-align:left;"> -- </td>
  </tr>
</tbody>
</table>
<br>

::: {.infobox_red .caution data-latex="{caution}"}
We understand that the self-study format might pose challenges to the learning process because we cannot troubleshoot in person outside of the classroom sessions. Remember that it is very unlikely that you are the only student encountering a particular problem. So please make use of the forum on Learn\@WU (see below) to interact with your peers or ask us questions so that everyone else will benefit from the answer (there are no stupid questions!). In case you cannot get answers to address a specific problem, we will be available during the in-person classroom sessions for coaching.
:::

#### Individual assignments {-}

There will be 3 individual assignments. These assignments need to be submitted in the [R Markdown format](https://rmarkdown.rstudio.com/) (see chapter 8) via Learn\@wu. There will be a coaching session dedicated to the R Markdown reporting format in the second session, when the first homework is assigned. 

<br>
**Assignment schedule - Group A (2206)**
<br>
<table style="NAborder-bottom: 0;">
 <thead>
  <tr>
   <th style="text-align:left;"> Assignment </th>
   <th style="text-align:left;"> Assigned </th>
   <th style="text-align:left;"> Submission </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Assignment 1: R Basics </td>
   <td style="text-align:left;"> April 27 </td>
   <td style="text-align:left;"> May 3, 11:59PM </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Assignment 2: Supervised learning </td>
   <td style="text-align:left;"> May 11 </td>
   <td style="text-align:left;"> May 24, 11:59PM </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Assignment 3: Unsupervised learning </td>
   <td style="text-align:left;"> May 25 </td>
   <td style="text-align:left;"> June 8, 11:59PM </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<span style="font-style: italic;">Note: </span> <sup></sup> Dates and times are indicated for group A.</td></tr></tfoot>
</table>

<br>

#### Group project {-}

The group project consists of an extended analysis of a data set using the methods we covered in the course and the reporting of the results using the R markdown format.

The **submission date** for the group project is on **June 14, 2023**. There is an opportunity to schedule a **coaching session** regarding the group project on **June 12** between 9:00AM nd 5:00PM. If you would like to make use of the opportunity to schedule a coaching session, please register an appointment by sending me an email.

Again, please make sure that you have exhausted all other resources to solve a particular problem, such as the online tutorial, the forum on Learn\@wu, and other web resources (see below) before you schedule a coaching session. If you feel that other students might have similar questions and would benefit from an answer to a particular question, you should post the question in the forum on Learn\@wu.
<br>

### Grading {-}

Grading is based on the following components:

* **Market research group project** (data analysis & reporting) [weight: 30%]
* **Individual take-home computer exercises** (statistical analysis of data sets; 3 assignments accounting for 10% each [weight: 30%]
* **Final online exam** (concepts & methods) [weight: 30%]
* **Class participation** (quantity & quality of contributions during the weekly sessions, contributions in the online forum, etc.) [weight: 10%]

These grading components will be weighted with the respective weights to arrive at the final grade percentage.

The **final exam** will take place online on **June 01, 2023 from 4:00PM - 06:00PM**. Details about the setup of the exam will be provided in the course. The exam covers questions about the concepts and methods (no coding) and I will provide example exams from the previous years to give you an idea about what type of questions you can expect.   

To ensure an equal contribution of group members for the group assignment, a **peer assessment** will be conducted among group members, which enters into the computation of the individual grades for the project. This means that the members of a group are required to assess other students regarding their relative contribution. 

**To successfully pass this course, your weighted final grade needs to exceed 60%.**

## Course materials {-}

### Main reference {-}

The main reference for this course is this website along with the corresponding slides and the pre-recorded video lectures. The relevant materials for each week are indicated in the tables above. The aim of the materials is to condense the contents and direct your attention to the most relevant aspects. This should enable students to study the materials on their own and we can focus our attention during the classroom sessions on clarifying points that require further discussion. 

At the end of each chapter, you will find a section with references. It is highly recommended that you consult these references for further clarification in case you require additional information on a topic.  

### Further readings {-}

<p style="text-align:center;">
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/R4ds.png" alt="DSUR cover" height="120"  />&nbsp;
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/ISL_cover.jpg" alt="ISL cover" height="120"  />&nbsp;
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/r4mra.jpg" alt="R4mra cover" height="120"  />&nbsp;
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/advr.jpg" alt="advr cover" height="120"  />&nbsp;
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/tmwr.png" alt="tmwr cover" height="120"  />&nbsp;
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/r_packs.png" alt="Rpacks cover" height="120"/>
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/URfIE.png" alt="Rpacks cover" height="120"/>
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/rgraph.jpg" alt="Rgraph cover" height="120"/>
</p>

In addition to these lecture notes, there are many excellent books available (many of them for free) that focus on different aspects of R. In fact, there are so many free resources available by now that a team of R programmers has set up a website that provides an overview over the available resources by topic. You can find this overview here: [Big Book of R](https://www.bigbookofr.com/).

In case you would like to learn more about the capabilities of R related to the contents of this course, I can particularly recommend the following books:

* __"[R for Data Science](http://r4ds.had.co.nz/)"__ An excellent book by Hadley Wickham, which introduces you to R as a tool for doing data science, focusing on a consistent set of packages known as the tidyverse. [FREE online version]

* __"[An Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/)"__ This book provides an introduction to statistical learning methods and covers basic methods (e.g., linear regression) as well as more advanced methods (e.g., Support Vector Machines). [FREE online version]

* __"[R for Marketing Research and Analytics](http://r-marketing.r-forge.r-project.org/)"__ A great book that is designed to teach R to marketing practitioners and data scientists.

* __"[Statistical Inference via Data Science](https://moderndive.com/)"__ Another great book covering topics around Statistical Inference. [FREE online version]

* __"[Text Mining with R](http://tidytextmining.com/)"__ This book explains how you can analyze unstructured data (texts) using R. [FREE online version]

* __"[Advanced R](http://adv-r.had.co.nz/)"__ Another great book written by Hadley Wickham. Explains more advanced R concepts. [FREE online version]

* __"[Hands-On Machine Learning with R](https://bradleyboehmke.github.io/HOML/)"__ A great reference to learn about machine learning methods in R. The book favors a hands-on approach, growing an intuitive understanding of machine learning through concrete examples and little bit of theory.[FREE online version]

* __"[Hands-On Data Science for Marketing](https://github.com/PacktPublishing/Hands-On-Data-Science-for-Marketing)"__ Another good reference regarding Data Science for Marketing. [FREE Code exercises]

* __"[R Markdown](https://bookdown.org/yihui/rmarkdown/)"__ A great book about the reporting format 'R Markdown', which we will also use for the assignments in this course. [FREE Code exercises]

* __"[R Packages](http://r-pkgs.had.co.nz/)"__ A book which teaches you how to make the most of R's fantastic package system. [FREE online version]

* __"[R Graphics Cookbook](https://r-graphics.org/)"__ A practical guide that provides more than 150 recipes to help you generate high-quality graphs quickly. [FREE online version]

* __"[Using R For Introductory Econometrics](http://www.urfie.net/read/index.html)"__ This book covers a nice introduction to R with a focus on the implementation of standard tools and methods used in econometrics. [FREE online version]

* __"[Data Science in a Box](https://datasciencebox.org/)"__ Another book covering topics around Data Science using R. [FREE online version]

* __"[Efficient R Programming](https://csgillespie.github.io/efficientR/)"__ A good reference to learn efficient workflows using R. [FREE online version]

* __"[Discovering Statistics Using R](https://www.amazon.de/Discovering-Statistics-Using-Andy-Field/dp/1446200469)"__ (Field, A., Miles, J., & Field Zoe, 2012, 1st Edtn.) This textbook offers an accessible and comprehensive introduction to statistics. 

### Discussion forum {-}

**We strongly encourage you to ask your questions via the online forum** on the course page on the WU learning platform. The purpose of the forum is to allow you to discuss questions related to the contents with your class mates and us. Please make use of this forum as much as possible and ask questions if something remained unclear. Remember that there are no stupid questions! And if you know the answer to a question that is asked in the forum, it is also a good exercise to explain the concepts to your classmates. 

### Other web-resources {-}

* __"[https://www.r-project.org/](https://www.r-project.org/)"__ official website
  
* __"[http://www.statmethods.net/](http://www.statmethods.net/)"__ R reference by the author of “R in action”

* __"[http://www.rdocumentation.org/](http://adv-r.had.co.nz/)"__ R documentation aggregator

* __"[http://stackoverflow.com/](http://stackoverflow.com/)"__ general discussion forum for programmers incl. R
  
* __"[http://stats.stackexchange.com/](http://stats.stackexchange.com/)"__ discussion forum on statistics and data analytics

* __"[http://www.r-bloggers.com/](http://www.r-bloggers.com/)"__ R blog aggregator

* __"[http://www.cookbook-r.com/](http://www.cookbook-r.com/)"__ useful examples for all kind of R problems

* __"[https://ggplot2.tidyverse.org/reference/index.html](https://ggplot2.tidyverse.org/reference/index.html)"__ reference for data visualization

### Contact {-}

Feel free to send me an email in case you have questions. However, please make sure that you have exhausted all other resources to solve a particular problem, such as the online tutorial, the forum on Learn\@wu, and other web resources (see below) before you schedule a coaching session. If you feel that other students might have similar questions and would benefit from an answer to a particular question, you should post the question in the forum on Learn\@wu.

### Acknowledgements {-}

This tutorial is supported through Digital Learning Project Funding by WU Vienna. None of the materials covered in this tutorial are new. We intend to provide a summary of existing methods from a marketing research perspective and cite the corresponding sources. If you should have any comments or suggestions, please [contact us through the github page of this course](https://github.com/WU-RDS). 
