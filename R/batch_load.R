#' Batch Load Packages
#' 
#' Installs packages if they don't exist in the system and then loads them.\cr
#' Ex:
#' packages <- c(
#'   'tidyverse',  
#'   'stringr',
#'   'DT')
#' batch_load(packages)
#' 
#' @param pkgs Is a vector containing the names of the packages.
#' @importFrom utils install.packages installed.packages
#' @export
#' 
batch_load <- function(pkgs) {
  
  new_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if (length(new_pkgs)) install.packages(new_pkgs, dependencies = TRUE)
  invisible(sapply(pkgs, library, character.only = TRUE))
}