#' Compresses a set of files/folders into a tar.gz file
#'
#' Compresses a set of files/folders into a tar.gz file.
#' Saves output into working directory.
#'
#' @param folders Is a vector containing the paths of the
#' files/folders to compress. They can be absolute or relative.
#' @param filename Is the name for the resulting tar.gz file. This name will be
#' sufixed with year, month and day.
#' @export
#'
do_tarfile <- function(folders, filename) {
  
  fname <- sprintf('%s_%s', filename, format(Sys.Date(), '%Y%m%d'))
  
  # Doesn't preserve folder structure, only copies basename of dirs in folders.
  system(
    sprintf("tar -cvf %s.tar.gz %s", fname, 
            paste('-C', 
                  dirname(normalizePath(folders)), 
                  basename(normalizePath(folders)), collapse = ' ')))
}
