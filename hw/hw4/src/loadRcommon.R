if ( !("rcommon" %in% installed.packages()) ) {
  require('devtools')
  devtools::install_github('luiarthur/rcommon')
}
library(rcommon)
