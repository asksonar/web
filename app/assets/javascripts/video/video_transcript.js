VideoTranscript = function(config, video) {
  this.$videoText = config.divVideoText;
  this.$btnToggleTranscripts = config.btnToggleTranscripts;
  this.$btnAddNote = config.btnAddNote;

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html());
  this.videoTextPartial = Handlebars.compile(config.scriptVideoTextPartial.html());
  Handlebars.registerPartial("video-text-partial", config.scriptVideoTextPartial.html());

  this.video = video;

  this.init();
};

VideoTranscript.prototype.init = function() {
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$videoText.on('click', '.video-btn-edit', $.proxy(this.editVideoText, this));
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
  this.$btnAddNote.on('click', $.proxy(this.createNote, this));

  this.onTimeupdate = $.proxy(this.onTimeupdate, this);
};

VideoTranscript.prototype.refreshView = function() {
  autosize.update($('textarea'));
  $(window).load(function() {
    autosize.update($('textarea'));
  });
}

VideoTranscript.prototype.toggleTranscripts = function(event) {
  $(event.currentTarget).toggleClass('active');
  var activeTranscripts = this.$btnToggleTranscripts.hasClass('active');

  this.showTranscripts(activeTranscripts);
};

VideoTranscript.prototype.editVideoText = function(event) {
  var thisEl = $(event.currentTarget);

  var parent = thisEl.closest('.ctnVideoTextLink');
  parent.addClass('active');

  this.$videoText.addClass('editing');

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
    this.$videoText.removeClass('editing');
    inputTime.prop('readonly', true);
    inputText.prop('readonly', true);
  });
}

VideoTranscript.prototype.buildTranscript = function(transcriptArray, delightedArray, confusedArray, highlightedArray) {
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
      displayText: "<span>User clicked</span><i class='feeling-delighted'></i>"
    })
  }

  for(var i = 0; confusedArray && i  < confusedArray.length; i++) {
    renderArray.push({
      time: confusedArray[i],
      displayClass: 'feeling-confused',
      displayIcon: 'feeling-confused',
      displayText: "<span>User clicked</span><i class='feeling-confused'></i>"
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
    this.$videoText.html(videoTranscript);
  } else {
    this.$videoText.html("(no transcription)");
  }

  autosize($('textarea'));
}

VideoTranscript.prototype.showTranscripts = function(showTranscripts) {
  if (showTranscripts === false) {
    this.$videoText.addClass('hide-transcripts');
  } else {
    this.$videoText.removeClass('hide-transcripts');
  }

}

VideoTranscript.prototype.clickVideoText = function(event) {
  var thisEl = $(event.currentTarget);
  if (thisEl.closest('.ctnVideoTextLink').hasClass('active')) {
    return;
  } else {
    var timestamp = thisEl.attr('data-timestamp');
    this.video.currentTime(timestamp);
  }
};

VideoTranscript.prototype.focusLink = function(timeSeconds) {
  var videoTextLinks = this.$videoText.find('.videoTextLink');
  var videoTextLink;
  for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
    videoTextLink = $(videoTextLinks[i]);
    if (parseInt(videoTextLink.attr('data-timestamp')) <= parseInt(timeSeconds)) {
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

VideoTranscript.prototype.activateLink = function(timeSeconds) {
  var videoTextLinks = this.$videoText.find('.videoTextLink').removeClass('activeVideoTextLink');
  var videoTextLink;
  for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
    videoTextLink = $(videoTextLinks[i]);
    if (parseInt(videoTextLink.attr('data-timestamp')) <= parseInt(timeSeconds)) {
      videoTextLink.addClass('activeVideoTextLink');
      break;
    }
  }
}

VideoTranscript.prototype.onTimeupdate = function(event, timeSeconds) {
  this.activateLink(timeSeconds);
};

VideoTranscript.prototype.createNote = function() {
  var timeSeconds = this.video.currentTime();

  var mins = Math.floor(timeSeconds / 60);
  var secs = Math.floor(timeSeconds) % 60;

  var html = this.videoTextPartial({
    time: timeSeconds,
    displayTime: mins + ":" + ('00' + secs).slice(-2),
    displayClass: 'note',
    displayIcon: 'fa fa-tag',
    displayText: '',
    editable: true,
    active: true
  });

  var followingLink;
  this.$videoText.find('.videoTextLink').each(function(){
    if (parseInt($(this).attr('data-timestamp')) > parseInt(timeSeconds)) {
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