HTMLWidgets.widget({

  name: 'd3horizon',

  type: 'output',

  factory: function(el, width, height) {

    var horizonChart;

    return {

      chart: horizonChart,

      renderValue: function(x) {

        horizonChart = d3.horizonChart()
          .height(80)
          .title('Horizon, 4-band')
          .colors(['#313695', '#4575b4', '#74add1', '#abd9e9', '#fee090', '#fdae61', '#f46d43', '#d73027']);


        var horizons = d3.select(el).selectAll('.horizon')
          .data(x.data)
          .enter().append('div')
          .attr('class', 'horizon')
          .each(horizonChart);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
