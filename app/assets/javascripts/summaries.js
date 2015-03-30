/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){

  new ZeroClipboard(document.getElementById("btn-copy-share-link"));
  new ZeroClipboard(document.getElementById("btn-copy-video-link")).on( "copy", function (event) {
    event.clipboardData.setData( "text/plain", $('#input-url-base').val() + $('#input-url-time').val());
  });


  $('.summary_steps').on('click', '.fa-chevron-down', function(){
    $(this).removeClass('fa-chevron-down').addClass('fa-chevron-up');
    $(this).closest('.panel').find('.panel-body').slideDown(400, function(){
      setupGraph($(this).find('.summary_time_graph'));
    });
  });

  $('.summary_steps').on('click', '.fa-chevron-up', function(){
    $(this).removeClass('fa-chevron-up').addClass('fa-chevron-down');
    $(this).closest('.panel').find('.panel-body').slideUp();
  });

  $('.fa-chevron-down').first().click();

  var setupGraph = function(thisEl){
    var times = JSON.parse(thisEl.find('script').html());
    var graph = thisEl.find('.graph');

    var chart = AmCharts.makeChart(graph.attr('id'), {
      "type": "serial",
      "theme": "light",
      "creditsPosition": "top-right",
      "hideBalloonTime": 2000,
      "categoryField": "display",
      "gridAboveGraphs": true,
      "graphs": [{
        "fillAlphas": .8,
        "lineAlphas": .2,
        "type": "column",
        "valueField": "count",
        "showHandOnHover": true,
        "columnWidth": .75,
        "balloonFunction": function(graphDataItem, graph) {
          var details = graphDataItem.dataContext.details;
          var display = '';
          var time = 0;
          var mins, secs;
          for(var i = 0; i < details.length; i++) {
            time = details[i].time;
            mins = Math.floor(time / 60);
            secs = time % 60;

            display += "<a class='linkVideo feeling' \
            data-scenario-step-id='" + details[i].step_id + "' \
            data-user-id='" + details[i].user_id + "' \
            >" + mins + ":" + ('00' + secs).slice(-2) + "</a><br/>";
          }
          return display;
        }
      }],
      categoryAxis: {
        "gridPosition": "start",
        "tickPosition": "start",
        "gridAlpha": 0
      },
      /*
      "categoryAxis": [{
        "title": input.val(),
        "titleBold": false
      }],
      */
      "valueAxes": [{
        "minVerticalGap": 30,
        "title": "Users",
        "titleBold": false,
        "gridColor":"#FFFFFF",
        "gridAlpha": 0.2,
        "dashLength": 0
      }],
      "balloon": {
        "fixedPosition": true
      },
      "dataProvider": times
    });

    chart.addListener('clickGraphItem', function(event) {
      var details = event.item.dataContext['details'];
    });
  };

  $('.summary_steps').on('click', '.feeling', function(event){
    var thisEl = $(this);
    var stepId = thisEl.attr('data-scenario-step-id');
    var userId = thisEl.attr('data-user-id');
    var timeSeconds = thisEl.attr('data-feeling-at-seconds') || 0;

    //stepId = 976353875;
    //userId = 1023569919;

    $.ajax({
      url:"/videos.json",
      data: {
        scenario_step_id: stepId,
        user_id: userId
      },
      dataType: 'json'
    }).done(function(data){
      var video = videojs('example_video_1');
      var videoEl = $('#example_video_1');
      var videoJSON;
      var videoTranscript = "";
      var time, mins, secs;

      if (videoEl.attr('data-video-id') !== data.id) {
        videoEl.attr('data-video-id', data.id);

        video.src([{ type: "video/mp4", src: "http://vjs.zencdn.net/v/oceans.mp4" }]);
        /*
        video.src([
          { type: "video/mp4", src: "/videos/video_" + data.id + ".mp4" },
          { type: "video/webm", src: "/videos/video_" + data.id + ".webm" },
          { type: "video/ogg", src: "/videos/video_" + data.id + ".ogv" }
        ]);
        */

        videoJSON = JSON.parse(data.transcription_json);
        for(var time in videoJSON) {
          mins = Math.floor(time / 60);
          secs = time % 60;

          videoTranscript += "<a class='videoTextLink' data-timestamp='" + time + "'>"
            + mins + ":" + ('00' + secs).slice(-2) + " "
            + videoJSON[time] + "</a><br/>";
        }

        $('#videoText').html(videoTranscript);

        var modalTitle = '[' + data.user_email + '] - ' + (data.step_order + 1) + ') ' + data.step_description;
        $('.modal-title').html(modalTitle);

        $('#input-url-base').val(data.share_link + '?t=');
      }

      video.currentTime(timeSeconds);

      $('#summary_video_container').modal('show');
    });
  });

  $('#summary_video_container').on('shown.bs.modal', function(){
    var video = videojs('example_video_1');
    video.userActive(true);
    video.play();
  });

  $('#summary_video_container').on('hide.bs.modal', function(){
    var video = videojs('example_video_1');
    video.pause();
  });

  $('.linkFeelingOverflow').click(function(){
    $(this).parents('.feelingDivContainer').find('.feelingOverflow').show();
    $(this).hide();
  });

  if (document.getElementById('example_video_1')) {
    videojs('example_video_1').ready(function(){
      this.on('timeupdate', function(){
        var currentTime = this.currentTime();
        $('#input-url-time').val(parseInt(currentTime));
        //console.log(currentTime);
        var videoTextLinks = $('#videoText .videoTextLink').removeClass('activeVideoTextLink');
        var videoTextLink;
        for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
          videoTextLink = $(videoTextLinks[i]);
          if (videoTextLink.attr('data-timestamp') <= currentTime) {
            videoTextLink.addClass('activeVideoTextLink');
            break;
          }
        }
      });
    });
  }

  $('#videoText').on('click', '.videoTextLink', function() {
    var video = videojs('example_video_1');
    video.currentTime($(this).attr('data-timestamp'));
    video.userActive(true);
    video.play();
  });
});
