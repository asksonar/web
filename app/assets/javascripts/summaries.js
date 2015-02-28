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

    //var histogram = new Histogram(times);
    //times = histogram.distributeData();

    /*
    times = [
      { "time" : 10, "scenario_step_result_id" : 13 },
      { "time" : 15, "scenario_step_result_id" : 15 },
      { "time" : 30, "scenario_step_result_id" : 18 },
      { "time" : 30, "scenario_step_result_id" : 17 },
      { "time" : 35, "scenario_step_result_id" : 20 },
      { "time" : 65, "scenario_step_result_id" : 25 },
      { "time" : 90, "scenario_step_result_id" : 22 },
      { "time" : 200, "scenario_step_result_id" : 30 }
    ];

    times = [
      { "time" : "00:30", "user1": 1},
      { "time" : "01:00", "user1": 1},
      { "time" : "01:30", "user1": 3},
      { "time" : "02:00", "user1": 1},
      { "time" : "02:30", "user1": 2},
      { "time" : "03:00"},
      { "time" : "03:00+"}
    ]
    */

    var chart = AmCharts.makeChart(graph.attr('id'), {
      "type": "serial",
      "theme": "light",
      "creditsPosition": "top-right",
      "hideBalloonTime": 0,

      "categoryField": "time",

      "graphs": [{
        "fillAlphas": .3,
        "type": "column",
        "valueField": "user1",
        "showHandOnHover": true,
        "columnWidth": 1
      }, {
        "fillAlphas": .3,
        "type": "column",
        "valueField": "user2",
        "showHandOnHover": true,
        "columnWidth": 1
      }, {
        "fillAlphas": .3,
        "type": "column",
        "valueField": "user3",
        "showHandOnHover": true,
        "columnWidth": 1
      }],
      /*
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
      */
      "dataProvider": times
    });

    //chart.categoryAxis.labelsEnabled = false;
    //chart.categoryAxis.gridThickness = 0;

    chart.addListener('clickGraphItem', function(event) {
      var scenarioStepResultId = event.item.dataContext['id'];
      alert(scenarioStepResultId);
    });
  });

  $('.feeling').click(function(){
    debugger;
    var thisEl = $(this);
    var stepId = thisEl.attr('data-scenario-step-id');
    var timeSeconds = thisEl.attr('data-feeling-at-seconds');

    var videoContainer = $('#summary_video_container');
    videoContainer.modal();

    var video = videojs('example_video_1');
    video.src([
      { type: "video/mp4", src: "http://video-js.zencoder.com/oceans-clip.mp4" },
      { type: "video/webm", src: "http://video-js.zencoder.com/oceans-clip.webm" },
      { type: "video/ogg", src: "http://video-js.zencoder.com/oceans-clip.ogv" }
    ]);
    video.currentTime(timeSeconds);
    // remove the big play button
    $('#example_video_1').addClass('vjs-has-started');
  });

});
