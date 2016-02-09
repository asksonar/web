$(function() {
  if ($('#comparisons-index').length === 0) {
    return;
  }

  var chartData = npsByCategory;
  var chart = AmCharts.makeChart('chart', {
    'addClassNames': true,
    'type': 'serial',
    'theme': 'light',
    'marginRight': 70,
    'dataProvider': chartData,
    'chartCursor': {
      'categoryBalloonEnabled': false,
      'cursorAlpha': 0,
      'zoomable': false
    },
    'valueAxes': [{
      'id': 'npsAxis',
      'axisAlpha': 0.2,
      'dashLength': 1,
      'position': 'left',
      'minimum': -100,
      'maximum': 100
    }, {
      'id': 'splitAxis',
      'stackType': '100%',
      'gridAlpha': 0.07,
      'position': 'left',
      'unit': '%',
      'labelsEnabled': false,
      'tickLength': 0
    }],
    'startDuration': 1,
    'graphs': [{
      'id': 'trend',
      'balloonText': "[[category]]<br/><b><span style='font-size:14px;'>NPS: [[value]]</span></b>",
      // 'fillColorsField': 'color',
      'fillAlphas': 0.9,
      'lineAlpha': 0.2,
      'type': 'column',
      'valueField': 'nps',
      'lineColor': '#27AE60',
      'negativeLineColor': '#C0392B',
      'negativeFillColors': '#C0392B',
      'clustered': false
    }, {
      'id': 'detractors',
      'balloonText': "Detractors: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
      'fillAlphas': 0.5,
      'lineAlpha': 0.5,
      'title': 'Detractors',
      'valueField': '-1',
      'lineColor': '#C0392B',
      'valueAxis': 'splitAxis',
      'type': 'column',
      'hidden': true,
      'clustered': false
    }, {
      'id': 'passives',
      'balloonText': "Passives: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
      'fillAlphas': 0.5,
      'lineAlpha': 0.5,
      'title': 'Passives',
      'valueField': '0',
      'lineColor': '#F1C40F',
      'valueAxis': 'splitAxis',
      'type': 'column',
      'hidden': true,
      'clustered': false
    }, {
      'id': 'promoters',
      'balloonText': "Promoters: <span style='font-size:14px; color:#000000;'><b>[[value]]</b> ([[percents]]%)</span>",
      'fillAlphas': 0.5,
      'lineAlpha': 0.5,
      'title': 'Promoters',
      'valueField': '1',
      'lineColor': '#27AE60',
      'valueAxis': 'splitAxis',
      'type': 'column',
      'hidden': true,
      'clustered': false
    }],
    'categoryField': 'categoryField',
    'categoryAxis': {
      'gridPosition': 'start',
      'labelRotation': 45
    },
    'export': {
      'enabled': true
    }
  });

  var graphFilters = new GraphFilters({
    inputCheckbox: $(".filter input[type='checkbox']"),
    btnSelect: $('.selectpicker')
  }, chart);

  $('#toggle-breakdown').bootstrapSwitch({
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
