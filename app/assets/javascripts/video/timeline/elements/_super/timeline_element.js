TimelineElement = function(config) {
};

TimelineElement.prototype.init = function(el) {
  this.initialized = true;
  this.$el = el;
  autosize(this.$el.find('textarea'));

  this.initEdit();
};

TimelineElement.prototype.displayTimeToSecs = function(displayTime) {
  var mins = parseInt(displayTime.split(':')[0]);
  var secs = parseInt(displayTime.split(':')[1]);

  return mins * 60 + secs;
};

TimelineElement.prototype.secsToDisplayTime = function(seconds) {
  var mins = Math.floor(seconds / 60);
  var secs = Math.floor(seconds) % 60;

  return mins + ":" + ('00' + secs).slice(-2);
};

TimelineElement.prototype.displayTime = function() {
  return this.secsToDisplayTime(this.timeSeconds);
};

TimelineElement.prototype.html = function() {
  this.videoTextPartial = this.videoTextPartial || Handlebars.compile($('#video-text-partial').html());

  return this.videoTextPartial({
    time: this.timeSeconds,
    displayTime: this.displayTime(),
    displayClass: this.displayClass,
    displayIcon: this.displayIcon,
    displayText: this.displayText,
    editable: this.editable,
    trashable: this.trashable
  });
};

TimelineElement.prototype.insertBefore = function(insertBefore, creating) {
  if (this.initialized) {
    throw new Error('element has already been initialized');
  }
  insertBefore.before(this.html());
  this.init(insertBefore.prev());
  if (this.creating) {
    this.create();
  }
  return this;
};

TimelineElement.prototype.insertAfter = function(insertAfter, creating) {
  if (this.initialized) {
    throw new Error('element has already been initialized');
  }
  insertAfter.after(this.html(ephemeral));
  this.init(insertAfter.next());
  if (this.creating) {
    this.create();
  }
  return this;
};

TimelineElement.prototype.remove = function() {
  this.$el.remove();
};

TimelineElement.prototype.scrollIntoView = function() {
  this.$el.get(0).scrollIntoView();
};
