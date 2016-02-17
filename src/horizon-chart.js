import {select} from 'd3-selection';
import {scaleLinear, scaleTime} from 'd3-scale';
import {axisTop} from 'd3-axis';


export default function() {


	// default settings:
	var colors = ['#3182bd', '#08519c'],
		bands = colors.length,
		width = 1000,
		height = 50,
		offsetX = 0,
		step = 2,
		spacing = 0,
		axis = undefined,
		title = undefined,
		// the extent is derived from the data, unless explicitly set via .extent([min, max])
		extent = undefined,
		// TODO: use ordinal scale instead?
		//x = d3.scaleLinear(),
		x = undefined,
		y = scaleLinear()
			.range([height, 0]),
		// the draw function that redraws the chart:
		_draw = undefined;

	/*
	 * Appends a canvas element to the current element
	 * and draws a horizon graph based on data & settings
	 */
    function my(data, i) {

		var horizon = select(this);
		var increment = step + spacing;

		// update the width
		//width = horizon.node().getBoundingClientRect().width;
		width = increment * data.length;

		var canvas = horizon
			.append("canvas")
			.attr("width", width)
			.attr("height", height);

	    horizon.append("span")
	        .attr("class", "title")
	        .text(title);

	    horizon.append("span")
	        .attr("class", "value");

		var context = canvas.node().getContext("2d");
		//context.translate(margin.left, margin.top);

		// update the y scale, based on the data extents
		y.domain( extent || d3.extent(data));

		//x = d3.scaleTime().domain[];

		axis = axisTop(x).ticks(5);


		function createOffscreenCanvas(width,height){
		    var canvas = document.createElement('canvas');
		    canvas.width = width;
		    canvas.height = height;
		    return canvas;
		}


		var offscreenCanvas = createOffscreenCanvas(increment * data.length, height);
		var offscreenContext = offscreenCanvas.getContext('2d');
	    // draw each band:
	    for (var b = 0; b < bands; b++) {
	        offscreenContext.fillStyle = colors[b];

	        // Adjust the range based on the current band index.
	        var y0 = (b + 1 - bands) * height;
	        y.range([bands * height + y0, y0]);

	        // draw the whole period on an offscreen canvas
	        for (var i = 0; i < data.length; i++) {
	          offscreenContext.fillRect(i * increment, y(data[i]), step, y(0) - y(data[i]));
	        }
	    }

	    var onscreenImage;
	    _draw = function() {
	    	onscreenImage = offscreenContext.getImageData(-offsetX, 0, width, height);
            context.putImageData(onscreenImage, 0, 0);

            //context.clearRect(0, 0, width, height);
            //context.translate(offsetX, 0);
            //context.drawImage(offscreenCanvas, offsetX, 0);
	    };

		/*
		_draw = function() {
			context.clearRect(0, 0, width, height);

			// the data frame currently being shown:
			var increment = step+spacing,
				startIndex = ~~ Math.max(0, -(offsetX / increment)),
				endIndex = ~~ Math.min(data.length, startIndex + width / increment);

			// skip drawing if there's no data to be drawn
			if (startIndex > data.length) return;

		    // draw each band:
		    for (var b = 0; b < bands; b++) {
		        context.fillStyle = colors[b];

		        // Adjust the range based on the current band index.
		        var y0 = (b + 1 - bands) * height;
		        y.range([bands * height + y0, y0]);

		        // only the current data frame is being drawn i.e. what's visible:
		        for (var i = startIndex; i < endIndex; i++) {
		          context.fillRect(offsetX + i * increment, y(data[i]), step, y(0) - y(data[i]));
		        }
		    }
		};
		*/

		_draw();
		/*
		setInterval(function() {
			offsetX -= 1;
			_draw();
		}, 1000);
		*/
	}

	my.axis = function(_) {
 		return arguments.length ? (axis = _, my) : axis;
	};

	// Array of colors representing the number of bands
	my.colors = function(_) {
	    if (!arguments.length) return colors;
	    colors = _;

	    // update the number of bands
	    bands = colors.length;

	    return my;
	};

	// get/set the height of the graph
	my.height = function(_) {
		return arguments.length ? (height = _, my) : height;
	};

	// get/set the step of the graph, i.e. the width of each bar
	my.step = function(_) {
		return arguments.length ? (step = _, my) : step;
	};

	// get/set the spacing between the bars of the graph
	my.spacing = function(_) {
	    if (!arguments.length) return spacing;
	    spacing = _;

	    // update the x scale, when the step changes
	    //x.range([0, step + spacing]);
	    return my;
	};

	// get/set the title of the horizon
	my.title = function(_) {
		if (!arguments.length) return title;

		title = _;
		return my;
	};

	// get/set the extents of the Y axis. If not set the extents are derived from the data
	my.extent = function(_) {
	    if (!arguments.length) return extent;
	    extent = _;

	    // update the y scale's domain when the extent changes
	    y.domain(extent);

	    return my;
	};

	my.offsetX = function(_) {
	    if (!arguments.length) return offsetX;
	    offsetX = _;

	    if (_draw) {
	    	_draw();
	    }

	    return my;
	};

	my.indexExtent = function() {
		// the data frame currently being shown:
		var increment = step+spacing,
			startIndex =  (-offsetX / increment),
			endIndex =  (startIndex + width / increment);

		return [startIndex, endIndex];
	};

	return my;


};
