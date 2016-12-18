#' Create an Exploratory Data Analysis project
#'
#' This function creates an architecture and structure for an EDA project.
#'
#' @param project_name Is the name of the EDA project.
#' @export
#'
create_EDA_project <- function(project_name) {

  # Create project dir
  dir.create(path = project_name, mode = '0755')

  setwd(project_name)

  # Copy EDA template into wd
  file.copy(
    file.path(system.file(package = 'myrutils'), 'config/template_EDA.Rmd'),
    file.path(getwd(), sprintf('%s.Rmd', project_name)))

  # Create a Rstudio project Rproj file
  file.copy(
    file.path(system.file(package = 'myrutils'), 'config/template_Rproj.Rproj'),
    file.path(getwd(), sprintf('%s.Rproj', project_name)))
}
