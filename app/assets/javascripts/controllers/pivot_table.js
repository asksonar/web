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
    exclusions: {},
    renderer: { name: "table", type: "text" },
    aggregator:  { name: "Count", params: [] }
  };

  this.load(defaultParams.rowArray, defaultParams.colArray, defaultParams.exclusions, defaultParams.renderer, defaultParams.aggregator);

  this.$btnSaveImg.on('click', $.proxy(this.saveAsImg, this));
};

PivotTable.prototype.load = function(rowArray, colArray, filters, renderer, aggregator) {
  var renderers = $.extend(
    $.pivotUtilities.renderers,
    $.pivotUtilities.gchart_renderers,
    $.pivotUtilities.export_renderers
  );

  this.$pivotContainer.pivotUI(
    data, {
      renderers: renderers,
      rows: rowArray,
      cols: colArray,
      exclusions: filters,
      rendererName: renderer.name,
      aggregatorName: aggregator.name,
      vals: aggregator.params
    }, true
  );

  if ( renderer.type === "svg" ) {
    this.$btnSaveImg.removeClass('hidden');
  } else {
    this.$btnSaveImg.addClass('hidden');
  }

  if ( renderer.name === "TSV Export" ) {
    $("#pivot-container .pvtUi").after(
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
