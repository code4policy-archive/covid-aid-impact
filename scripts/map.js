var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height");

// Map and projection
var path = d3.geoPath();
var projection = d3.geoNaturalEarth()
    .scale(width / 2 / Math.PI)
    .translate([width / 2, height / 2])
var path = d3.geoPath()
    .projection(projection);

// Data and color scale
var data = d3.map();
var colorScheme = d3.schemeRdBu[8];
colorScheme.unshift("#eee")
var colorScale = d3.scaleThreshold()
    .domain([-100, -75, -50, -25, -10, 10, 25, 50, 75, 100])
    .range(['#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850']);

// Legend
var g = svg.append("g")
    .attr("class", "legendThreshold")
    .attr("transform", "translate(20,20)");
g.append("text")
    .attr("class", "caption")
    .attr("x", 0)
    .attr("y", -6)
    .text("Change in the percentage of aid projects");
var labels = ['-100% to -75%', '-75% to 50%', '-50% to 25%', '-25% to -10%','-10% to 10%', '10% to 25%', '25% to 50%', '50% to 75%', '75% to 100%'];
var legend = d3.legendColor(['#66bd63'])
    .labels(function (d) { return labels[d.i]; })
    .shapePadding(4)
    .scale(colorScale);
svg.select(".legendThreshold")
    .call(legend);

// Load external data and boot
d3.queue()
    .defer(d3.json, "http://enjalot.github.io/wwsd/data/world/world-110m.geojson")
    .defer(d3.csv, "data/country_projects.csv", function(d) { data.set(d.Alpha_3_code, +d.change_from_average); })
    .await(ready);

function ready(error, topo) {
    if (error) throw error;

    // Draw the map
    svg.append("g")
        .attr("class", "countries")
        .selectAll("path")
        .data(topo.features)
        .enter().append("path")
            .attr("fill", function (d){
                // Pull data for this country
                d.change_from_average = data.get(d.id) || 0;
                // Set the color
                return colorScale(d.change_from_average);
            })
            .attr("d", path);
}

