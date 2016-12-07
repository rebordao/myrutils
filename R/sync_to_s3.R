#' Backups a list of folders into S3
#'
#' This function backups a list of folders into S3.
#' It requires that you install the AWS CLI and configure
#' in advance the connection to S3 via file ~/.aws/credentials.
#'
#' @param file credential file
#' @param bucket_path is the location where the backup is stored.
#' @import yaml
#' @export
#'
sync_to_s3 <- function(file = NULL, bucket_path) {

  if (is.null(file)){
    file = "~/.folders_to_back.yml"
  }

  # Read yml file with folders to backup
  folders <- yaml.load_file(file)

  # Sync to S3
  for (i in seq_along(folders)){
    system(sprintf(
      "aws s3 sync --profile s3_backup %s s3://%s/%s",
      normalizePath(folders[[i]]), bucket_path, gsub(".*/", "", folders[[i]])))
  }
}
