$(function(){
  if ($('#dashboard-index').length === 0) {
    return;
  }

  var chartData = nps_2_weeks_split;

  var chart = AmCharts.makeChart("chart", {
    "type": "serial",
    "theme": "light",
    "legend": {
        "align": "center",
        "equalWidths": false,
        "periodValueText": "[[value.sum]]",
        "valueAlign": "left",
        "valueText": "[[value]] ([[percents]]%)",
        'reversedOrder': true
    },
    "dataProvider": chartData,
    "valueAxes": [{
        "stackType": "100%",
        "gridAlpha": 0.07,
        "position": "left",
        'unit': '%',
        'labelsEnabled': false,
        'tickLength': 0
    }],
    "graphs": [{
        "balloonText": "Detractors: <span style='font-size:14px; color:#000000;'><b>[[value]]</b></span>",
        "fillAlphas": 0.5,
        "lineAlpha": 0.5,
        "title": "Detractors",
        "valueField": "-1",
        'lineColor': '#C0392B'
    }, {
        "balloonText": "Passives: <span style='font-size:14px; color:#000000;'><b>[[value]]</b></span>",
        "fillAlphas": 0.5,
        "lineAlpha": 0.5,
        "title": "Passives",
        "valueField": "0",
        'lineColor': '#F1C40F'
    }, {
        "balloonText": "Promoters: <span style='font-size:14px; color:#000000;'><b>[[value]]</b></span>",
        "fillAlphas": 0.5,
        "lineAlpha": 0.5,
        "title": "Promoters",
        "valueField": "1",
        'lineColor': '#27AE60'
    }],
    "plotAreaBorderAlpha": 0,
    // "marginLeft": 0,
    // "marginBottom": 0,
    'autoMarginOffset': 20,
    "chartCursor": {
        "cursorAlpha": 0,
        "zoomable": false
    },
    "dataDateFormat": 'YYYYMMDD',
    "categoryField": "date_yyyymmdd",
    "categoryAxis": {
        "parseDates": true,
        "startOnAxis": true,
        "axisColor": "#DADADA",
        "gridAlpha": 0.07,
        "equalSpacing": true, // needed for startOnAxis to be set to true
        // "gridCount": 3,
        // "autoGridCount": false,
        "markPeriodChange": false,
        'showFirstLabel': true,
        'showLastLabel': true
    },
    "export": {
      "enabled": true
     }
  });

});
