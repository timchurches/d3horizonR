#' Character Version of d3horizon
#'
#' Create a character version of interactive sparklines
#' for use with other 'htmlwidgets' or tags.
#'
#' @inheritParams d3horizon
#'
#' @import htmlwidgets htmltools
#' @export
#'
#' @example inst/examples/example_DT.R

d3horizon_chr <- function(...) {
  htmltools::HTML(
    as.character(
      htmltools::as.tags(
        d3horizon(...)
      )
    )
  )
}


