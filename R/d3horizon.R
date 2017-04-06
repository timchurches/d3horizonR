#' 'd3.js' Horizon Chart 'htmlwidget'
#'
#' Create a \code{d3.js} horizon chart using the \code{d3-horizon-chart}
#' plugin from \href{https://github.com/kmandov/d3-horizon-chart}{d3-horizon-chart} with
#' flexibility and convenience of \code{htmlwidgets}.
#'
#' @examples
#' #devtools::install_github("timelyportfolio/d3horizonR")
#' library(d3horizonR)
#'
#' d3horizon(
#'   lapply(1:10, function(x){cumprod(1+runif(1000,-0.02,0.02))-1})
#' )
#'
#' # demonstrate options
#' d3horizon(
#'   lapply(1:10, function(x){cumprod(1+runif(1000,-0.02,0.02))-1}),
#'   d3horizonOptions(height=30, colors = strtrim(cm.colors(4),7))
#' )
#'
#' @import htmlwidgets
#'
#' @export
d3horizon <- function(
  data = NULL,
  options = d3horizonOptions(),
  width = NULL, height = NULL,
  elementId = NULL
) {

  # forward options using x
  x = list(
    data = data,
    options = options
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'd3horizon',
    x,
    width = width,
    height = height,
    package = 'd3horizonR',
    elementId = elementId
  )
}

#' Options for d3horizon
#' @export
d3horizonOptions <- function(
  height = 80,
  title = "",
  colors = c("#313695", "#4575b4", "#74add1", "#abd9e9", "#fee090", "#fdae61", "#f46d43", "#d73027"),
  mode = "mirror",
  ...
) {
  list(
    height = height,
    title = title,
    colors = colors,
    mode = mode,
    ...
  )
}

#' Shiny bindings for d3horizon
#'
#' Output and render functions for using d3horizon within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a d3horizon
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name d3horizon-shiny
#'
#' @export
d3horizonOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'd3horizon', width, height, package = 'd3horizonR')
}

#' @rdname d3horizon-shiny
#' @export
renderD3horizon <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, d3horizonOutput, env, quoted = TRUE)
}


#' @import htmltools
#' @keywords internal
d3horizon_html <- function(id, style, class, ...){
  tagList(
    tags$div( id = id, class = class, style = style, ...)#,
    #d3r::d3_dep_v4()
  )
}
