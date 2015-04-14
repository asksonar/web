/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){

  if (!$('#main-results-show')) {
    return;
  }

  $('#input-share-link').val(window.location.origin + $('#input-share-link').val());


  new ZeroClipboard(document.getElementById("btn-copy-share-link")).on("copy", function(event) {
    event.clipboardData.setData( "text/plain", $('#input-share-link').val());
  });
  new ZeroClipboard(document.getElementById("btn-copy-video-link")).on( "copy", function (event) {
    event.clipboardData.setData( "text/plain", $('#input-url-base').val() + $('#input-url-time').val());
  });

  $('.main-content-header').on('click', '#btn-archive', function() {
    $(this).find('.btn').toggleClass('active');
  });

  $('.main-content-header').on('click', '#input-share-link', function() {
    this.setSelectionRange(0, this.value.length);
  });

  $('#btn-archive, #btn-copy-share-link, #btn-preview').tooltip()

  $('.main-content').on('click', '.fa-chevron-down', function(){
    $(this).removeClass('fa-chevron-down').addClass('fa-chevron-up');
    $(this).closest('.panel').find('.panel-body').slideDown(400, function(){
      setupGraph($(this).find('.summary_time_graph'));
    });
  });

  $('.main-content').on('click', '.fa-chevron-up', function(){
    $(this).removeClass('fa-chevron-up').addClass('fa-chevron-down');
    $(this).closest('.panel').find('.panel-body').slideUp();
  });

  $('.fa-chevron-down').click();

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
      "backgroundColor": '#FAFAFA',
      "backgroundAlpha": 1,
      "graphs": [{
        "fillAlphas": 1,
        "lineAlphas": 0,
        "type": "column",
        "valueField": "count",
        "columnWidth": .75,
        "showBalloon": false
      }],
      categoryAxis: {
        "title": "time",
        "titleBold": false,
        "gridAlpha": 0,
        "tickLength": 0,
        "gridCount": 0,
        "autoGridCount": false
      },
      /*
      "categoryAxis": [{
        "title": input.val(),
        "titleBold": false
      }],
      */
      "valueAxes": [{
        "title": "users",
        "titleBold": false,
        "gridAlpha": 0,
        "tickLength": 0,
        "gridCount": 0,
        "autoGridCount": false,
        "showFirstLabel": false,
        "showLastLabel": false
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

  $('.main-content').on('click', '.feeling', function(event){
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
      var time, mins, secs, text;

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

        for(var i = 0; i  < data.transcription_array.length; i++) {
          time = data.transcription_array[i].offset
          text = data.transcription_array[i].text.trim();

          mins = Math.floor(time / 60);
          secs = time % 60;

          videoTranscript += "<a class='videoTextLink' data-timestamp='" + time + "'>"
            + mins + ":" + ('00' + secs).slice(-2) + " "
            + text + "</a><br/>";
        }

        $('#videoText').html(videoTranscript);

        //var modalTitle = '[' + data.user_email + '] - ' + (data.step_order + 1) + ') ' + data.step_description;
        //$('.modal-title').html(modalTitle);
        $('#ctn-user-email').html(data.user_email);
        $('#ctn-step-order').html(data.step_order + 1);
        $('#ctn-step-description').html(data.step_description);
        $('#input-url-base').val(window.location.origin + data.share_link + '?t=');
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
