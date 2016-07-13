PivotTable = function(config, rowArray, colArray) {
  this.$pivotContainer = config.pivotContainer;

  this.rowArray = rowArray;
  this.colArray = colArray;
  
  this.init();
};

PivotTable.prototype.init = function() {
  var defaultParams = {
    rowArray: this.rowArray,
    colArray: this.colArray,
    renderer: "table",
    aggregator:  { name: "count", params: [] }
  };

  this.load(defaultParams.rowArray, defaultParams.colArray, defaultParams.renderer, defaultParams.aggregator);
};

PivotTable.prototype.getRenderer = function(name) {
  var defaultRenderers = $.pivotUtilities.renderers;
  var gchartRenderers = $.pivotUtilities.gchart_renderers;

  var renderers = {
    table: defaultRenderers["Table"],
    tableBarChart: defaultRenderers["Table Barchart"],
    heatmap: defaultRenderers["Heatmap"],
    colHeatmap: defaultRenderers["Col Heatmap"],
    rowHeatMap: defaultRenderers["Row Heatmap"],
    areaChart: gchartRenderers["Area Chart"],
    barChart: gchartRenderers["Bar Chart"],
    lineChart: gchartRenderers["Line Chart"],
    scatterChart: gchartRenderers["Scatter Chart"],
    stackedBarChart: gchartRenderers["Stacked Bar Chart"]
  };

  return renderers[name];
};

PivotTable.prototype.getAggregator = function(name) {
  var aggregatorTemplates = $.pivotUtilities.aggregatorTemplates;
  var numberFormat = $.pivotUtilities.numberFormat;
  var usFmt = numberFormat();

  var usFmtInt = numberFormat({
    digitsAfterDecimal: 0
  });

  var usFmtPct = numberFormat({
    digitsAfterDecimal: 1,
    scaler: 100,
    suffix: "%"
  });

  var aggregators = {
    count: aggregatorTemplates.count(usFmtInt),
    countUnique: aggregatorTemplates.countUnique(usFmtInt),
    listUnique: aggregatorTemplates.listUnique(", "),
    sum: aggregatorTemplates.sum(usFmt),
    intergerSum: aggregatorTemplates.sum(usFmtInt),
    average: aggregatorTemplates.average(usFmt),
    min: aggregatorTemplates.min(usFmt),
    max: aggregatorTemplates.max(usFmt)
  };

  return aggregators[name];
};

PivotTable.prototype.load = function(rowArray, colArray, renderer, aggregator) {
  var average = $.pivotUtilities.aggregatorTemplates.average;
  var numberFormat = $.pivotUtilities.numberFormat;
  var intFormat = numberFormat({digitsAfterDecimal: 0});

  this.$pivotContainer.pivot(
    data, {
      rows: rowArray,
      cols: colArray,
      renderer: this.getRenderer(renderer),
      aggregator: this.getAggregator(aggregator.name)(aggregator.params)
    }
  );
};
