#### Multiplicative model

A multiplicative model is one of the form

\begin{equation} 
\begin{split}
Y = \beta_0 * X_1^{\beta_1} * X_2^{\beta_2} * \ldots * X_j ^{\beta_j} * \epsilon
\end{split}
(\#eq:multiplicativemodel)
  \end{equation} 
  
  In the plot below you can see a simulated model and the underlying relationship with which the data was generated. It is quite obvious (even without the red line) that the assumption of a linear relationship would not hold here. Such a misspecification would be particularly bad if you tried to use it to predict out of the sample, seeing as the diminishing returns would not be captured by a linear model. 
  
  ```{r, eval = TRUE, echo = FALSE, fig.align = "center", fig.cap = "Multipilicative model"}
  b_0 <-3
  b_1 <- 0.2
  x <- runif(100, 0, 5000)
  y = b_0*x^b_1 + rnorm(100, sd = 2)
  
  ggplot(data = data.frame(X = x, Y = y), aes(x = X, y = Y)) + 
    geom_point() + 
    stat_function(fun = function(x) (b_0*x^b_1), geom = "line", color = "firebrick") + 
    theme_bw()
  ```
  
  #### U shaped relationships
  
  A U (or inverse U) model has a data generating process of the following form
  
  \begin{equation} 
  \begin{split}
  Y = \beta_0 + {\beta_1}*X_1 + {\beta_2} * X_1^2 + \epsilon
  \end{split}
  (\#eq:multiplicativemodel)
    \end{equation} 
    
    Below you can see simulated data of such a form and the underlying relationship. Again, the non-linearity would be clear even without the red line.
    
    ```{r, echo = FALSE, eval = TRUE, fig.align = "center", fig.cap = "U shaped relationship"}
    b_0 <- 50
    b_1 = 28
    b_2 <- -0.2
    
    x <- runif(100, 0, 100)
    y <- b_0 + b_1*x + b_2*x^2 + rnorm(100, sd = 100)
    
    ggplot(data = data.frame(X = x, Y = y), mapping = aes(x = X, y = Y)) + 
      geom_point() +
      stat_function(fun = function(x) (b_0 + b_1*x + b_2*x^2), col = "firebrick") + 
      theme_bw()
    ```
    
    #### Structural breaks
    
    Structural breaks occur when there is a shift in the trend of the relationship between X and Y above a certain threshold value of X. This results in a scatterplot with a sudden break in the linear relationship, as can be seen below. If this break is too egregious, standard OLS will lead to biased results. 
    
    ```{r, eval = TRUE, echo = FALSE, fig.align = "center", fig.cap = "Structural break"}
    b_0 <- 50
    b_1 = 0.2
    break_size <- 15
    
    x <- runif(100, 0, 100)
    y <- b_0 + b_1*x + rnorm(100, sd = 3)
    y[x > 60] <- y[x > 60] + break_size
    
    ggplot(data = data.frame(Y = y, X = x), mapping = aes(x = X, y = Y)) + 
      geom_point() + 
      stat_function(fun = function(x) b_0 + b_1 * x, col = "firebrick", xlim = c(0, 60)) + 
      stat_function(fun = function(x) b_0 + break_size + b_1 * x, col = "firebrick", xlim = c(60, 100)) +
      theme_bw()
    
    ```
    