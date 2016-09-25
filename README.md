# d3-horizon-chart

[![npm version](https://badge.fury.io/js/d3-horizon-chart.svg)](http://badge.fury.io/js/d3-horizon-chart)

`d3-horizon-chart` is a d3 plugin that draws horizon charts using an Html5 Canvas.
It provides an easy way to visualize large amounts of time series data.

The plugin is heavily inspired by [cubism.js](https://square.github.io/cubism/), but doesn't make assumptions about real-time metrics and back-end servers such as Cube/Graphite.
This makes it a good fit when you just want to plot your data as a horizon chart.

`d3-horizon-chart` follows the [latest plugin guidelines](https://bost.ocks.org/mike/d3-plugin/) using D3’s new 4.0 module pattern.

## Examples

Check out the [examples page](http://kmandov.github.io/d3-horizon-chart/)


## Installing

If you use NPM, `npm install d3-horizon-chart`. Otherwise, download the [latest release](https://github.com/kmandov/d3-horizon-chart/releases/latest).

## API Reference

Soon...

<a href="#horizon-chart" name="horizon-chart">#</a> <b>horizon-chart</b>()


## TODO

### Stable
- [x] Publish initial version
- [x] Add a simple usage example
- [x] Build the examples page with basscss
- [x] Add support for negative bands
- [x] Add example: stocks / ref: cubism
- [ ] Add the ‘d3-module’ keyword to the module
- [ ] Add support for values on mouse hover
- [ ] Example: Update the stock data & review the date parsing. Make it a gist.
- [ ] Example: time series: data + axis support
- [ ] Example: using browserify & webpack
- [ ] Example: pedestrian movement
- [ ] Example: Show values on mouse over
- [ ] Add +5 examples + gist code
- [ ] Add Screenshots to the Readme
- [ ] Add API reference
- [ ] Add axis support
- [ ] Review texts on the web page
- [ ] *Maybe* Change icons. Fast -> Horse / Race car. Simple -> Ameba

### Next
- [ ] Travis-ci / Circle-ci build integration
- [ ] Add codecov badge
- [ ] Add circleci badge
- [ ] Add eslint + indent rules
- [ ] Basic test coverage
- [ ] Add an example for responsive web pages
- [ ] Add it to the d3 plug-ins list
- [ ] Horizon Groups (i.e. cubism.js Context)
- [ ] Support for node-canvas.
- [ ] Handle canvas elements larger than 32767 px



