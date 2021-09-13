library(ggplot2)

music_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_data_at.csv",
                         sep = ",",
                         header = TRUE)

table_plot_rel <- data.frame(prop.table(table(music_data$genre)))
names(table_plot_rel)[1] <- "Genre"


bar_chart <- ggplot(table_plot_rel, aes(x = Genre,y = Freq))

## No colors
bar_chart + geom_col() +
    ylab("Relative frequency") +
    xlab("Genre")

## Define a color for each genre
cols = c("red", "green", "blue", "black", "violet", "gold", "pink")

## see also `?colors`

## Color borders of columns
bar_chart + geom_col(color = cols)

## For legends move color to the `aes` or aesthetics
(bad_legend <- bar_chart + geom_col(aes(color = cols)))

## To get a meaningful legend specify the labels
bad_legend +
    scale_color_identity(breaks = cols,
                         labels = unique(table_plot_rel$Genre),
                         guide = "legend")


## Colors filling columns
bar_chart + geom_col(fill = cols)

## Legend: similar to above but using `scale_fill_identity`
bar_chart +
    geom_col(aes(fill = cols)) +
    scale_fill_identity(breaks = cols,
                        labels = unique(table_plot_rel$Genre),
                        guide = "legend")

## Automatically fill colors: specify the variable instead of colors
bar_chart + geom_col(aes(color = Genre))
bar_chart + geom_col(aes(fill = Genre))

## fill/color can also be set in the initial call to ggplot
ggplot(table_plot_rel, aes(x = Genre,y = Freq, fill = Genre)) +
    geom_col() +
    ylab("Relative frequency")


## Works similarly for other geoms
ggplot(music_data, aes(x = tempo, fill = genre)) +
    geom_histogram()

ggplot(music_data, aes(y = liveness, x = genre, fill = genre)) +
    geom_boxplot()

#####################
## Seperate issue: ##
#####################
## Changing color themes
library(ggthemes)

default_plot <- ggplot(table_plot_rel,
                        aes(x = Genre,y = Freq, fill = Genre)) +
    geom_col() +
    ylab("Relative frequency")

## predifined themes
default_plot + theme_bw()
default_plot + theme_excel_new()
default_plot + theme_economist()

## Or create own theme
default_plot + theme(
                   # Major grid is white and thicker
                   panel.grid.major = element_line("white", size = 1),
                   # Remove minor grid
                   panel.grid.minor = element_blank(),
                   # Set background color
                   panel.background = element_rect("lightblue"),
                   # All axis texts (tick labels) green and comic sans
                   axis.text = element_text(color = "darkgreen",
                                            family = "Comic Sans MS",
                                            size = 18
                                            ),
                   # Rotate X-axis text
                   axis.text.x = element_text(angle = 60,
                                            hjust = 1),
                   # Set axis title color and font family
                   axis.title = element_text(color = "darkblue",
                                             family = "Roboto Mono"),
                   # Remove X-axis title ("Genre")
                   axis.title.x = element_blank(),
                   # Set color of X-axis line
                   axis.line.x = element_line(colour = "gray", size = 2),
                   # Remove X-axis ticks
                   axis.ticks.x = element_blank(),
                   # Move legend to bottom
                   legend.position = "bottom",
                   # Set legend text font family
                   legend.text = element_text(family = "Comic Sans MS"),
                   # Set legend title font family
                   legend.title = element_text(family = "Roboto Mono")
                )

## Or combine
default_plot + theme_bw() +
    theme(
        # Remove X major grid
        panel.grid.major.x = element_blank(),
        # Remove Y minor grid
        panel.grid.minor.y = element_blank(),
        # Remove borders
        panel.border = element_blank(),
        # Remove all axis ticks
        axis.ticks = element_blank(),
        # Remove X-axis title
        axis.title.x = element_blank()
    )
