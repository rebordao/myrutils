#' Opens JDBC Connection
#'
#' @param db_endpoint is the endpoint of the db instance.
#' @param db_name is the name of the database.
#' @param db_port is the db port.
#' @param db_type is the type of database (redshift, pgsql, sql, mysql)
#' @param username is an username with access to the db.
#' @param password is the password of the username.
#' @import RJDBC
#' @export
#'
get_db_conn <- function(db_endpoint = db_endpoint, db_name = db_name,
  db_port = db_port, db_type = db_type, username = username, password = password) {

  if (db_type == 'redshift') {

    # Creates redshift driver
    package_path <- system.file(package = 'myrutils', lib.loc = .libPaths())
    drv_path <- list.files(
    package_path, "^RedshiftJDBC42", full.names = T, recursive = T)
    db_drv <- RJDBC::JDBC("com.amazon.redshift.jdbc42.Driver", drv_path)

    # Creates url to access the database
    url <- sprintf('jdbc:redshift://%s:%s/%s?user=%s&password=%s',
      db_endpoint, db_port, db_name, username, password)
  }

  dbConnect(db_drv, url, DBMSencoding = "latin1")
}
