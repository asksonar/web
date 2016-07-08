$(function(){
  if ($('#analysis-index').length === 0) {
    return;
  }

  // wrap pivottable renderers with nreco extensions
  var pivotStdRenderers = $.extend({}, $.pivotUtilities.renderers);
  var nrecoPivotExt = new NRecoPivotTableExtensions({
    wrapWith: '<div class="pvtTableRendererHolder"></div>',
    drillDownHandler: function(attrFilter) {
      console.log(attrFilter);
    },
    onSortHandler: function() {
      console.log('Sort changed!');
    },
    fixedHeaders : true
  });

  for (var rendererName in pivotStdRenderers) {
    // add sort handling to table renderer
    var renderer = nrecoPivotExt.wrapTableRenderer(pivotStdRenderers[rendererName]);
    pivotStdRenderers[rendererName] = renderer;
  }

  var allPivotRenderers = $.extend(pivotStdRenderers,
    $.pivotUtilities.gchart_renderers
  );

  for (var rendererName in allPivotRenderers) {
    // add data export api for renderer
    var renderer = allPivotRenderers[rendererName];
    allPivotRenderers[rendererName] = nrecoPivotExt.wrapPivotExportRenderer(renderer);
  }

  var chartAreaSize = {};

  $("#pivotHolder").pivotUI(
    input, {
      renderers: allPivotRenderers,
      rendererOptions: {},
      rows: ["Aircraft Model", "Aircraft Version"],
      cols: ["Aircraft Status"],
      menuLimit: 2000,
      unusedAttrsVertical: false,
      rendererOptions : {
        gchart: chartAreaSize
      },
      hiddenAttributes: ["MSN", "Registration", "Hours Cumulative", "Cycles Cumulative", "Age", "MTOW", "Engine Model", "Engine Verison"],
      derivedAttributes: {
        "Age": function(record) {
          if (record["Build Year"] > 2013) {
            return "Under 3 years";
          } else if (record["Build Year"] <= 2013 && record["Build Year"] > 2006) {
            return "3-10 years";
          } else {
            return "10+ years";
          }
        }
      }
    }
  );

  // calculate chart size to avoid horizontal scroll
  var refreshChartAreaSize = function () {
    chartAreaSize.width = $('#pivotHolder .pvtRendererArea').width() - 50;
    chartAreaSize.height = $('#pivotHolder .pvtRendererArea').width() / 2;
  };

  refreshChartAreaSize();

  // export demo
  var fillExportJsonForm = function ($f) {
    // getPivotExportData method is provided by nreco pivottable renderer extensions
    var reportData = $('#pivotHolder .pivotExportData').data('getPivotExportData')();
    console.log(reportData);
    $f.find('input[name="reportJson"]').val(JSON.stringify(reportData));
    var reportState = nrecoWebPivot.getState();
    var c = nrecoWebPivot.dataSchema.findClassById(reportState.relex_builder.class_id);
    $f.find('input[name="class_name"]').val(c != null ? c.name : "Data");
  };

  $('#exportToPdf').click(function () {
    var reportHtml = $('#pivotHolder .pvtRendererArea').html();
    var $f = $('#exportPdfForm');
    $f.find('input').val(reportHtml);
    $f.submit();
  });

  $('#exportToCsv').click(function () {
    var $f = $('#exportCsvForm');
    fillExportJsonForm($f);
    $f.submit();
  });

  $('#exportToExcel').click(function () {
    var $f = $('#exportExcelForm');
    fillExportJsonForm($f);
    $f.submit();
  });

});
