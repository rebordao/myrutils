#' No Overlapping Crong Jobs
#'
#' Avoids overlapping cron jobs using a PID-file method.\cr
#' Usage: insert myrutils::no_overlapping_cronjobs() in the R code that you want
#' to execute via the cronjob. Place it at the top of the script/function.
#'
#' @export
#'
no_overlapping_cronjobs <- function() {
  # Avoids overlapping cronjobs, uses a PID-file approach
  pid_file <- file.path('/tmp/pid_file.pid')
  if (file.exists(pid_file)) {
    pid_from_file <- system(paste("cat", pid_file), intern = T)
    if (!system(sprintf("ps -p %s > /dev/null 2>&1", pid_from_file))) {
      quit()
    }
  }
  # Write PID to file
  system(sprintf("echo %s > %s", Sys.getpid(), pid_file))
}
