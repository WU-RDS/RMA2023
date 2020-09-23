library(ggplot2)
x <- c(1:13) 
x <- x-mean(x)
y2 <- 6 + x*0.65
#y1a <- 2 + x*1.15
y1 <- 9 + x*0.65
y1a[1:5] <- NA
data <- data.frame(y1,y2,x)
data$y1a <- ifelse(x>=0,9 + x*1.15,NA)
data$treat <- ifelse(data$x>0,data$y1a,data$y1)
#data$x <- as.factor(data$x)
data$y1 <- ifelse(data$x<0,NA,data$y1)
title_size = 20
font_size = 16
line_size = 0.5
ggplot(data) + 
  #geom_point(aes(x=x,y=y1),color="steelblue") + 
  geom_line(aes(x=x,y=treat),color="steelblue",size=1.5) + 
  #geom_point(aes(x=x,y=y1a),color="steelblue") + 
  geom_line(aes(x=x,y=y1),color="steelblue",size=1.5, linetype="dashed") + 
  annotate("text", x = -3, y = 1, label = "Pre Intervention", size = 5) +
  annotate("text", x = 3, y = 1, label = "Post Intervention", size = 5) +
  geom_segment(aes(x=-3,y=data$y2[4], xend=-3, yend=data$treat[4]),size=1, color="red", arrow = arrow(length = unit(0.1, "inches"))) + 
  geom_segment(aes(x=-3,y=data$treat[4], xend=-3, yend=data$y2[4]),size=1, color="red", arrow = arrow(length = unit(0.1, "inches"))) + 
  
  geom_segment(aes(x=6,y=data$y1[13], xend=6, yend=data$treat[13]),size=1, color="red", arrow = arrow(length = unit(0.1, "inches"))) + 
  geom_segment(aes(x=6,y=data$treat[13], xend=6, yend=data$y1[13]),size=1, color="red", arrow = arrow(length = unit(0.1, "inches"))) + 
  
  geom_segment(aes(x=3,y=data$y2[10]+2, xend=3, yend=data$y1[10]),size=1, color="red", arrow = arrow(length = unit(0.1, "inches"))) + 
  annotate("text", x = -3.5, y = (data$treat[4]+data$y2[4])/2, label = "Parallel \n trends \n assumption", size = 3, color="red") +
  annotate("text", x = 6.7, y = data$treat[12], label = "Intervention \n effect", size = 3, color="red") +
  annotate("text", x = 3, y = data$y2[10]+1.5, label = "Counter-\n factual", size = 3, color="red") +
  #geom_point(aes(x=x,y=y2)) +
  geom_line(aes(x=x,y=y2),size=1.5) +
  labs(y="Outcome",x="Time",
       title = "Difference-In-Differences Estimation"
       #subtitle = "(1973-74)"
       ) +
  geom_vline(aes(xintercept = 0), color="darkgrey",size=1) +
  ylim(0,16) + 
  scale_x_continuous(breaks = c(-6,-3,0,3,6),labels = c(1,4,7,10,13)) +
  theme_classic() +
  theme( legend.position = "none",
         plot.title = element_text(size=title_size,hjust = 0.5),
         axis.title=element_text(size=font_size),
         axis.text =element_text(size=font_size))
  

library(ggplot2)
library(ggthemes)
x <- c("pre", "post") 
y1 <- c(1.5,2.5)
y2 <- c(2,3)
y3 <- c(2,3.5)
#y3 <- c(2,4)
data_1 <- data.frame(x,y1,y2,y3)
title_size = 16
font_size = 16
line_size = 0.5
#pd <- position_dodge(0.75)
ggplot(data_1) + 
  geom_point(aes(x=reorder(x, y1),y=y1), color="cyan4", size = 3) + 
  geom_path(aes(x=reorder(x, y1),y=y1), color="cyan4", size = 1, group = 1) + 
  geom_point(aes(x=reorder(x, y1),y=y3), color="purple4", size = 3) + 
  geom_path(aes(x=reorder(x, y1),y=y3), color="purple4", size = 1, group = 1) + 
  geom_point(aes(x=reorder(x, y2),y=y2), color="steelblue", size = 3) + 
  geom_path(aes(x=reorder(x, y2),y=y2), color="steelblue", size = 1, linetype = "dashed", group = 1) + 
  geom_segment(aes(x="post",y=data_1$y2[2], xend="post", yend=data_1$y3[2]),size=1, color="darkmagenta", arrow = arrow(length = unit(0.1, "inches"))) + 
  geom_segment(aes(x="post",y=data_1$y3[2], xend="post", yend=data_1$y2[2]),size=1, color="darkmagenta", arrow = arrow(length = unit(0.1, "inches"))) + 
  annotate("text", x = 2.03, y = (data_1$y3[2]+data_1$y2[2])/2, label =  expression(Delta), size = 5, color = "darkmagenta") +
  annotate("text", x = 2.07, y = data_1$y3[2], label =  "Yt,post", size = 5) +
  annotate("text", x = 2.07, y = data_1$y1[2], label =  "Yc,post", size = 5) +
  annotate("text", x = 0.93, y = data_1$y3[1], label =  "Yt,pre", size = 5) +
  annotate("text", x = 0.93, y = data_1$y1[1], label =  "Yc,pre", size = 5) +
  theme_base() +
  #geom_point(aes(x=x,y=y2),color="steelblue") + 
  #geom_point(aes(x=x,y=y2)) +
  #geom_line(aes(x=x,y=y2),size=1.5) +
  labs(y="Outcome",x="Time",
       title = "Difference-In-Differences Estimation"
       #subtitle = "(1973-74)"
  ) +
  #geom_vline(aes(xintercept = 0), color="darkgrey",size=1) +
  #ylim(0,4.1) + 
  scale_x_discrete("Time", expand=c(0.05,0.1)) +
  #scale_x_continuous(breaks = c(-6,-3,0,3,6),labels = c(1,4,7,10,13)) +
  #theme_classic() +
  theme( legend.position = "none",
         plot.title = element_text(size=title_size,hjust = 0.5),
         axis.title=element_text(size=font_size),
         axis.text.x =element_text(size=font_size),
         axis.text.y =element_blank(),
         axis.ticks.y = element_blank()
         )
