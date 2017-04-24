library(htmltools)
library(vueR)
library(d3horizonR)
library(d3r)
library(dplyr)
library(tibble)

#### Element examples ####################################
element <- htmlDependency(
  name = "element",
  version = "1.2.9",
  src = c(href="https://unpkg.com/element-ui/lib"),
  script = "index.js",
  stylesheet = "theme-default/index.css"
)

#make some random treemap data
rhd <- treemap::random.hierarchical.data()
#change x to be a series of random data for a horizon
rhd <- rhd %>%
  mutate(x = lapply(x, function(x) {cumprod(1 + runif(365, -0.05, 0.05)) - 1}))

tl_tree <- tagList(
  tags$div(
    id = "app",
    tag(
      "el-tree",
      list(
        "ref" = "mytree",
        ":data" = "data.children",
        ":props" = "defaultProps",
        "show-checkbox" = NA,
        ":render-content" = "renderContent",
        "@node-expand" = "makeHorizon"
      )
    )
  ),
  tags$script(HTML(
sprintf(
"
var app = new Vue({
  el: '#app',
  data: {
    data:%s,
    defaultProps: {
      'children': 'children',
      'label': 'name'
    }
  },
  methods: {
    renderContent: function (createElement, x) {
      return createElement('div',
        {style: {display: 'inline'}},
        [
          x.data.name,
          createElement('div', {class: 'horizoncontainer', style: {display:'inline'}, domProps: {'__data__': [x.data.x]}})
        ]
      )
    },
    makeHorizon: function(closed, props, open) {
      var hzw = HTMLWidgets.widgets.filter(function(w) {return w.name === 'd3horizon'})[0];
      Array.prototype.forEach.call(
        open.$el.querySelectorAll('.horizoncontainer'),
        function(d) {
          var instance = hzw.initialize(d);
          if(d.__data__[0]) {
            instance.renderValue({data: d.__data__, options:{width:200, height:35}});
            d.querySelector('.horizon').style.display = 'inherit';
            d.querySelector('canvas').style.verticalAlign = 'middle';
          }
        }
      )
    }
  }
})
",
d3r::d3_nest(
  rhd,
  value_cols="x"
)
)
  )),
  html_dependency_vue(),
  element,
  htmlwidgets::getDependency("d3horizon", "d3horizonR")
)

browsable(
  tl_tree
)


library(htmltools)
library(vueR)
library(d3horizonR)
library(d3r)
library(dplyr)
library(tibble)

#### Element examples ####################################
element <- htmlDependency(
  name = "element",
  version = "1.2.9",
  src = c(href="https://unpkg.com/element-ui/lib"),
  script = "index.js",
  stylesheet = "theme-default/index.css"
)

#make some random treemap data
rhd <- treemap::random.hierarchical.data()

rhd_tree <- rhd %>%
  treemap::treemap(
    index = c("index1", "index2", "index3"),
    vSize = "x"
  ) %>%
  {tbl_df(.$tm)} %>%
  mutate(dat = lapply(index1, function(x) {cumprod(1 + runif(365, -0.05, 0.05)) - 1}))

tl_tree <- tagList(
  tags$div(
    id = "app",
    tag(
      "el-tree",
      list(
        "ref" = "mytree",
        ":data" = "data.children",
        ":props" = "defaultProps",
        "show-checkbox" = NA,
        ":render-content" = "renderContent"
      )
    )
  ),
  tags$script(HTML(
    sprintf(
"
function makeHorizon() {
  var hzw = HTMLWidgets.widgets.filter(function(w) {return w.name === 'd3horizon'})[0];
  Array.prototype.forEach.call(
    this.$el.querySelectorAll('.horizoncontainer'),
    function(d) {
      var instance = hzw.initialize(d);
      if(d.__data__) {
        instance.renderValue({data: d.__data__, options:{width:200, height:35}});
        d.querySelector('.horizon').style.display = 'inherit';
        d.querySelector('canvas').style.verticalAlign = 'middle';
      }
    }
  )
}

var app = new Vue({
  el: '#app',
  data: {
    data:%s,
    defaultProps: {
    'children': 'children',
    'label': 'name'
    }
  },
  methods: {
    renderContent: function (createElement, x) {
      return createElement('div',
        {style: {display: 'inline'}},
        [
          createElement('span', {style: {borderColor: x.data.color, borderStyle: 'solid', borderWidth: '0px 0px 0px 10px'}}, x.data.name),
          createElement('div', {class: 'horizoncontainer', style: {display:'inline'}, domProps: {'__data__': [x.data.dat]}} )
        ]
      )
    }
  },
  mounted: makeHorizon,
  watch: {
    data: {
      handler: function(newVal, oldVal) {
        this.$nextTick(makeHorizon);
      },
      deep: true
    }
  }
})
",
rhd_tree %>%
  select(index1:index3, vSize, color, dat) %>%
  rename(size = vSize) %>%
  d3_nest(
    value_cols = c("size", "color", "dat")
  )
)
  )),
  html_dependency_vue(),
  element,
  htmlwidgets::getDependency("d3horizon", "d3horizonR")
)

browsable(
  tl_tree
)
