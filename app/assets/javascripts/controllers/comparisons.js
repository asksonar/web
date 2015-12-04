$(function(){
  if ($('#comparisons-index').length === 0) {
    return;
  }

  var comparisonField = 'region';
  var chartData = nps_by_category;
  var chart = AmCharts.makeChart("chart", {
    "addClassNames": true,
    "type": "serial",
    "theme": "light",
    "marginRight": 70,
    "dataProvider": chartData,
    "chartCursor": {
      "categoryBalloonEnabled": false,
      "cursorAlpha": 0,
      "zoomable": false
    },
    "valueAxes": [{
      "axisAlpha": 0.2,
      "dashLength": 1,
      "position": "left",
      "minimum": -100,
      "maximum": 100
    }],
    "startDuration": 1,
    "graphs": [{
      "id": "g1",
      "balloonText": "[[category]]<br/><b><span style='font-size:14px;'>NPS: [[value]]</span></b>",
      // "fillColorsField": "color",
      "fillAlphas": 0.9,
      "lineAlpha": 0.2,
      "type": "column",
      "valueField": "nps",
      "lineColor": "#27AE60",
      "negativeLineColor": "#C0392B",
      "negativeFillColors": "#C0392B"
    }],
    "chartCursor": {
      "categoryBalloonEnabled": false,
      "cursorAlpha": 0,
      "zoomable": false
    },
    "categoryField": comparisonField,
    "categoryAxis": {
      "gridPosition": "start",
      "labelRotation": 45
    },
    "export": {
      "enabled": true
    }
  });

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
