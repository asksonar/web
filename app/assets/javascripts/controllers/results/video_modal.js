function VideoModal(config, video) {
  this.$modal = config.modal;
  this.$videoText = config.divVideoText;
  this.$inputUrlBase = config.inputUrlBase;
  this.$inputUrlTime = config.inputUrlTime;
  this.$divUserEmail = config.divUserEmail;
  this.$divStepOrder = config.divStepOrder;
  this.$divStepDescription = config.divStepDescription;
  this.$btnCopyVideoLink = config.btnCopyVideoLink;

  this.video = video;

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.playVideo, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.pauseVideo, this));
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));

  this.video.on('timeupdate', $.proxy(this.updateVideoTime, this));

  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);
}

VideoModal.prototype.load = function(scenarioStepId, scenarioResultId, timeSeconds) {
  $.ajax({
    url:"/videos.json",
    data: {
      scenario_step_id: scenarioStepId,
      scenario_result_id: scenarioResultId,
    },
    dataType: 'json'
  }).done($.proxy(function(data){

    if (this.$modal.attr('data-video-id') != data.id) {
      this.$modal.attr('data-video-id', data.id);

      this.video.markers(data.delighted_array, data.confused_array, data.highlighted_array);
      this.video.src(data.src_array);

      this.$videoText.html(this.buildTranscript(data.transcription_array));
      this.$divUserEmail.html(data.user_email);
      this.$divStepOrder.html(data.step_order + 1);
      this.$divStepDescription.html(data.step_description);
      this.$inputUrlBase.attr('data-base-url', data.share_link + '?t=');
    }

    this.video.currentTime(timeSeconds);
    this.show();

  }, this)).fail($.proxy(function(jqXHR, textStatus, errorThrown){
    notify.warn(jqXHR.responseText);
  }, this));
}

VideoModal.prototype.buildTranscript = function(transcriptArray) {
  var videoTranscript = "";
  var time, mins, secs, text;
  for(var i = 0; i  < transcriptArray.length; i++) {
    time = transcriptArray[i].offset
    text = transcriptArray[i].text.trim();

    mins = Math.floor(time / 60);
    secs = time % 60;

    videoTranscript += "<a class='videoTextLink' data-timestamp='" + time + "'>"
      + mins + ":" + ('00' + secs).slice(-2) + " "
      + text + "</a><br/>";
  }

  if (videoTranscript) {
    return videoTranscript;
  } else {
    return "(no transcription)";
  }
}

VideoModal.prototype.show = function() {
  this.$modal.modal('show');
}

VideoModal.prototype.pauseVideo = function() {
  this.video.pause();
}

VideoModal.prototype.playVideo = function(timestamp) {
  this.video.play(timestamp);
}

VideoModal.prototype.clickVideoText = function(event) {
  var timestamp = $(event.currentTarget).attr('data-timestamp');
  this.playVideo(timestamp);
}

VideoModal.prototype.updateVideoTime = function(event, timestamp) {

  var currentSeconds = parseInt(timestamp);

  var displayTime = Math.floor(currentSeconds / 60) + ':' + ('00' + currentSeconds % 60).slice(-2);
  this.$inputUrlTime.val(displayTime);

  var displayUrl = this.$inputUrlBase.attr('data-base-url') + currentSeconds;
  this.$inputUrlBase.val(displayUrl);

  var videoTextLinks = this.$videoText.find('.videoTextLink').removeClass('activeVideoTextLink');
  var videoTextLink;
  for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
    videoTextLink = $(videoTextLinks[i]);
    if (videoTextLink.attr('data-timestamp') <= timestamp) {
      videoTextLink.addClass('activeVideoTextLink');
      break;
    }
  }

}
