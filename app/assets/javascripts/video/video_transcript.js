VideoTranscript = function(config, video) {
  this.$container = config.divTranscriptContainer;
  this.$videoText = config.divVideoText;
  this.$btnToggleTranscripts = config.btnToggleTranscripts;
  this.$btnAddNote = config.btnAddNote;

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html());
  this.videoTextPartial = Handlebars.compile(config.scriptVideoTextPartial.html());
  Handlebars.registerPartial("video-text-partial", config.scriptVideoTextPartial.html());

  this.video = video;

  this.timelineArray = [];

  this.init();
};

VideoTranscript.prototype.init = function() {
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));

  this.$videoText.on('click', '.video-btn-edit', $.proxy(function() {
    this.$videoText.addClass('editing');
  }, this));
  this.$videoText.on('click', '.video-btn-save', $.proxy(function() {
    this.$videoText.removeClass('editing');
  }, this));
  this.$videoText.on('click', '.video-btn-cancel', $.proxy(function() {
    this.$videoText.removeClass('editing');
  }, this));
  this.$videoText.on('click', '.video-btn-trash', $.proxy(function() {
    this.$videoText.removeClass('editing');
  }, this));

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
  this.$container.toggleClass('show-transcripts');
};

VideoTranscript.prototype.buildTranscript = function(transcriptArray, delightedArray, confusedArray, highlightedArray) {
  var delightedIndex = 0, confusedIndex = 0;
  var renderArray = [];
  var videoTranscript;
  var time, mins, secs, text;
  var hasDelighted, hasConfused, nextTime;

  for(var i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].remove();
  }
  this.timelineArray = [];

  for(var i = 0; delightedArray && i  < delightedArray.length; i++) {
    this.timelineArray.push(
      new FeelingDelightedElement({
        timeSeconds: delightedArray[i]
      })
    );
  }

  for(var i = 0; confusedArray && i  < confusedArray.length; i++) {
    this.timelineArray.push(
      new FeelingConfusedElement({
        timeSeconds: confusedArray[i]
      })
    );
  }

  for(var i = 0; i  < transcriptArray.length; i++) {
    time = transcriptArray[i].offset_seconds;
    text = transcriptArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    this.timelineArray.push(
      new TranscriptElement({
        timeSeconds: time,
        displayText: text
      })
    );
  }

  this.timelineArray.sort(function(a, b){
    return a.timeSeconds - b.timeSeconds;
  });

  for(var i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].insertBefore(this.findTextLinkEnd(), false);
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


// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the 10 element
// if we ask timeSeconds = 5, we get []
VideoTranscript.prototype.findTextLinkBefore = function(timeSeconds) {
  var textLinks = this.$videoText.find('.videoTextLink');
  var textLink = textLinks.first();

  textLinks.each(function(){
    if (parseInt($(this).attr('data-timestamp')) < parseInt(timeSeconds)) {
      textLink = this;
    } else {
      return false;
    }
  });

  return $(textLink).closest('.ctnVideoTextLink');
};

// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the first 15 element
// if we ask timeSeconds = 5, we get []
VideoTranscript.prototype.findTextLinkBeforeOrEqual = function(timeSeconds) {
  var textLinks = this.$videoText.find('.videoTextLink');
  var textLink;

  textLinks.each(function(){
    if (parseInt($(this).attr('data-timestamp')) < parseInt(timeSeconds)) {
      textLink = this;
    } else if (parseInt($(this).attr('data-timestamp')) == parseInt(timeSeconds)) {
      textLink = this;
      return false;
    } else {
      return false;
    }
  });

  return $(textLink).closest('.ctnVideoTextLink');
}

// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the 20 element
// if we ask 25, we get []
VideoTranscript.prototype.findTextLinkAfter = function(timeSeconds) {
  var textLinks = this.$videoText.find('.videoTextLink');
  var textLink;

  this.$videoText.find('.videoTextLink').each(function(){
    if (parseInt($(this).attr('data-timestamp')) > parseInt(timeSeconds)) {
      textLink = $(this).closest('.ctnVideoTextLink');
      return false;
    }
  });

  return $(textLink).closest('.ctnVideoTextLink');
};

// gets back the noTranscript placeholder element, which should always be the last element
VideoTranscript.prototype.findTextLinkEnd = function() {
  return this.$videoText.children().last();
}

VideoTranscript.prototype.createNote = function() {
  var timeSeconds = this.video.currentTime();

  var newElement = new NoteElement({
    timeSeconds: timeSeconds,
    displayText: ''
  });

  this.timelineArray.push(newElement);

  var insertBefore = this.findTextLinkAfter(timeSeconds);
  if (insertBefore.length > 0) {
    newElement.insertBefore(insertBefore, true);
  } else {
    newElement.insertBefore(this.findTextLinkEnd(), true);
  }

  this.$videoText.addClass('editing');
}
