VideoTranscript = function(config, video) {
  this.$container = config.divTranscriptContainer;
  this.$videoText = config.divVideoText;
  this.$btnToggleTranscripts = config.btnToggleTranscripts;
  this.$btnAddNote = config.btnAddNote;
  this.$timelineBeginning = config.timelineBeginning;
  this.$timelineEnding = config.timelineEnding;

  this.videoTextTemplate = Handlebars.compile(config.scriptVideoTextTemplate.html());
  this.videoTextPartial = Handlebars.compile(config.scriptVideoTextPartial.html());
  Handlebars.registerPartial("video-text-partial", config.scriptVideoTextPartial.html());

  this.video = video;

  this.timelineArray = [];
};

Initable.call(VideoTranscript.prototype, function() {
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
  this.$btnAddNote.on('click', $.proxy(this.createNote, this));

  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
  this.$videoText.on('startEditing', $.proxy(this.startEditing, this));
  this.$videoText.on('stopEditing', $.proxy(this.stopEditing, this));
  this.$videoText.on('startFocusing', $.proxy(this.startFocusing, this));

  this.onTimeupdate = $.proxy(this.onTimeupdate, this);
});

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

VideoTranscript.prototype.startFocusing = function(event) {
  var element = $(event.target);
  this.scrollIntoView(element);
};

VideoTranscript.prototype.clearView = function() {
  for(i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].remove();
  }
  this.timelineArray = [];

  this.stopEditing();
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

VideoTranscript.prototype.buildTranscript = function(resultStepHashId, timelineArray) {
  this.resultStepHashId = resultStepHashId;

  this.clearView();
  this.timelineArray = timelineArray;

  this.timelineArray.sort(function(a, b){
    return a.timeSeconds - b.timeSeconds;
  });

  for(var i = 0; i < this.timelineArray.length; i++) {
    this.timelineArray[i].insertBefore(this.getTimelineEnding(), false);
  }
};

VideoTranscript.prototype.clickVideoText = function(event) {
  var thisEl = $(event.currentTarget).parent();
  if (thisEl.attr('data-state')) {
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
  link.find('.videoTextLink').css({'background-color':'#F69526'})
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

VideoTranscript.prototype.findTextLinks = function() {
  return this.$videoText.find('.ctnVideoTextLink');
};

// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the 10 element
// if we ask timeSeconds = 5, we get []
VideoTranscript.prototype.findTextLinkBefore = function(timeSeconds) {
  var textLinks = this.$videoText.find('.ctnVideoTextLink');
  var textLink;

  textLinks.each(function(){
    if (parseInt($(this).attr('data-timestamp')) < parseInt(timeSeconds)) {
      textLink = this;
    } else {
      return false;
    }
  });

  return $(textLink);
};

VideoTranscript.prototype.findTextLinksBefore = function(timeSeconds) {
  var textLinks = this.$videoText.find('.ctnVideoTextLink');
  return textLinks.filter(function() {
    return parseInt($(this).attr('data-timestamp')) < parseInt(timeSeconds);
  });
};

// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the first 15 element
// if we ask timeSeconds = 5, we get []
VideoTranscript.prototype.findTextLinkBeforeOrEqual = function(timeSeconds) {
  var textLinks = this.$videoText.find('.ctnVideoTextLink');
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

  return $(textLink);
};

// if we have 10, 15, 15, 20 and timeSeconds = 15, we get back the 20 element
// if we ask 25, we get []
VideoTranscript.prototype.findTextLinkAfter = function(timeSeconds) {
  var textLinks = this.$videoText.find('.ctnVideoTextLink');
  var textLink;

  textLinks.each(function(){
    if (parseInt($(this).attr('data-timestamp')) > parseInt(timeSeconds)) {
      textLink = $(this);
      return false;
    }
  });

  return $(textLink);
};

VideoTranscript.prototype.findTextLinksAfter = function(timeSeconds) {
  var textLinks = this.$videoText.find('.ctnVideoTextLink');
  return textLinks.filter(function() {
    return parseInt($(this).attr('data-timestamp')) > parseInt(timeSeconds);
  });
};

// gets back the noTranscript placeholder element, which should always be the last element
VideoTranscript.prototype.getTimelineBeginning = function() {
  return this.$timelineBeginning;
};

VideoTranscript.prototype.getTimelineEnding = function() {
  return this.$timelineEnding;
};

VideoTranscript.prototype.createNote = function() {
  if (this.isEditing()) {
    notify.warn('Editing is already in progress.');
    return;
  }

  var timeSeconds = this.video.currentTime();

  var newElement = new NoteElement({
    time: timeSeconds,
    text: '',
    resultStepHashId: this.resultStepHashId
  });

  this.timelineArray.push(newElement);

  var insertBefore = this.findTextLinkAfter(timeSeconds);
  if (insertBefore.length > 0) {
    newElement.insertBefore(insertBefore, true);
  } else {
    newElement.insertBefore(this.getTimelineEnding(), true);
  }
};

VideoTranscript.prototype.restoreNote = function(timeSeconds, text) {
  var newElement = new NoteElement({
    time: timeSeconds,
    text: text,
    resultStepHashId: this.resultStepHashId
  });

  var insertBefore = this.findTextLinkAfter(timeSeconds);
  if (insertBefore.length > 0) {
    newElement.insertBefore(insertBefore, false);
  } else {
    newElement.insertBefore(this.getTimelineEnding(), false);
  }
};
