$(function(){
  if ($('#trends-index').length === 0) {
    return;
  }

  // var chartData = generateChartData();
  var chartData = nps_by_date_json; // need to be sort chronologically to begin with
  var chart = AmCharts.makeChart("chart", {
      "pathToImages": "assets/amcharts3/amcharts/images/",
      "addClassNames": true,
      "type": "serial",
      "theme": "light",
      "marginRight": 80,
      "autoMarginOffset": 20,
      "marginTop": 7,
      "dataProvider": chartData,
      "valueAxes": [{
          "axisAlpha": 0.2,
          "dashLength": 1,
          "position": "left",
          "minimum": -100,
          "maximum": 100
      }],
      "mouseWheelZoomEnabled": true,
      "graphs": [{
          "id": "g1",
          "balloonText": "[[category]]<br/><b><span style='font-size:14px;'>NPS: [[value]]</span></b>",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          // "bulletColor": "#FFFFFF",
          "hideBulletsCount": 50,
          "title": "red line",
          // "valueField": "visits",
          "valueField": "nps",
          // "useLineColorForBulletBorder": true,
          "type": "smoothedLine",
          "lineColor": "#27AE60",
          "negativeLineColor": "#C0392B",
          // "negativeFillColors": "#C0392B",
      }],
      "chartScrollbar": {
          "autoGridCount": true,
          "graph": "g1",
          "scrollbarHeight": 40,
          // "hideResizeGrips": true,
          "dragIcon": 'dragIconRoundSmall',
          'dragIconHeight': 25,
          'dragIconWidth': 25,
          'graphFillAlpha': 0.3,
          'selectedGraphFillAlpha': 0.2
      },
      "chartCursor": {

      },
      "dataDateFormat": 'YYYYMMDD',
      // "categoryField": "date",
      "categoryField": "date_yyyymmdd",
      "categoryAxis": {
          "parseDates": true,
          "axisColor": "#DADADA",
          "dashLength": 1,
          "minorGridEnabled": true
      },
      "export": {
          "enabled": true
      }
  });

  // chart.addListener("rendered", zoomChart);
  // zoomChart();

  // // this method is called when chart is first inited as we listen for "rendered" event
  // function zoomChart() {
  //     // different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
  //     chart.zoomToIndexes(chartData.length - 40, chartData.length - 1);
  // }


  // // generate some random data, quite different range
  // function generateChartData() {
  //     var chartData = [];
  //     var firstDate = new Date();
  //     firstDate.setDate(firstDate.getDate() - 5);

  //     for (var i = 0; i < 1000; i++) {
  //         // we create date objects here. In your data, you can have date strings
  //         // and then set format of your dates using chart.dataDateFormat property,
  //         // however when possible, use date objects, as this will speed up chart rendering.
  //         var newDate = new Date(firstDate);
  //         newDate.setDate(newDate.getDate() + i);

  //         var visits = Math.round(Math.random() * (40 + i / 5)) + 20 + i;

  //         chartData.push({
  //             date: newDate,
  //             visits: visits
  //         });
  //     }
  //     return chartData;
  // }

  $('.checkbox').on('click', function() {
    var thisEl = $(this);
    var checkbox = thisEl.find("input[type='checkbox']");
    var field = checkbox.attr('name');
    var value = checkbox.attr('value');
    var checked = checkbox.prop('checked');
    if (checked) {
      window.location.href = URI(window.location.href).addSearch(field, value);
    } else {
      window.location.href = URI(window.location.href).removeSearch(field, value);
    }
  });
});
