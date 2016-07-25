PivotTable = function(config, rowArray, colArray) {
  this.$pivotContainer = config.pivotContainer;
  this.$btnSaveImg = config.btnSaveImg;

  this.rowArray = rowArray;
  this.colArray = colArray;

  this.init();
};

PivotTable.prototype.init = function() {
  var defaultParams = {
    rowArray: this.rowArray,
    colArray: this.colArray,
    filters: {},
    renderer: { name: "table", type: "text" },
    aggregator:  { name: "count", params: [] }
  };

  this.load(defaultParams.rowArray, defaultParams.colArray, defaultParams.filters, defaultParams.renderer, defaultParams.aggregator);
  this.$btnSaveImg.on('click', $.proxy(this.saveAsImg, this));
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
    average: aggregatorTemplates.average(usFmt),
    min: aggregatorTemplates.min(usFmt),
    max: aggregatorTemplates.max(usFmt)
  };

  return aggregators[name];
};

PivotTable.prototype.load = function(rowArray, colArray, filters, renderer, aggregator) {
  this.$pivotContainer.pivot(
    data, {
      renderer: this.getRenderer(renderer.name),
      aggregator: this.getAggregator(aggregator.name)(aggregator.params),
      rows: rowArray,
      cols: colArray,
      filter: function(record) {
        var excludedItems;
        for (var key in filters) {
          excludedItems = filters[key];
          if (record[key].length === 0 || excludedItems.indexOf(record[key]) >= 0) {
            return false;
          }
        }
        return true;
      }
    }
  );

  if ( renderer.type === "svg" ) {
    this.$btnSaveImg.removeClass('hidden');
  } else {
    this.$btnSaveImg.addClass('hidden');
  }

  if ( renderer.name === "tsvExport" ) {
    $("#pivot-container textarea").after(
      "<a class='btn btn-dark-blue pull-right' id='btn-tsv-export' \
        data-placement='top' title='Copied!' data-toggle='tooltip' data-trigger='manual'>Copy</a>"
    )

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
  }
};

PivotTable.prototype.getImgData = function() {
  var chartContainer = document.getElementById('pivot-container');
  var chartArea = chartContainer.getElementsByTagName('svg')[0].parentNode;
  var svg = '<svg>' + chartContainer.getElementsByTagName('svg')[0].innerHTML + '</svg>'
  var doc = chartContainer.ownerDocument;
  var canvas = doc.createElement('canvas');
  canvas.setAttribute('width', chartArea.offsetWidth);
  canvas.setAttribute('height', chartArea.offsetHeight);
  canvas.setAttribute(
      'style',
      'position: absolute; ' +
      'top: ' + (-chartArea.offsetHeight * 2) + 'px;' +
      'left: ' + (-chartArea.offsetWidth * 2) + 'px;');
  doc.body.appendChild(canvas);

  // parses the svg and renders the result on a Canvas element
  canvg(canvas, svg);
  var imgData = canvas.toDataURL("image/png");
  canvas.parentNode.removeChild(canvas);
  return imgData;
};

PivotTable.prototype.saveAsImg = function(chartContainer) {
  var imgData = this.getImgData(chartContainer);

  // Replacing the mime-type will force the browser to trigger a download
  // rather than displaying the image in the browser window.
  window.location = imgData.replace("image/png", "image/octet-stream");
};
