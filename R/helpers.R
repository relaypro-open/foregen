#' Generates list of Events from table.
#' @export
#' @param regressors_table Data frame formatted as follows with all fields as strings.
#' \code{event      start       end         time_function}
#' \code{christmas  2014-12-25  2014-12-25  none         }
#' \code{christmas  2015-12-25  2015-12-25  none         }
#' \code{promotion  2015-11-27  2015-11-30  inverse      }
#'
#' @return Returns a list of Event reference classes.
#'     Grouping by event name.
#' @examples
#' regs_table <- data.frame(event=c("christmas", "christmas", "promotion"),
#'                          start=c("2014-12-25", "2015-12-25", "2015-11-27"),
#'                          end=c("2014-12-25", "2015-12-25", "2015-11-30"),
#'                          time_function= c("none","none","inverse"),
#'                          stringsAsFactors=FALSE)
#'
#' table_to_events(regs_table)
#'
table_to_events <- function(regressors_table) {
  events <- list()
  for (i in 1:nrow(regressors_table)) {
    # create new event if it doesnt exist
    if (is.null(events[[regressors_table$event[i]]])) {
      events[[regressors_table$event[i]]] <- Event()
      events[[regressors_table$event[i]]]$start <- regressors_table$start[i]
      if (!is.na(regressors_table$end[i]))
        events[[regressors_table$event[i]]]$end <- regressors_table$end[i]
      events[[regressors_table$event[i]]]$time_function <- regressors_table$time_function[i]
    }
    # add row to previously created event
    else {
      if (is.na(regressors_table$start[i])) {
        events[[regressors_table$event[i]]]$start <- c(events[[regressors_table$event[i]]]$start,
                                                       "0001-01-01")
      } else { events[[regressors_table$event[i]]]$start <- c(events[[regressors_table$event[i]]]$start,
                                                              regressors_table$start[i])}
      if (is.na(regressors_table$end[i])) {
        events[[regressors_table$event[i]]]$end <- c(events[[regressors_table$event[i]]]$end,
                                                     "9999-01-01")
      } else {
        events[[regressors_table$event[i]]]$end <- c(events[[regressors_table$event[i]]]$end,
                                                     regressors_table$end[i])
      }
    }
  }
  return(events)
}

#' Generates regressors from a named list of Events
#'
#' @export
#' @param events List of Event objects like the output from table_to_events().
#' @param dates Sequence of Date objects one for each row of the regressor table.
#' @param h Optional days to forecast for generating forecast regressors.
#' @param seasonal If true this will generate a single seasonal component with forecast::fourier(time_series, K=K) or
#'     forecast::fourierf(time_series, K=K, h=h) if h was specified.
#' @param time_series ts object that is the data you are trying to forecast.
#' @param K input to forecast::fourier() and forecast::fourierf()
#'
#'
#' @return Returns an xreg data.frame groups by event name.
#' @examples
#' regs_table <- data.frame(event=c("christmas", "christmas", "promotion"),
#'                          start=c("2014-12-25", "2015-12-25", "2015-11-27"),
#'                          end=c("2014-12-25", "2015-12-25", "2015-11-30"),
#'                          time_function= c("none","none","inverse"),
#'                          stringsAsFactors=FALSE)
#'
#' events_to_regressors(table_to_events(regs_table),
#'                      seq(as.Date("2015-11-01"), as.Date("2016-01-01"), by = 1))
#'
events_to_regressors <- function(events, dates, h = NULL, seasonal=T, time_series = NULL, K=3) {
  if (seasonal == T & !is.null(time_series)) {
    requireNamespace("forecast", quietly = TRUE)
    if (is.null(h)) {
      regressors <- forecast::fourier(time_series, K=K)
    } else {
      regressors <- forecast::fourierf(time_series, K=K, h)
    }
    for (i in 1:length(events)) {
      df <- data.frame(events[[i]]$regressor(dates))
      names(df) <- names(events)[i]
      regressors <- cbind(regressors, df)
    }
    return(regressors)
  }
  else {
    regressors <- list()
    for (i in 1:length(events)) {
      regressors[[names(events)[i]]] <- events[[i]]$regressor(dates)
    }
    return(as.data.frame(regressors))
  }
}
