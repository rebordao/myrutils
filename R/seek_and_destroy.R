#' Remove unwanted files/folders
#'
#' Remove those unwanted files/folders that were generated automatically.
#' For example, '.DS_Store' or '.wercker'.\cr
#' As a security mechanism, only hardcoded file/folder names can be deleted.
#' Also, the seek and destroy operation only applies to ~/.
#'
#' @export
#' 
seek_and_destroy <- function(stuff_to_remove) {
  
  engine <- function(name) {
    # Only hardcoded file or folder names can be deleted
    stopifnot(name %in% c('.DS_Store', '.wercker'))
    
    system(
      sprintf("find %s -name %s -exec rm -vrf {} \\;", path.expand('~'), name))
  }
  
  sapply(stuff_to_remove, engine)
}