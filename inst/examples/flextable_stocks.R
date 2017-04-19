library(d3horizonR) # devtools::install_github("timelyportfolio/d3horizonR")
library(quantmod)

# get some stock data to use for our horizon charts
getSymbols("AAPL", from = "2016-01-01")
getSymbols("AMZN", from = "2016-01-01")
getSymbols("MSFT", from = "2016-01-01")

# cumulative rate of change function
croc <- function(stock) {return(stock[,6]/head(stock,1)[[6]] - 1)}

# test our croc function
plot(croc(AAPL))

# merge croc-transformed stock prices
stocks_croc <- merge(croc(AAPL), croc(AMZN), croc(MSFT))
colnames(stocks_croc) <- c("Apple", "Amazon", "Microsoft")
# visually inspect our croc-transformed stocks
plot.zoo(stocks_croc)

# make a quick d3 horizon chart
d3horizon(
  unname(lapply(stocks_croc, as.vector)),
  options = d3horizonOptions(
    # apply consistent scale to all the stocks
    extent = range(stocks_croc),
    height = 30,
    mode = "offset"
  ),
  width = 200,
  height = "auto"
)

# now try to integrate into a flextable
library(dplyr)
library(tidyr)
library(flextable) # devtools::install_github("davidgohel/flextable")
library(htmltools)

horizon_chr <- function(values, width = 200, height="auto", options=d3horizonOptions()) {
  htmltools::HTML(as.character(
    as.tags(
      d3horizon(
        list(values),
        options = options,
        height = height,
        width = width
      )
    )
  ))
}

tidyr::gather(as.data.frame(stocks_croc),stock) %>%
  group_by(stock) %>%
  summarise(
    croc = horizon_chr(
      value,
      options = d3horizonOptions(
        extent = range(stocks_croc),
        mode = "offset"
      ),
    )
  ) %>%
  flextable() %>%
  tabwid() %>%
  tagList(
    htmlwidgets:::widget_dependencies("d3horizon", package="d3horizonR")
  ) %>%
  browsable()
