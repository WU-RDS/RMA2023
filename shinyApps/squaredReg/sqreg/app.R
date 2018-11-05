#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
ui <- fluidPage(
  withMathJax(),
   sidebarLayout(
      sidebarPanel(
         sliderInput("advertising",
                     "Advertising (thsd. Euro):",
                     min = 0,
                     max = 120,
                     value = 50),
         uiOutput("formula")
      ),
      mainPanel(
         plotOutput("Plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  set.seed(1234)
  X <- as.integer(runif(1000, 0, 12000))
  Y <- 80000 + 140 * X - 0.01 * (X^2) + rnorm(1000, 0,
                                              35000)

  salesData <- data.frame(sales = Y/100000, advertising = X*0.01)
  mod <- quad_mod <- lm(sales ~ advertising + I(advertising^2), data = salesData)
  salesData$Prediction <- fitted(mod)
  output$Plot <- renderPlot({
    optimalAdvertising <- as.integer(which.max(salesData$Prediction))
    slope <- coef(quad_mod)[["advertising"]] + 2 * coef(quad_mod)[["I(advertising^2)"]] * input$advertising
    y0 <- predict(mod, newdata = data.frame(advertising = input$advertising))
    len <- 20
    y <- y0+(-len:len * slope)
    x <- input$advertising+(-len:len)
    vals <- data.frame(y = y, x = x)
    ggplot(salesData) +
      geom_point(aes(x = advertising, y = sales, color = "Data")) +
      geom_line(aes(x = advertising, y = Prediction, color = "Prediction")) +
      geom_line(data = vals, aes(x = x, y = y, color = "Slope")) +
      theme_bw() +
      theme(legend.title = element_blank())
   })



  output$formula <- renderUI({
    cSlope <- as.character(round(coef(mod)[["advertising"]] +
                             2 * coef(mod)[["I(advertising^2)"]] * input$advertising, 3))
    cProd <- as.character(input$advertising)
    cB1 <- as.character(round(coef(mod)["advertising"], 3))
    cB2 <- as.character(round(coef(mod)["I(advertising^2)"], 3))
    string <- paste0("$$ \\text{Slope} = \\beta_1 + 2 \\beta_2 \\text{ advertising} \\\\ =", cB1,"+ 2 * (", cB2,") * ", cProd, " = ", cSlope, "$$")
    withMathJax(helpText(string))
  })
}

# Run the application
shinyApp(ui = ui, server = server)

