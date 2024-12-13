# Same operation executed in parallel
library(parallel)
# Create cluster
cl <- parallel::makeCluster(parallel::detectCores())
system.time(
  parallel::parSapply(cl, 1:1000, function(i) {
    x = rnorm(100000)
    mean(x) / sd(x)
  })
)

system.time(
  ccf_boot(diff(BJsales.lead), diff(BJsales),plot="Spearman",cl = cl)
)
system.time(
  ccf_boot(diff(BJsales.lead), diff(BJsales),plot="Spearman")
)

stopCluster(cl)

system.time(
  causality_pred(Canada[,1:2], cause = "e",
                 lag.max = 5, p.free = TRUE, B = 1000L, cl = cl)
)

library(funtimes)
library(parallel)

# Define a wrapper for ccf_boot
run_ccf_boot <- function(data1, data2, num_boot, lag) {
  ccf_boot(data1, data2, n.boot = num_boot, lag.max = lag)
}

# Sample data
set.seed(123)
data1 <- rnorm(100)
data2 <- rnorm(100)

# Parameters
num_cores <- detectCores() - 1
num_boot <- 100  # Total number of bootstraps
lag_max <- 10

# Create a cluster
cl <- makeCluster(num_cores)

# Split bootstraps among cores
boot_per_core <- ceiling(num_boot / num_cores)
boot_results <- parLapply(cl, 1:num_cores, function(i) {
  ccf_boot(data1, data2, n.boot = boot_per_core, lag.max = lag_max)
})

# Stop the cluster
stopCluster(cl)

# Combine results (you might need to merge bootstrapping outputs depending on structure)
final_result <- do.call(rbind, boot_results)

print(final_result)