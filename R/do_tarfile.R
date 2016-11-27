#' Compresses a set of files/folders into a tar file
#'
#' This function compresses a set of files/folders into a tar file.
#'
#' @param paths is a vector containing the absolute path of the files/folders to compress.
#' @param filename is the name of the resulting file sufixed with year, month and day.
#' @export
#'
do_tarfile <- function(paths, filename) {

  fname <- sprintf('%s_%s.tar.gz', filename, format(Sys.Date(), '%Y%m%d'))

  system(sprintf("tar -zcvf %s %s", fname, paste(paths, collapse = ' ')))
}
