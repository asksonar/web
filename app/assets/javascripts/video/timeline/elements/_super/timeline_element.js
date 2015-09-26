modulejs.define('TimelineElement', function() {
  var timelineElement = Object.create(Object.prototype, {
    clazz: { value: 'TimelineElement' }
  });

  Creatable.call(timelineElement);
  Eventable.call(timelineElement);
  Initable.call(timelineElement, function() {
    this.initialized = true;
  });

  timelineElement.displayTimeToSecs = function(displayTime) {
    var mins = parseInt(displayTime.split(':')[0]);
    var secs = parseInt(displayTime.split(':')[1]);

    return mins * 60 + secs;
  };

  timelineElement.secsToDisplayTime = function(seconds) {
    var mins = Math.floor(seconds / 60);
    var secs = Math.floor(seconds) % 60;

    return mins + ":" + ('00' + secs).slice(-2);
  };

  timelineElement.displayTime = function() {
    return this.secsToDisplayTime(this.timeSeconds);
  };

  timelineElement.html = function() {
    this.videoTextPartial = this.videoTextPartial || Handlebars.compile($('#video-text-partial').html());

    return this.videoTextPartial({
      time: this.timeSeconds,
      displayTime: this.displayTime(),
      displayClass: this.displayClass,
      displayIcon: this.displayIcon,
      displayText: this.displayText,
      editable: this.editable,
      trashable: this.trashable,
      hashid: this.hashid
    });
  };

  timelineElement.insertBefore = function(insertBefore, creating) {
    if (this.initialized) {
      throw new Error('element has already been initialized');
    }
    insertBefore.before(this.html());
    this.$el = insertBefore.prev();

    this.creating = creating;
    this.init();

    return this;
  };

  timelineElement.insertAfter = function(insertAfter, creating) {
    insertAfter.after(this.html());
    if (this.initialized) {
      throw new Error('element has already been initialized');
    }
    this.$el = insertAfter.next();

    this.creating = creating;
    this.init();

    return this;
  };

  timelineElement.remove = function() {
    this.$el.remove();
  };

  timelineElement.scrollIntoView = function() {
    this.$el.get(0).scrollIntoView();
  };

  timelineElement.buildElementArray = function(arrayOfElements) {
    return arrayOfElements.map($.proxy(function(currentValue) {
      return this.create(currentValue);
    }, this));
  };

  return timelineElement;
});
