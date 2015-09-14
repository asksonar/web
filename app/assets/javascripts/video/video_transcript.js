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
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
  this.$btnAddNote.on('click', $.proxy(this.createNote, this));

  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$videoText.on('startEditing', $.proxy(this.startEditing, this));
  this.$videoText.on('stopEditing', $.proxy(this.stopEditing, this));

  this.onTimeupdate = $.proxy(this.onTimeupdate, this);
};

VideoTranscript.prototype.startEditing = function(event) {
  this.$videoText.addClass('editing');

  var element = $(event.target);
  this.scrollIntoView(element);
};

VideoTranscript.prototype.stopEditing = function() {
  this.$videoText.removeClass('editing');
};

VideoTranscript.prototype.isEditing = function() {
  return this.$videoText.hasClass('editing');
};

VideoTranscript.prototype.refreshView = function() {
  autosize.update($('textarea'));
  $(window).load(function() {
    autosize.update($('textarea'));
  });
};

VideoTranscript.prototype.toggleTranscripts = function(event) {
  this.$container.toggleClass('show-transcripts');
};

VideoTranscript.prototype.buildTranscript = function(resultStepHashId, transcriptArray, delightedArray, confusedArray, highlightedArray) {
  this.resultStepHashId = resultStepHashId;

  var i, hashid, timeSeconds, text;

  for(i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].remove();
  }
  this.timelineArray = [];

  for(i = 0; delightedArray && i  < delightedArray.length; i++) {
    hashid = delightedArray[i].hashid;
    timeSeconds = delightedArray[i].time;

    this.timelineArray.push(
      new FeelingDelightedElement({
        hashid: hashid,
        timeSeconds: timeSeconds
      })
    );
  }

  for(i = 0; confusedArray && i  < confusedArray.length; i++) {
    hashid = confusedArray[i].hashid;
    timeSeconds = confusedArray[i].time;

    this.timelineArray.push(
      new FeelingConfusedElement({
        hashid: hashid,
        timeSeconds: timeSeconds
      })
    );
  }

  for(i = 0; highlightedArray && i  < highlightedArray.length; i++) {
    hashid = highlightedArray[i].hashid;
    timeSeconds = highlightedArray[i].time;
    text = highlightedArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    this.timelineArray.push(
      new NoteElement({
        hashid: hashid,
        timeSeconds: timeSeconds,
        displayText: text,
        resultStepHashId: resultStepHashId
      })
    );
  }

  for(i = 0; i  < transcriptArray.length; i++) {
    hashid = transcriptArray[i].hashid;
    timeSeconds = transcriptArray[i].time;
    text = transcriptArray[i].text;
    text = (text || '').trim();
    if (!text) {
      continue;
    }

    this.timelineArray.push(
      new TranscriptElement({
        hashid: hashid,
        timeSeconds: timeSeconds,
        displayText: text,
        resultStepHashId: resultStepHashId
      })
    );
  }

  this.timelineArray.sort(function(a, b){
    return a.timeSeconds - b.timeSeconds;
  });

  for(i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].insertBefore(this.findTextLinkEnd(), false);
  }
};

VideoTranscript.prototype.clickVideoText = function(event) {
  var thisEl = $(event.currentTarget);
  if (thisEl.closest('.ctnVideoTextLink').attr('data-state')) {
    return;
  } else {
    var timestamp = thisEl.attr('data-timestamp');
    this.video.currentTime(timestamp);
  }
};

VideoTranscript.prototype.focusLink = function(timeSeconds) {
  if (timeSeconds <= 0) {
    return;
  }
  var link = this.findTextLinkBeforeOrEqual(timeSeconds);
  if (link.length === 0) {
    // we're before the first element in the timeline
    // so nothing to focus on yet
    return;
  }
  this.scrollIntoView(link);
  link.css({'background-color':'#F69526'})
    .animate({'background-color':''}, 3000)
    .queue(function() {
      $(this).removeAttr('style').dequeue();
    });
};

VideoTranscript.prototype.scrollIntoView = function(element) {
  // element is inside the scrollable container
  // window refers to the viewable portion of the container

  var windowToContainerTop = this.$videoText.scrollTop();
  var containerHeight = this.$videoText.height();

  var elementHeight = element.height();
  var elementToWindowTop = element.position().top;
  var elementToContainerTop = elementToWindowTop + windowToContainerTop;

  if (elementToWindowTop < 0) {
    this.$videoText.animate({scrollTop: elementToContainerTop});
  } else if ((elementToWindowTop + elementHeight) > containerHeight) {
    this.$videoText.animate({scrollTop: elementToContainerTop + elementHeight  - containerHeight});
  }
};

VideoTranscript.prototype.activateLink = function(timeSeconds) {
  this.$videoText.children().removeClass('activeVideoTextLink');
  this.findTextLinkBeforeOrEqual(timeSeconds).addClass('activeVideoTextLink');
};

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
};

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
};

VideoTranscript.prototype.findTextLinkBeginning = function() {
  return this.$videoText.children().first();
};

VideoTranscript.prototype.createNote = function() {
  if (this.isEditing()) {
    notify.info('Editing is already in progress.');
    return;
  }

  var timeSeconds = this.video.currentTime();

  var newElement = new NoteElement({
    timeSeconds: timeSeconds,
    displayText: '',
    resultStepHashId: this.resultStepHashId
  });

  this.timelineArray.push(newElement);

  var insertBefore = this.findTextLinkAfter(timeSeconds);
  if (insertBefore.length > 0) {
    newElement.insertBefore(insertBefore, true);
  } else {
    newElement.insertBefore(this.findTextLinkEnd(), true);
  }
};
