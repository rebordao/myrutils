#' Backups a list of folders into S3
#'
#' This function backups a list of folders into S3.
#' It requires that you:
#' \itemize{
#'   \item install the AWS CLI;
#'   \item configure a profile in file ~/.aws/credentials;
#'   \item create an s3 bucket where the profile can read/write into;
#'   \item create a yaml file containing the list of folders for backup.
#' }
#' Optionally it's possible to define file/folder/pattern exclusions.\cr
#' To avoid concurrent cronjobs I implemented a PIDfile-based method
#' (checks if last PID is still active; if yes, do nothing; if not, execute).
#'
#' @param bucket Is the name of the s3 bucket where the backup is stored.
#' @param root_folder Is the name of the root folder where the backup
#' is stored. \cr If it doesn't exist, it's created automatically.
#' @param profile Is a profile name contained in ~/.aws/credentials.
#' @param dryrun When equal to T doesn't backup. Only does simulation.
#' @param folders_file Is the path of the file that contains the folders to backup.
#' By default is ~/.folders_to_backup.yml.
#' Example file in folder inst/config.
#' @param exclusions_file is the path of the file (if applicable) that
#' contains the folders or patterns to exclude from the backup.
#' By default is ~/.exclusions_from_backup.yml.
#' Example file in folder inst/config.
#' @import yaml
#' @import futile.logger
#' @export
#'
backup_to_s3 <- function(
  bucket, root_folder, profile, dryrun = T,
  folders_file = '~/.folders_to_backup.yml',
  exclusions_file = '~/.exclusions_from_backup.yml') {

  # Create appender (writes logs to file + console)
  invisible(flog.appender(appender.tee('~/.backup_to_s3.log')))

  # Avoid overlapping cronjobs
  myrutils::no_overlapping_cronjobs()

  # Check if aws cli is installed
  flog.info("Testing if aws cli is installed")
  is_awscli_installed <- function() {
    any(
      grepl("aws: command not found",
            system("aws --version &>/dev/null", intern = T), fixed = T))
  }
  testthat::expect_false(is_awscli_installed(), "aws cli not installed")

  # Check if aws's profile works
  flog.info(sprintf("Testing if aws profile %s exists", profile))
  does_profile_works <- function() {
    any(
      grepl(sprintf(" (%s) couldn't be found", profile),
            system(sprintf("aws s3 ls --profile %s", profile), intern = T),
            fixed = T))
  }
  testthat::expect_false(
    does_profile_works(), sprintf("Profile %s doesn't exist", profile))

  # Check if s3 bucket exists
  flog.info(sprintf("Testing if bucket %s exists", bucket))
  does_bucket_exist <- function() {
    any(
      grepl(sprintf(" %s", bucket),
            system(sprintf("aws s3 ls --profile %s", profile), intern = T),
            fixed = T))
  }
  testthat::expect_true(
    does_bucket_exist(), sprintf("Bucket %s doesn't exist", bucket))

  # Read yml with folders to backup
  flog.info("Reading yml file with folders to backup")
  folders <- yaml.load_file(folders_file)

  # Sync engine, preserves directory structure
  sync_engine <- function(folder_2_backup) {
    flog.info(
      sprintf("Backuping up folder %s into bucket %s", folder_2_backup, root_folder))

    backup_str <- sprintf(
      "aws s3 sync %s s3://%s/%s/%s --dryrun --delete --profile %s",
      normalizePath(folder_2_backup), bucket, root_folder,
      basename(folder_2_backup), profile)

    if (!dryrun) {
      # Does real backup, does it when simulation is off (dryrun = F)
      backup_str <- gsub("--dryrun ", "", backup_str)
    }

    # Add folders/patterns to be excluded from backup (if applicable)
    if (file.exists(exclusions_file)) {
      exclusions <- yaml.load_file(exclusions_file)
      backup_str <- paste(
        backup_str, paste0("--exclude ", "'", exclusions, "'", collapse = " "))
    }

    system(backup_str)
  }

  # Sync to S3
  invisible(sapply(folders, sync_engine))
}
