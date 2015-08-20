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

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html())

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
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
  }).done($.proxy(this.loaded, this, timeSeconds
  )).fail($.proxy(function(jqXHR, textStatus, errorThrown) {
    notify.warn(jqXHR.responseText);
  }, this));
}

// timeSeconds comes first because $.proxy inserts it first
VideoModal.prototype.loaded = function(timeSeconds, data) {
  if (this.resultStepHashId != data.result_step_hashid) {
    this.resultStepHashId = data.result_step_hashid;

    this.video.markers(data.delighted_array, data.confused_array, data.highlighted_array);
    this.video.src(data.src_array);

    this.$videoText.html(this.buildTranscript(
      data.transcription_array,
      data.delighted_array,
      data.confused_array
    ));
    this.$divUserEmail.html(data.user_email);
    this.$divStepOrder.html(data.step_order + 1);
    this.$divStepDescription.html(data.step_description);
    this.$inputUrlBase.attr('data-base-url', data.share_link + '?t=');
  }

  this.video.currentTime(timeSeconds);
  this.show();
}

VideoModal.prototype.buildTranscript = function(transcriptArray, delightedArray, confusedArray) {

  var delightedIndex = 0, confusedIndex = 0;
  var renderArray = [];
  var videoTranscript;
  var time, mins, secs, text;
  var hasDelighted, hasConfused, nextTime;
  for(var i = 0; i  < transcriptArray.length; i++) {
    time = transcriptArray[i].offset_seconds;
    text = transcriptArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    hasDelighted = false;
    hasConfused = false;
    if ((i + 1) < transcriptArray.length) {
      nextTime = transcriptArray[i+1].offset_seconds;

      while(delightedArray && delightedArray[delightedIndex] < nextTime) {
        hasDelighted = true;
        delightedIndex += 1;
      }
      while(confusedArray && confusedArray[confusedIndex] < nextTime) {
        hasConfused = true;
        confusedIndex += 1;
      }
    } else {
      if (delightedArray && delightedIndex < delightedArray.length) {
        hasDelighted = true;
      }
      if (confusedArray && confusedIndex < confusedArray.length) {
        hasConfused = true;
      }
    }

    mins = Math.floor(time / 60);
    secs = Math.floor(time) % 60;

    renderArray.push({
      time: time,
      displayTime: mins + ":" + ('00' + secs).slice(-2),
      displayText: text,
      hasDelighted: hasDelighted,
      hasConfused: hasConfused
    });
  }

  videoTranscript = this.videoTextTemplate({
    rows: renderArray
  });

  if (videoTranscript.trim()) {
    return videoTranscript;
  } else {
    return "(no transcription)";
  }
}

VideoModal.prototype.show = function() {
  this.$modal.modal('show');
}

VideoModal.prototype.shown = function() {
  this.playVideo();
  if (location.href.indexOf('videos') < 0) {
    var newUrl = URI(location.href).segment('videos').segment(this.resultStepHashId);
    history.replaceState({}, '', newUrl);
  }
}

VideoModal.prototype.hidden = function() {
  this.pauseVideo();
  var newUrl = '/' + URI(location.href).segment(0) + '/' + URI(location.href).segment(1);
  history.replaceState({}, '', newUrl);
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

  if (location.href.indexOf('videos') >= 0) {
    var newUrl = URI(location.href).search({t:currentSeconds});
    history.replaceState({}, '', newUrl);
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
