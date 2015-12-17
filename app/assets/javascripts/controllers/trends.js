$(function(){
  if ($('#trends-index').length === 0) {
    return;
  }

  // var chartData = generateChartData();
  var chartData = nps_by_day_json; // need to be sort chronologically to begin with
  var chart = AmCharts.makeChart("chart", {
      "pathToImages": "assets/amcharts3/amcharts/images/",
      "addClassNames": true,
      "type": "serial",
      "theme": "light",
      // "marginRight": 80,
      "autoMarginOffset": 20,
      // "marginTop": 7,
      "dataProvider": chartData,
      "valueAxes": [{
        "id": 'npsAxis',
        "axisAlpha": 0.2,
        "dashLength": 1,
        "position": "left",
        "minimum": -100,
        "maximum": 100
      }, {
        'id': 'splitAxis',
        "stackType": "100%",
        "gridAlpha": 0.07,
        "position": "left",
        'unit': '%',
        'labelsEnabled': false,
        'tickLength': 0
      }],
      "mouseWheelZoomEnabled": true,
      "graphs": [{
          "id": "trend",
          "balloonText": "[[category]]<br/><b><span style='font-size:14px;'>NPS: [[value]]</span></b>",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          // "bulletColor": "#FFFFFF",
          "hideBulletsCount": 50,
          "title": "red line",
          // "valueField": "visits",
          "valueField": "nps",
          'valueAxis': 'npsAxis',
          // "useLineColorForBulletBorder": true,
          "type": "smoothedLine",
          "lineColor": "#27AE60",
          "negativeLineColor": "#C0392B",
          // "negativeFillColors": "#C0392B",
      }, {
        "id": "detractors",
        "balloonText": "Detractors: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
        "fillAlphas": 0.5,
        "lineAlpha": 0.5,
        "title": "Detractors",
        "valueField": "-1",
        'lineColor': '#C0392B',
        'valueAxis': 'splitAxis',
        'hidden': true
      }, {
        "id": "passives",
          "balloonText": "Passives: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
          "fillAlphas": 0.5,
          "lineAlpha": 0.5,
          "title": "Passives",
          "valueField": "0",
          'lineColor': '#F1C40F',
          'valueAxis': 'splitAxis',
          'hidden': true
      }, {
        "id": "promoters",
          "balloonText": "Promoters: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
          "fillAlphas": 0.5,
          "lineAlpha": 0.5,
          "title": "Promoters",
          "valueField": "1",
          'lineColor': '#27AE60',
          'valueAxis': 'splitAxis',
          'hidden': true
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
      "categoryField": "categoryField",
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

  var graphFilters = new GraphFilters({
    inputCheckbox: $('.checkbox input[type="checkbox"]'),
    btnSelect: $('.selectpicker')
  }, chart);

  $("#toggle-breakdown").bootstrapSwitch({
    labelText: 'Show breakdown',
    labelWidth: 150,
    handleWidth: 50,
    animate: false,
    onSwitchChange: function(event, checked) {
      if (checked) {
        chart.hideGraph(chart.getGraphById('trend'));
        chart.showGraph(chart.getGraphById('promoters'));
        chart.showGraph(chart.getGraphById('passives'));
        chart.showGraph(chart.getGraphById('detractors'));
      } else {
        chart.showGraph(chart.getGraphById('trend'));
        chart.hideGraph(chart.getGraphById('promoters'));
        chart.hideGraph(chart.getGraphById('passives'));
        chart.hideGraph(chart.getGraphById('detractors'));
      }
    }
  });
});
