function VideoModal(config, video, transcript) {
  this.$modal = config.modal;
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

  this.videoResizeButton = Handlebars.compile(config.scriptVideoResizeButton.html());

  this.init();
}

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
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

    this.transcript.buildTranscript(
      data.transcription_array,
      data.delighted_array,
      data.confused_array,
      data.highlighted_array
    );

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
  this.transcript.focusLink(timeSeconds);
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

  this.transcript.activateLink(timestamp);
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
  this.transcript.createNote(time);
}
