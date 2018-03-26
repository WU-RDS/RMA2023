library(ggplot2)
library(gganimate)

set.seed(12346)
N <- 20
n <- 10
p <- 0.8
EX <- n * p
yvals <- rbinom(N, n, p)
yvals <- yvals - EX
yvals2 <- yvals^2

xvals <- 1:N
dat <- data.frame(yvals, xvals)
### Static Image
p <- ggplot(dat) +
  geom_hline(yintercept = 0) +
  lims(x = c(1, N), y = c(min(yvals), max(yvals))) +
  labs(y = "Deviation from expected value", x = "Toss")


p <- p + suppressWarnings(
    geom_linerange(aes(x = xvals, y = NULL, ymin = 0, ymax = yvals, group = xvals))) +
    geom_point(aes(x = xvals, y = yvals, group = xvals))

p

### Animated Image
seq2 <- Vectorize(seq.default, vectorize.args = c("from", "to"))
steps <- seq2(from = yvals, to = yvals2, length.out = 10)
framevals <- sort(rep(1:20, times = 20))
xvalsn <- rep(xvals, times = 20)
steps <- as.vector(t(steps))

dat2 <- data.frame('xvals' = xvalsn, 'yvals' = steps, framevals)
p2 <- ggplot(dat2) +
  geom_hline(yintercept = 0) +
  lims(x = c(1, N), y = c(min(yvals), max(yvals2))) +
  labs(x = "Toss", y = "") +
  scale_y_continuous(breaks = c(-3:9))+
  theme_bw()

p2 <- p2 + suppressWarnings(
  geom_linerange(aes(x = xvals, y = NULL, ymin = 0, ymax = yvals, group = xvals, frame = framevals))) +
  suppressWarnings(geom_point(aes(x = xvals, y = yvals, group = xvals, frame = framevals)))

gganimate(p2 + ggtitle("Deviation to Squared Deviation from expected value"), "./sqrerror.html", interval = 0.5, title = FALSE, verbose = FALSE, loop = FALSE)
