#' Backups a list of folders into S3
#'
#' This function backups a list of folders into S3.
#' It requires that you install the AWS CLI and configure
#' a profile called backuper in file ~/.aws/credentials.
#'
#' @param file_path is the path of the file that contains the folders to backup.
#' By default is ~/.folders_to_backup.yml. Example file in folder inst/config.
#' @param bucket_name is the name of the bucket where the backup is stored.
#' If it doesn't exist, it's created automatically.
#' @param folder_name is the name of the root folder where the backup is stored.
#' If it doesn't exist, it's created automatically.
#' @import yaml
#' @export
#'
backup_to_s3 <- function(
  bucket_name, folder_name, file_path = '~/.folders_to_backup.yml') {

  # Read yml file with folders to backup
  folders <- yaml.load_file(file_path)

  # Test that the connection to S3 is possible
  # TODO:

  # Test that a bucket can be created (right permissions or credentials)
  # TODO:

  # Check if bucket exists
  does_bucket_exist <- any(
    grepl(pattern =  sprintf(" %s", bucket_name),
          x = system("aws s3 ls --profile backuper", intern = T),
          fixed = T))

  # Create bucket if it doesn't exist
  # This requires bucket creation permissions (defined in permission policy)
  if (!does_bucket_exist) {
    system(sprintf("aws s3 mb s3://%s --profile backuper", bucket_name))
  }

  # Sync engine, preserves directory structure
  # TODO: add exclude files capability, remove dryrun
  sync_engine <- function(folder) {
    system(sprintf(
      "aws s3 sync %s s3://%s/%s/%s --dryrun --delete --profile backuper",
      normalizePath(folder), bucket_name, folder_name, basename(folder)))
  }

  # Sync to S3
  invisible(sapply(folders, sync_engine))
}
