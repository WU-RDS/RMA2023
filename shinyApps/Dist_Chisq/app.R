library(shiny)
library(ggplot2)
library(xtable)
ui <- fluidPage(
    withMathJax(),
  sidebarLayout(
    sidebarPanel(sliderInput("df", 
                             "Degrees of freedom", 
                             min = 1,
                             max = 30,
                             value = 4, 
                             step = 1),
                 tableOutput("percentiles"),
                 uiOutput("moments")
    ),
    mainPanel(
      plotOutput("distplot", height = "260"),
      p(),
      plotOutput("CDFplot", height = "260")
    )
    
  )
)


server <- function(input, output) {

    output$percentiles <- renderTable({
    pcts <- round(qchisq(p = c(0.05, 0.25, 0.5, 0.75, 0.95), df = input$df), digits = 3)
    pctnames <- c("5th", "25th", "50th", "75th", "95th")
    pcttab <- data.frame(pctnames, pcts)
    colnames(pcttab) <- c("Percentile", "Value")
    xtable(pcttab)
  }, caption = "Values of the selected Chi-Squared distribution at different percentiles")

  output$moments <- renderUI({
    EQ <- input$df
    VARQ <- 2 * input$df
    out <- paste0("$$Q\\sim \\chi^2(", input$df, ") \\\\ \\mathbb{E}[Q]=", EQ, ", Var(Q)=", VARQ, "$$")
    withMathJax(helpText(out))
  })
  
  output$distplot <- renderPlot({
    
    X <- seq(from = 0, to = 55, length.out = 1000)
    data <- data.frame(X = X, Density = dchisq(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Density)) + 
      geom_line(color = "firebrick") + 
      theme_bw() + 
      labs(x = "X", y = "Density") + 
      ylim(c(0,0.5))
  })
  
  output$CDFplot <- renderPlot({
    
    X <- seq(from = 0, to = 55, length.out = 1000)
    data <- data.frame(X = X, Prob = pchisq(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Prob)) + 
      geom_line(color = "firebrick") + 
      theme_bw() +  
      labs(x = "X", y = "Cumulative Probability")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

