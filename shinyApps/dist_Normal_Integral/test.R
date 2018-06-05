input <- data.frame(x = 10)
X <- seq(from = -10, to = 30, length.out = 1000)
data <- data.frame(X = X, Density = dnorm(X, 10, 5))
area <- rbind(c(-10, 0), subset(data, X <= input$x))
area <- rbind(area, c(data[nrow(area), "X"], 0))
yupper <- dnorm(input$x, 10, 5)
ggplot(data = data, aes(x = X, y = Density)) + 
  geom_line(color = "firebrick") + 
  theme_bw() +
  lims(x = c(-10,30), y = c(0,0.1)) + 
  labs(x = "X", y = "Density") +
  geom_segment(aes(x = input$x, y = 0, xend = input$x, yend = yupper)) +
   geom_polygon(data = area, aes(X, Density))
