music_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_data_at.csv",
                         sep = ",",
                         header = TRUE)

## Count the number of missing values
sum(is.na(music_data$tempo))

## Calculating statistics (e.g., mean, sd) using a variable with missing values will result in a missing value
mean(music_data$tempo)

## This can lead to surprising errors down the line
## No warning:
music_data$tempo_demean <- music_data$tempo - mean(music_data$tempo)
## But all values are NA:
sum(is.na(music_data$tempo_demean))

## Option 1: skip missing value when calculating the statistic
mean(music_data$tempo, na.rm = TRUE)

## Option 2: omit rows with missing values and then calculate the statistic
tempo_nonmissing <- na.omit(music_data$tempo)
mean(tempo_nonmissing)
### OR
mean(na.omit(tempo_nonmissing))

## Solution:
music_data$tempo_demean <- music_data$tempo - mean(music_data$tempo, na.rm = TRUE)

sum(is.na(music_data$tempo_demean))

## Note that `scale` automatically removes NAs
music_data$tempo_std <- scale(music_data$tempo)
sum(is.na(music_data$tempo_std))

## This can also be used to demean
music_data$tempo_demean_2 <- c(scale(music_data$tempo, scale = FALSE))
all.equal(music_data$tempo_demean, music_data$tempo_demean_2, check.attributes = FALSE)


hist(music_data$tempo_std)
