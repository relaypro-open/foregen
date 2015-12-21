# foregen

(fo)recast (re)gressor (gen)erator 
The motivation for this regressor generator is to be able to easily create regressors
for use in time series regression and forecasting.
It makes a data.frame that can be input into the xreg
argument as seen in the forecast package. 
It also has two other functions to help in creating
regressors from a table of events.

## Installation

You can also install the **development** version from [Github](https://github.com/wjhrdy/foregen)

```s
# install.packages("devtools")
library(devtools)
install_github("republicwireless-open/foregen") 
```

## Usage

```s
library(foregen)

regs_table <- data.frame(event=c("christmas", "christmas", "promotion"),
                         start=c("2014-12-25", "2015-12-25", "2015-11-27"),
                         end=c("2014-12-25", "2015-12-25", "2015-11-30"),
                         time_function= c("none","none","inverse"),
                         stringsAsFactors=FALSE)

events_to_regressors(table_to_events(regs_table),
                     seq(as.Date("2015-11-26"), as.Date("2016-01-01"), by = 1))

           christmas promotion
2015-11-26         0 0.0000000
2015-11-27         0 1.0000000
2015-11-28         0 0.5000000
2015-11-29         0 0.3333333
2015-11-30         0 0.2500000
2015-12-01         0 0.0000000
2015-12-02         0 0.0000000
2015-12-03         0 0.0000000
2015-12-04         0 0.0000000
2015-12-05         0 0.0000000
2015-12-06         0 0.0000000
2015-12-07         0 0.0000000
2015-12-08         0 0.0000000
2015-12-09         0 0.0000000
2015-12-10         0 0.0000000
2015-12-11         0 0.0000000
2015-12-12         0 0.0000000
2015-12-13         0 0.0000000
2015-12-14         0 0.0000000
2015-12-15         0 0.0000000
2015-12-16         0 0.0000000
2015-12-17         0 0.0000000
2015-12-18         0 0.0000000
2015-12-19         0 0.0000000
2015-12-20         0 0.0000000
2015-12-21         0 0.0000000
2015-12-22         0 0.0000000
2015-12-23         0 0.0000000
2015-12-24         0 0.0000000
2015-12-25         1 0.0000000
2015-12-26         0 0.0000000
2015-12-27         0 0.0000000
2015-12-28         0 0.0000000
2015-12-29         0 0.0000000
2015-12-30         0 0.0000000
2015-12-31         0 0.0000000
2016-01-01         0 0.0000000
```

## License

This package is free and open source software, licensed under MIT.
