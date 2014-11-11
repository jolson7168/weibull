#load the weibull libraries
install.packages("Rcpp",repos="http://cran.r-project.org")
install.packages("RcppArmadillo",repos="http://cran.r-project.org")
install.packages("pivotals",repos="http://R-Forge.R-project.org")
install.packages("debias",repos="http://R-Forge.R-project.org")
install.packages("abremPivotals",repos="http://R-Forge.R-project.org")
install.packages("abrem",repos="http://R-Forge.R-project.org")
install.packages("survival",repos="http://cran.r-project.org")
install.packages("jsonlite",repos="http://cran.r-project.org")
install.packages("httpuv",repos="http://cran.r-project.org")
#Start the service
Rscript /home/ec2-user/git/weibull/src/listener.R > /home/ec2-user/git/weibull/scripts/r.out &
