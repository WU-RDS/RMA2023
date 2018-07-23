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
         sliderInput("production",
                     "Pieces Produced:",
                     min = 0,
                     max = 10000,
                     value = 3491),
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
  X <- as.integer(runif(1000, 0, 10000))
  Y <- -50000 + 70*X - .01*(X^2) + rnorm(1000, 0, 15000)
  profitData <- data.frame(Profit = Y, Production = X)
  mod <- lm(Profit ~ Production + I(Production^2), data = profitData)
  profitData$Prediction <- fitted(mod)
  output$Plot <- renderPlot({
    slope <- coef(mod)[["Production"]] + 2 * coef(mod)[["I(Production^2)"]] * input$production
    y0 <- predict(mod, newdata = data.frame(Production = input$production))
    len <- 3000
    y <- y0+(-len:len * slope)
    x <- input$production+(-len:len)
    vals <- data.frame(y = y, x = x)
    ggplot(profitData) +
      geom_point(aes(x = Production, y = Profit, color = "Data")) +
      geom_line(aes(x = Production, y = Prediction, color = "Prediction")) +
      geom_line(data = vals, aes(x = x, y = y, color = "Slope")) +
      theme_bw() +
      theme(legend.title = element_blank())
   })
  

  
  output$formula <- renderUI({
    cSlope <- as.character(round(coef(mod)[["Production"]] + 
                             2 * coef(mod)[["I(Production^2)"]] * input$production, 2))
    cProd <- as.character(input$production)
    cB1 <- as.character(round(coef(mod)["Production"], 2))
    cB2 <- as.character(round(coef(mod)["I(Production^2)"], 2))
    string <- paste0("$$ \\text{Slope} = \\beta_1 + 2 \\beta_2 \\text{ Production} \\\\ =", cB1,"+ 2 * (", cB2,") * ", cProd, " = ", cSlope, "$$") 
    withMathJax(helpText(string))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

