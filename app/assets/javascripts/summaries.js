/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/
$(function(){

  $('.summary_time_graph').each(function(){
    var thisEl = $(this);
    var times = JSON.parse(thisEl.find('script').html());
    var graph = thisEl.find('.graph');

    var chart = AmCharts.makeChart(graph.attr('id'), {
      "type": "serial",
      "theme": "light",
      "creditsPosition": "top-right",
      "hideBalloonTime": 0,
      "valueAxes": [{
        "duration": "ss",
        "durationUnits": {
          "hh": ":",
          "mm": ":",
          "ss": ""
        },
        //"maximum": maximum, // will be needed to cap extremes
        "minVerticalGap": 25
      }],
      "graphs" : [{
        "valueField" : "time",
        "type" : "column",
        "fillAlphas" : .3,
        "showHandOnHover": true,
        "columnWidth": 1
      }],
      "dataProvider": times
      /*
      [
        //{ "time" : 10, "scenario_step_result_id" : 17 },
        //{ "time" : 15, "scenario_step_result_id" : 16 },
        { "time" : 30, "scenario_step_result_id" : 18 },
        { "time" : 30, "scenario_step_result_id" : 19 },
        { "time" : 35, "scenario_step_result_id" : 20 },
        { "time" : 65, "scenario_step_result_id" : 25 },
        { "time" : 90, "scenario_step_result_id" : 22 },
        { "time" : 200, "scenario_step_result_id" : 30 }
      ]
      */
    });

    chart.categoryAxis.labelsEnabled = false;
    chart.categoryAxis.gridThickness = 0;

    chart.addListener('clickGraphItem', function(event) {
      var scenarioStepResultId = event.item.dataContext['id'];
    });
  });

});
