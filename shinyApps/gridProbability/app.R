#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(xtable)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Probability of two events"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("green",
                     "Probability of green:",
                     min = 0,
                     max = 100,
                     value = 50),
         sliderInput("red",
                   "Probability of red:",
                     min = 0,
                     max = 100,
                     value = 50),
         tableOutput('probTable')
        
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     plot(x = NA, xlim = c(0, 10), ylim = c(0, 10), xlab = "", ylab = "")
     xr <- 1:10
     yb <- 0:9
     grid <- expand.grid('xr' = xr, 'yb' = yb )
     grid$xl <- grid$xr - 0.9
     grid$yt <- grid$yb + 0.9
      for(i in 1:100){
        cur_pos <- grid[i,]
        rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt)
      }
     for(i in 0:input$green){
       cur_pos <- grid[i,]
       rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt, col = 'green')
     }
     if(input$red>0){
     for(i in (input$green +1):(input$green + input$red)){
       cur_pos <- grid[i,]
       rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt, col = 'red')
     }}
     if((input$red + input$green)>100){
       overlap <- input$green + input$red - 100
       for(i in 0:(input$green-overlap)){
         cur_pos <- grid[i,]
         rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt, col = 'green')
       }
      for(i in (input$green -overlap + 1):(input$green)) {
        cur_pos <- grid[i,]
        rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt, col = 'yellow')
      }
       if(input$green<100){
         for(i in (input$green +1):100){
         cur_pos <- grid[i,]
         rect(xright = cur_pos$xr, xleft = cur_pos$xl, ybottom = cur_pos$yb, ytop = cur_pos$yt, col = 'red')
         }
         }
         
     }
   })

  output$probTable <- renderTable({
    if(input$green + input$red > 100){
    overlap <- input$green + input$red - 100
    }else{
      overlap <- 0
    }
    
    text <- rbind('P(Green)', 'P(Red)', 'P(Red and Green)', 'P(Red or Green)', 'P(Red given Green)', 'P(Green given Red)')
    vals <- rbind(input$green/100, input$red/100, (overlap/100), ((input$green + input$red)/100)-(overlap/100), overlap/input$green, overlap/input$red)
    xtable(matrix(cbind(text, vals), ncol = 2))
  }, colnames = FALSE) 
}

# Run the application 
shinyApp(ui = ui, server = server)

