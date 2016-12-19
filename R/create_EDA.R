#' Create EDA
#'
#' Create the initial structure for an EDA.
#'
#' @param eda_name Is the name for the EDA.
#' @export
#'
create_EDA <- function(eda_name) {
  # Copy template file to working directory
  file.copy(
    file.path(system.file(package = 'myrutils'), 'config/template_EDA.Rmd'),
    file.path(getwd(), sprintf('%s.Rmd', eda_name)))
}
