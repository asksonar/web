function VideoModal(config, video) {
  this.$modal = config.modal;
  this.$videoText = config.divVideoText;
  this.$inputUrlBase = config.inputUrlBase;
  this.$inputUrlTime = config.inputUrlTime;
  this.$divUserEmail = config.divUserEmail;
  this.$divStepOrder = config.divStepOrder;
  this.$divStepDescription = config.divStepDescription;
  this.$btnCopyVideoLink = config.btnCopyVideoLink;
  this.$btnHighlightVideoLink = config.btnHighlightVideoLink;

  this.video = video;

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.playVideo, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.pauseVideo, this));
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));

  this.video.on('timeupdate', $.proxy(this.updateVideoTime, this));

  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);
}

VideoModal.prototype.load = function(resultStepHashId, timeSeconds) {

  $.ajax({
    url:"/videos.json",
    data: {
      result_step_hashid: resultStepHashId
    },
    dataType: 'json'
  }).done($.proxy(function(data){
    if (this.resultStepHashId != data.result_step_hashid) {
      this.resultStepHashId = data.result_step_hashid;

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
    secs = Math.floor(time) % 60;

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
  var inputUrlBaseDom = this.$inputUrlBase.get(0);
  var selectionStart = inputUrlBaseDom.selectionStart;
  var selectionEnd = inputUrlBaseDom.selectionEnd;
  var selectionAll = inputUrlBaseDom.value.length > 0 && selectionEnd - selectionStart == inputUrlBaseDom.value.length;
  this.$inputUrlBase.val(displayUrl);
  if (selectionAll) {
    inputUrlBaseDom.setSelectionRange(0, inputUrlBaseDom.value.length);
  } else {
    inputUrlBaseDom.setSelectionRange(selectionStart, selectionEnd);
  }

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

VideoModal.prototype.generateHighlight = function() {
  var offsetSeconds = this.video.currentTime();

  $.ajax({
    type: "POST",
    url: "/highlights",
    data: {
      result_step_hashid: this.resultStepHashId,
      offset_seconds: offsetSeconds,
      authenticity_token: AUTH_TOKEN
    },
    dataType: 'json'
  }).done($.proxy(function(data){

    // draw the highlights
    this.video.markers(data.delighted_array, data.confused_array, data.highlighted_array);
    // normally triggered by calling this.video.src
    this.video.loadMarkers();

    notify.info('Your highlight has been added.');

  }, this)).fail($.proxy(function(jqXHR, textStatus, errorThrown){
    notify.error(jqXHR.responseText, 'There was an error saving your Highlight.');
  }, this));
}
