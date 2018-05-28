library(stats4)

N <- 5000

beta.true <- c(0.3, 0.4, -0.2, -0.7)

K <- length(beta.true)

X <- matrix(runif(N * K, -3, 3), ncol = K)

probs <- 1/(1 + exp(-X %*% beta.true))

Y <- rbinom(n = N, size = 1, prob = probs)


loglik <- function(beta.est){
  #beta.est <- c(beta1, beta2, beta3, beta4)
  probs.int <- 1/(1 + exp(-X %*% beta.est))
  loglik.ret <-  sum(dbinom(Y, size = 1, prob = probs.int, log = TRUE))
  
  -loglik.ret
}

#grid <- seq(from = 0, to = 2, length.out = 1000)


#loglik.sto <- rep(NA, times = length(grid))

#index <- 1
#for(i in grid){
#  loglik.sto[index] <- loglik(X, i)
#  index <- index + 1
#}
#plot(grid, loglik.sto, type = "l")
#abline(v = grid[which.max(loglik.sto)])


res <- optim(fn = loglik, par = c(0,0,0,0), hessian = TRUE, method = "BFGS")
res
