\dontrun{
library(dplyr)
library(tibble)
library(htmltools)
library(DT)
library(d3horizonR)
library(treemap) # for helpful random hierarchical data function


hier <- tbl_df(treemap::random.hierarchical.data(depth=3))

# see it in DT
datatable(hier)

# with dplyr make some random data for a horizon chart
#   we can replace x with this new data
hier <- hier %>%
  mutate(x = lapply(x, function(x) {cumprod(1 + runif(365, -0.05, 0.05))})) %>%
  # tranform our new x into a d3horizon chart
  mutate(x = lapply(x, function(dat) {
    d3horizon_chr(
      list(dat),
      options = d3horizonOptions(height=20),
      width = 200
    )
  }))

datatable(
  hier,
  escape = FALSE,
  options = list(
    columnDefs = list(list(width="200px", targets = 4)),
    fnDrawCallback = htmlwidgets::JS(
'
// not the best way but works fairly well
function(){
  HTMLWidgets.staticRender();
}
'
    )
  )
) %>%
  tagList(htmlwidgets::getDependency("d3horizon", "d3horizonR")) %>%
  browsable()
}
