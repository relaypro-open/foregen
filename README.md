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
install_github("wjhrdy/foregen") 
```

## Usage

```s
install.packages('foregen')

regs_table <- data.frame(event=c("christmas", "christmas", "promotion"),
                         start=c("2014-12-25", "2015-12-25", "2015-11-27"),
                         end=c("2014-12-25", "2015-12-25", "2015-11-30"),
                         time_function= c("none","none","inverse"),
                         stringsAsFactors=FALSE)

events_to_regressors(table_to_events(regs_table),
                     seq(as.Date("2015-11-26"), as.Date("2016-01-01"), by = 1))

   christmas promotion
1          0 0.0000000
2          0 1.0000000
3          0 0.5000000
4          0 0.3333333
5          0 0.2500000
6          0 0.0000000
7          0 0.0000000
8          0 0.0000000
9          0 0.0000000
10         0 0.0000000
11         0 0.0000000
12         0 0.0000000
13         0 0.0000000
14         0 0.0000000
15         0 0.0000000
16         0 0.0000000
17         0 0.0000000
18         0 0.0000000
19         0 0.0000000
20         0 0.0000000
21         0 0.0000000
22         0 0.0000000
23         0 0.0000000
24         0 0.0000000
25         0 0.0000000
26         0 0.0000000
27         0 0.0000000
28         0 0.0000000
29         0 0.0000000
30         1 0.0000000
31         0 0.0000000
32         0 0.0000000
33         0 0.0000000
34         0 0.0000000
35         0 0.0000000
36         0 0.0000000
37         0 0.0000000
```

## License

This package is free and open source software, licensed under MIT.
