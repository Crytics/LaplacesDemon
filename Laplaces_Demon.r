###############################################
# Laplace's Demon
# ---------------------------------
# Created by  : Adam Nguyen
# Updated by  : Adam Nguyen
# Created at  : 11/04/2014
# Updated at  : xx/xx/xxxx
# Description : Standalone Bayesian Environment
###############################################

#Clear Envisubronment
#rm(list = ls(all = TRUE))

#update.packages(ask = FALSE, dependencies = c('Suggests'))

#Set Directory
setInternet2(TRUE)
Sys.setenv(language = "en", tz = 'UTC')
options(max.print = 500)
setwd("C:/Users/adam.nguyen/Documents/GitHub/LaplacesDemon")
source(paste(c("C:/Users/adam.nguyen/Desktop/R/GH/", "library.R"), collapse = "")) #Get library
source(paste(c("C:/Users/adam.nguyen/Desktop/R/GH/", "break_munging.txt"), collapse = "")) #Get tools

#Install Laplace's Demon
install.packages("devtools")
library(devtools)
install_github("Statisticat/LaplacesDemon")
library(LaplacesDemon)
