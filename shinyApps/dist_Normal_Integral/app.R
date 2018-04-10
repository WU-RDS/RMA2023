library(shiny)
library(ggplot2)
library(xtable)
ui <- fluidPage(
  withMathJax(),
  sidebarLayout(
   
    sidebarPanel(p("$$P(X \\leq x)$$"),
                 sliderInput("x", 
                             "$$\\text{Choose }x$$", 
                             min = -10,
                             max = 30,
                             value = 10),
                 uiOutput("pdfInteg")
                 ),
    mainPanel(
      p("$$\\text{PDF of }N(\\mu = 10, \\sigma = 5)$$"),
      plotOutput("distplot", height = "260")
    ) 
  )
)


server <- function(input, output) {

  
output$distplot <- renderPlot({
  X <- seq(from = -10, to = 30, length.out = 1000)
  data <- data.frame(X = X, Density = dnorm(X, 10, 5))
  area <- rbind(c(-10, 0), subset(data, X <= input$x))
  area <- rbind(area, c(data[nrow(area), "X"], 0))
  yupper <- dnorm(input$x, 10, 5)
  ggplot(data = data, aes(x = X, y = Density)) +
    geom_segment(aes(x = input$x, y = 0, xend = input$x, yend = yupper), color = alpha("lightblue", 0.3), size = 0.3) +
    geom_line(color = "darkblue") +
    theme_bw() +
    lims(x = c(-10,30), y = c(0,0.1)) +
    labs(x = "X", y = "Density") +
    geom_polygon(data = area, aes(X, Density), fill = alpha("lightblue", 0.3))
})

output$pdfInteg <- renderUI({  
    curDens <- round(pnorm(input$x, 10, 5), 5)
    upper <- input$x
    string <- paste0("$$ \\frac{1}{\\sqrt{2 \\pi σ^2}} \\int_{-∞}^{",upper,"} e^{-\\frac{1}{2}\\frac{-(t-μ)^2}{σ^2}} dt\\\\= P(X \\leq ",upper,") =", curDens,"$$")
    withMathJax(helpText(string))
  }) 
 
}

# Run the application 
shinyApp(ui = ui, server = server)

