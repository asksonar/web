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
      "hideBalloonTime": 4000,
      "categoryField": "display",
      "graphs": [{
        "fillAlphas": .3,
        "type": "column",
        "valueField": "count",
        "showHandOnHover": true,
        "columnWidth": 1,
        "balloonFunction": function(graphDataItem, graph) {
          var details = graphDataItem.dataContext.details;
          var display = '';
          var time = 0;
          var mins, seconds;
          for(var i = 0; i < details.length; i++) {
            time = details[i].time;
            mins = Math.floor(time / 60);
            seconds = time % 60;

            display += "<a href='#' class='linkVideo feeling' data-scenario-step-id='" + details[i].id + "'>" + mins + ":" + ('00' + seconds).slice(-2) + "</a><br/>";
          }
          return display;
        }
      }],
      "balloon": {
        "fixedPosition": true
      },
      "dataProvider": times
    });

    chart.addListener('clickGraphItem', function(event) {
      var details = event.item.dataContext['details'];
    });

  });

  $('.summary_step_container').on('click', '.feeling', function(event){
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
    if (timeSeconds) {
      video.currentTime(timeSeconds);
    }
    // remove the big play button
    //$('#example_video_1').addClass('vjs-has-started');
    return false;
  });

});
