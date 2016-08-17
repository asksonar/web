PivotTable = function(config, pivotParams) {
  this.$pivotContainer = config.pivotContainer;
  this.$btnSaveImg = config.btnSaveImg;

  this.pivotParams = {
    rowArray: pivotParams.rowArray || [],
    colArray: pivotParams.colArray || [],
    filters: pivotParams.filters || {},
    renderer: pivotParams.renderer || { name: "table", type: "text" },
    aggregator:  pivotParams.aggregator || { name: "count", params: [] }
  };

  this.init();
};

PivotTable.prototype.init = function() {
  this.load(
    this.pivotParams.rowArray,
    this.pivotParams.colArray,
    this.pivotParams.filters,
    this.pivotParams.renderer,
    this.pivotParams.aggregator
  );
  this.$btnSaveImg.on('click', $.proxy(this.saveAsImg, this));
};

PivotTable.prototype.load = function(rowArray, colArray, filters, renderer, aggregator) {
  this.$pivotContainer.pivot(
    data, {
      rows: rowArray,
      cols: colArray,
      renderer: this.getRenderer(renderer.name),
      aggregator: this.getAggregator(aggregator.name)(aggregator.params),
      filter: this.pivotFilter.bind(this, filters)
    }
  );

  if ( renderer.name === "tsvExport" ) {
    this.addBtnExportTsv();
  }

  this.toggleBtnSaveImg(renderer);
};

PivotTable.prototype.pivotFilter = function(filters, record) {
  var excludedItems;
  for (var key in filters) {
    excludedItems = filters[key];
    if (record[key].length === 0 || excludedItems.indexOf(record[key]) >= 0) {
      return false;
    }
  }
  return true;
};

PivotTable.prototype.getRenderer = function(name) {
  var defaultRenderers = $.pivotUtilities.renderers;
  var gchartRenderers = $.pivotUtilities.gchart_renderers;
  var exportRenderers = $.pivotUtilities.export_renderers;

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
    stackedBarChart: gchartRenderers["Stacked Bar Chart"],
    tsvExport: exportRenderers["TSV Export"]
  };

  return renderers[name];
};

PivotTable.prototype.getAggregator = function(name) {
  var aggregatorTemplates = $.pivotUtilities.aggregatorTemplates;
  var numberFormat = $.pivotUtilities.numberFormat;

  var usFmt = numberFormat();
  var usFmtInt = numberFormat({ digitsAfterDecimal: 0 });
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
    average: aggregatorTemplates.average(usFmtInt),
    min: aggregatorTemplates.min(usFmtInt),
    max: aggregatorTemplates.max(usFmtInt)
  };

  return aggregators[name];
};

PivotTable.prototype.addBtnExportTsv = function() {
  $("#pivot-container textarea").after(
    "<a class='btn btn-dark-blue pull-right' id='btn-tsv-export' data-placement='top' \
      title='Copied!' data-toggle='tooltip' data-trigger='manual'>Copy</a>"
  );

  new ZeroClipboard($('#btn-tsv-export').get())
    .on("copy", $.proxy(function (event) {
      event.clipboardData.setData("text/plain", $('textarea').val());
      var el = $('textarea').get(0);
      el.setSelectionRange(0, el.value.length);
    }, this))
    .on("aftercopy", function (event) {
      $('#btn-tsv-export').tooltip('show');
      setTimeout(function() {
        $('#btn-tsv-export').tooltip('hide');
      }, 1000);
    });
};

PivotTable.prototype.toggleBtnSaveImg = function(renderer) {
  if ( renderer.type === "svg" ) {
    this.$btnSaveImg.removeClass('hidden');
  } else {
    this.$btnSaveImg.addClass('hidden');
  }
};

PivotTable.prototype.getImgData = function() {
  // extract svg code for google chart
  var chartContainer = this.$pivotContainer;
  var chartArea = chartContainer.find('svg').parent();
  var svg = '<svg>' + chartContainer.find('svg').html() + '</svg>';

  // create a canvas element and position it offscreen
  var canvas = $('<canvas></canvas>');
  canvas.attr('width', chartArea.width());
  canvas.attr('height', chartArea.height());
  canvas.css({
    'position': 'absolute',
    'top': -chartArea.height() * 2,
    'left': -chartArea.width() * 2
  });
  $('body').append(canvas);

  // parses the svg and renders the result on the canvas element
  canvg(canvas[0], svg);

  // extract the image data as a base64 encoded string
  var imgData = canvas[0].toDataURL("image/png");

  canvas.remove()
  return imgData;
};

PivotTable.prototype.saveAsImg = function() {
  var imgData = this.getImgData();

  // Replacing the mime-type will force the browser to trigger a download
  // rather than displaying the image in the browser window.
  window.location = imgData.replace("image/png", "image/octet-stream");
};
