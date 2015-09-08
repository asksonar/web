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

TimelineElement.prototype.html = function(active) {
  this.videoTextPartial = this.videoTextPartial || Handlebars.compile($('#video-text-partial').html());

  return this.videoTextPartial({
    time: this.timeSeconds,
    displayTime: this.displayTime(),
    displayClass: this.displayClass,
    displayIcon: this.displayIcon,
    displayText: this.displayText,
    editable: this.editable
  });
};

TimelineElement.prototype.insertBefore = function(insertBefore, ephemeral) {
  if (this.initialized) {
    throw new Error('element has already been initialized');
  }
  this.ephemeral = ephemeral;
  insertBefore.before(this.html(ephemeral));
  this.init(insertBefore.prev());
  if (this.ephemeral) {
    this.edit();
  }
  return this;
};

TimelineElement.prototype.insertAfter = function(insertAfter, ephemeral) {
  if (this.initialized) {
    throw new Error('element has already been initialized');
  }
  this.ephemeral = ephemeral;
  insertAfter.after(this.html(ephemeral));
  this.init(insertAfter.next());
  if (this.ephemeral) {
    this.edit();
  }
  return this;
};

TimelineElement.prototype.remove = function() {
  this.$el.remove();
};

TimelineElement.prototype.scrollIntoView = function() {
  this.$el.get(0).scrollIntoView();
};
