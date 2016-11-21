#' Prepare Backup File
#'
#' This function creates a tar file of a list of folders and then compresses it.
#'
#' @param paths is a vector containing the relative path of the folders to backup.
#' @export
#'
prepare_backup_file <- function(paths = c(
  "C:/Ithaka",
  "C:/Users/antonio.rebordao/Desktop",
  "C:/Users/antonio.rebordao/Documents",
  "C:/Users/antonio.rebordao/Downloads",
  "C:/Users/antonio.rebordao/software",
  "C:/Users/antonio.rebordao/.ssh"
  )) {

  file_name <- sprintf('aegate_backup_%s.tar.gz', format(Sys.Date(), '%Y%m%d'))

  system(sprintf("tar -zcvf %s %s", file_name, paste(paths, collapse = ' ')))
}
