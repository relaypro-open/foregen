requireNamespace("methods", quietly = TRUE)

#' A Reference Class to represent an event with start and end date and how it varies in time.
#' @importFrom methods setRefClass
#' @export
#' @field start A date string of the form "YYYY-MM-DD" or vector of date strings if the event has more than one start date.
#' @field end A date string of the form "YYYY-MM-DD" or vector of date strings if the event has more than one end date.
#' @field time_function A string naming the type of time function. ("none", "linear", "inverse"):
#'    "none" generates an indicator variable that is 1 between the endpoints (inclusive) and 0 otherwise.
#'    "linear" generates a continuous variable that starts at 1 on the start day and is incremented by one
#'    every subsiquent day and is zero outside start and end days.
#'    "inverse" generates a continuous variable that is starts at 1 on the start day and decrements as a function of 1/(1+days past start)
#'    and is zero outside start and end.

Event <- methods::setRefClass("Event",
                     fields = list(
                       start = "character",
                       end = "character",
                       time_function = "character"),
                     methods = list(
                       initialize =
                         function(..., start = "0001-01-01", end = "9999-01-01", time_function = "none") {
                           "Makes default event very long, to ease creation of single bounded event. Call Event() then set start or end date"
                           callSuper(..., start = start, end = end, time_function = time_function)
                           },
                       regressor = function (dates) {
                         "Create event regressor over a sequence of dates."
                         if (is.null(dates)) stop("dates is NULL")
                         if (class(dates) != "Date") stop("dates is not of class Date")
                         # Time function designations
                         linear_time <- function(dates, start) { return(as.numeric(dates - start) + 1) }
                         inverse_time <- function(dates, start) { return(1 / (as.numeric(dates - start) + 1)) }
                         days_past <- function(dates, start, end, time_function) {
                           if (length(dates) > 1) return(sapply(dates, function (date) {days_past(date, start, end, time_function)}))
                           else if ((dates - start) < 0 | (dates - end) > 0) return(0)
                           else {
                             return(
                               switch(time_function,
                                      linear = linear_time(dates,start),
                                      inverse = inverse_time(dates,start)
                               ))
                           }
                         }

                         indicator <- function(start, end) {
                           return(as.numeric(as.Date(start) <= dates & dates <= as.Date(end)))
                         }

                         if ((time_function != "none") & length(start) > 1) {
                           if (length(start) != length(end)) stop("Length of start and end dates don't match.")
                           return_val <- rep(0, length(dates))
                           for (i in 1:length(start)) {
                             return_val <- return_val + days_past(dates, as.Date(start[i]), as.Date(end[i]), time_function)
                           }
                           return(return_val)
                         }
                         else if (time_function != "none")
                           return (days_past(dates, as.Date(start), as.Date(end), time_function))
                         else if (length(start) > 1) {
                           return_val <- rep(0, length(dates))
                           for (i in 1:length(start)) {
                             return_val <- return_val + indicator(start[i], end[i])
                           }
                           return(return_val)
                         }
                         else return(indicator(start, end))
                       }
                     ))
