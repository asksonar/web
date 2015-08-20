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
  this.$btnToggleTranscripts = config.btnToggleTranscripts;
  this.$btnToggleNotes = config.btnToggleNotes;
  this.$divVideoContainer = config.divVideoContainer;
  this.$divTranscriptContainer = config.divTranscriptContainer;

  this.video = video;

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html())

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleViewMode, this));
  this.$btnToggleNotes.on('click', $.proxy(this.toggleViewMode, this));

  this.video.on('timeupdate', $.proxy(this.updateVideoTime, this));

  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);
}

VideoModal.prototype.toggleViewMode = function(event) {
  $(event.currentTarget).toggleClass('active');

  var activeTranscripts = this.$btnToggleTranscripts.hasClass('active');
  var activeNotes = this.$btnToggleNotes.hasClass('active');

  if (activeTranscripts || activeNotes) {
    this.$divVideoContainer.addClass('col-md-6').removeClass('col-md-10');
    this.$divTranscriptContainer.addClass('col-md-6').removeClass('col-md-2');

    if (activeTranscripts) {
      this.$videoText.removeClass('hide-transcripts');
    } else {
      this.$videoText.addClass('hide-transcripts');
    }

    if (activeNotes) {
      this.$videoText.removeClass('hide-notes');
    } else {
      this.$videoText.addClass('hide-notes');
    }

    this.$videoText.removeClass('icon-mode').addClass('text-mode');

  } else {
    this.$divVideoContainer.addClass('col-md-10').removeClass('col-md-6');
    this.$divTranscriptContainer.addClass('col-md-2').removeClass('col-md-6');
    this.$videoText.addClass('icon-mode').removeClass('text-mode');
    this.$videoText.removeClass('hide-transcripts');
    this.$videoText.addClass('hide-notes');
  }

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
    autosize($('textarea'));
    $('.video-btn-edit').on('click', function() {
      var parent = $(this).closest('.ctnVideoTextLink');
      parent.addClass('active');

      var inputTime = parent.find('.video-text-time');
      var inputText = parent.find('.video-text-display');

      inputTime.prop('readonly', false);
      inputText.prop('readonly', false);

      var originalTimeVal = inputTime.val();
      var originalTextVal = inputText.val();

      parent.find('.video-btn-cancel').off('click').on('click', function() {
        parent.removeClass('active');
        inputTime.val(originalTimeVal);
        inputText.val(originalTextVal);
        inputTime.prop('readonly', true);
        inputText.prop('readonly', true);
      });

      parent.find('.video-btn-save').off('click').on('click', function(){
        alert('saved');
        parent.removeClass('active');
        inputTime.prop('readonly', true);
        inputText.prop('readonly', true);
      });

    });

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

  for(var i = 0; delightedArray && i  < delightedArray.length; i++) {
    renderArray.push({
      time: delightedArray[i],
      displayClass: 'feeling-delighted',
      displayIcon: 'feeling-delighted',
      displayText: "<i class='feeling-delighted'></i>"
    })
  }

  for(var i = 0; confusedArray && i  < confusedArray.length; i++) {
    renderArray.push({
      time: confusedArray[i],
      displayClass: 'feeling-confused',
      displayIcon: 'feeling-confused',
      displayText: "<i class='feeling-confused'></i>"
    })
  }

  for(var i = 0; i  < transcriptArray.length; i++) {
    time = transcriptArray[i].offset_seconds;
    text = transcriptArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    renderArray.push({
      time: time,
      displayClass: 'transcript',
      displayIcon: 'fa fa-align-left',
      displayText: text,
    });
  }

  renderArray.sort(function(a, b){
    return a.time - b.time;
  });

  for(var i = 0; i < renderArray.length; i++) {
    time = renderArray[i].time;
    mins = Math.floor(time / 60);
    secs = Math.floor(time) % 60;

    renderArray[i].displayTime = mins + ":" + ('00' + secs).slice(-2)
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
  autosize.update($('textarea'));
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
