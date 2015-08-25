function VideoModal(config, video, transcript) {
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
  this.$divVideoTranscriptContainer = config.divVideoTranscriptContainer;
  this.$btnAddNote = config.btnAddNote;
  this.$spanTime = config.spanTime;

  this.video = video;
  this.transcript = transcript;

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html());
  this.videoTextPartial = Handlebars.compile(config.scriptVideoTextPartial.html());
  this.videoResizeButton = Handlebars.compile(config.scriptVideoResizeButton.html());
  Handlebars.registerPartial("video-text-partial", config.scriptVideoTextPartial.html());

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
  //this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
  // this.$btnToggleNotes.on('click', $.proxy(this.toggleViewMode, this));
  this.$btnAddNote.on('click', $.proxy(this.createNote, this));

  this.video.on('timeupdate', $.proxy(this.updateVideoTime, this));

  $('.vjs-control-bar .vjs-fullscreen-control').after(this.videoResizeButton({}));
  $('.vjs-custom-resize-control').on('click', $.proxy(this.toggleViewMode, this));

  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);
}

VideoModal.prototype.toggleTranscripts = function(event) {
  $(event.currentTarget).toggleClass('active');
  var activeTranscripts = this.$btnToggleTranscripts.hasClass('active');

  this.transcript.showTranscripts(activeTranscripts);
}

VideoModal.prototype.toggleViewMode = function(event) {
  this.$divVideoTranscriptContainer.toggleClass('icon-mode');
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
      data.confused_array,
      data.highlighted_array
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
        if (parent.hasClass('transcript')) {
          notify.info('Your transcript has been updated.');
        } else if (parent.hasClass('note')) {
          notify.info('Your note has been updated.');
        }

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

VideoModal.prototype.focusLink = function(timeSeconds) {
  var videoTextLinks = this.$videoText.find('.videoTextLink');
  var videoTextLink;
  for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
    videoTextLink = $(videoTextLinks[i]);
    if (videoTextLink.attr('data-timestamp') <= timeSeconds) {
      videoTextLink.parent().get(0).scrollIntoView();
      videoTextLink.parent()
        .css({'background-color':'#F69526'})
        .animate({'background-color':''}, 3000)
        .queue(function() {
          $(this).removeAttr('style').dequeue();
        })
      break;
    }
  }
}

VideoModal.prototype.buildTranscript = function(transcriptArray, delightedArray, confusedArray, highlightedArray) {

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
      displayText: "User clicked <i class='feeling-delighted'></i>"
    })
  }

  for(var i = 0; confusedArray && i  < confusedArray.length; i++) {
    renderArray.push({
      time: confusedArray[i],
      displayClass: 'feeling-confused',
      displayIcon: 'feeling-confused',
      displayText: "User clicked <i class='feeling-confused'></i>"
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
      editable: true
    });
  }

/*
  for(var i = 0; i  < highlightedArray.length; i++) {
    time = highlightedArray[i].offset_seconds;
    text = highlightedArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    renderArray.push({
      time: time,
      displayClass: 'note',
      displayIcon: 'fa fa-tag',
      displayText: text,
      editable: true
    });
  }
*/

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
    var newUrl = URI(location.href).segment('videos').segment(this.resultStepHashId).addSearch("t", 0);
    history.replaceState({}, '', newUrl);
  }

  autosize.update($('textarea'));
  $(window).load(function() {
    autosize.update($('textarea'));
  });
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
  var thisEl = $(event.currentTarget);
  if (thisEl.closest('.ctnVideoTextLink').hasClass('active')) {
    return;
  } else {
    var timestamp = thisEl.attr('data-timestamp');
    this.video.currentTime(timestamp);
  }
}

VideoModal.prototype.updateVideoTime = function(event, timestamp) {

  var currentSeconds = parseInt(timestamp);

  var displayTime = Math.floor(currentSeconds / 60) + ':' + ('00' + currentSeconds % 60).slice(-2);
  this.$inputUrlTime.val(displayTime);
  this.$spanTime.text(displayTime);

  var displayUrl = this.$inputUrlBase.attr('data-base-url') + currentSeconds;
  var inputUrlBaseDom = this.$inputUrlBase.get(0);
  var selectionStart = inputUrlBaseDom.selectionStart;
  var selectionEnd = inputUrlBaseDom.selectionEnd;
  var selectionAll = inputUrlBaseDom.value.length > 0 && selectionEnd - selectionStart == inputUrlBaseDom.value.length;
  this.$inputUrlBase.val(displayUrl);
  if (this.$inputUrlBase.is(':focus')) {
    if (selectionAll) {
      inputUrlBaseDom.setSelectionRange(0, inputUrlBaseDom.value.length);
    } else {
      inputUrlBaseDom.setSelectionRange(selectionStart, selectionEnd);
    }
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

VideoModal.prototype.createNote = function() {
  var time = this.video.currentTime();
  var mins = Math.floor(time / 60);
  var secs = Math.floor(time) % 60;

  var html = this.videoTextPartial({
    time: time,
    displayTime: mins + ":" + ('00' + secs).slice(-2),
    displayClass: 'note',
    displayIcon: 'fa fa-tag',
    displayText: '',
    editable: true,
    active: true
  });

  var followingLink;
  this.$videoText.find('.videoTextLink').each(function(){
    if ($(this).attr('data-timestamp') > time) {
      followingLink = $(this).closest('.ctnVideoTextLink');
      return false;
    }
  });

  var newLink;
  if (followingLink) {
    followingLink.before(html);
    newLink = followingLink.prev();
  } else {
    this.$videoText.html(html);
    newLink = this.$videoText.find('.ctnVideoTextLink');
  }

  var inputTime = newLink.find('.video-text-time');
  var inputText = newLink.find('.video-text-display');

  inputText.focus();

  newLink.find('.video-btn-cancel').on('click', function() {
    newLink.remove();
  });

  newLink.find('.video-btn-save').on('click', function(){
    notify.info('Your note has been created.');

    newLink.removeClass('active');
    inputTime.prop('readonly', true);
    inputText.prop('readonly', true);
  });

}
