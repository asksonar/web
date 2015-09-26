EditableComponent = function() {
  this.editable = true;

  this.onInit(function() {
    autosize(this.$el.find('textarea'));

    this.$inputTime = this.$el.find('.video-text-time');
    this.$inputText = this.$el.find('.video-text-display');
    this.$btnEdit = this.$el.find('.video-btn-edit');
    this.$btnSave = this.$el.find('.video-btn-save');
    this.$btnCancel = this.$el.find('.video-btn-cancel');

    this.$btnEdit.on('click', $.proxy(this.edit, this));
    this.$btnSave.on('click', $.proxy(this.save, this));
    this.$btnCancel.on('click', $.proxy(this.cancel, this));

    this.on('saveSuccess', $.proxy(this.saveSuccess, this));
    this.on('saveFail', $.proxy(this.saveFail, this));

    if (this.creating) {
      this.edit();
      this.setState('creating');
    }
  });

  this.setState = function(state) {
    this.$el.attr('data-state', state);
  };

  this.getState = function(state) {
    return this.$el.attr('data-state');
  };

  this.clearState = function() {
    this.$el.removeAttr('data-state');
  };

  this.edit = function() {
    this.setState('editing');
    this.$el.trigger('startEditing');

    this.originalTimeVal = this.$inputTime.val();
    this.originalTextVal = this.$inputText.val();

    this.$inputTime.prop('readonly', false);
    this.$inputText.prop('readonly', false);
    this.$inputText.focus();
  };

  this.setText = function(text) {
    this.$inputText.val(text);
  };

  this.setTime = function(timeSeconds) {
    this.$inputTime.val(this.secsToDisplayTime(timeSeconds));
    this.$el.attr('data-timestamp', timeSeconds);

    var prev = this.$el.prev();
    while(timeSeconds < parseInt(prev.attr('data-timestamp'))) {
      this.$el.insertBefore(prev);
      prev = this.$el.prev();
    }

    var next = this.$el.next();
    while(timeSeconds > parseInt(next.attr('data-timestamp'))) {
      this.$el.insertAfter(next);
      next = this.$el.next();
    }

    this.$el.trigger('startFocusing');
  };

  this.saveSuccess = function(customMsg) {
    if (typeof customMsg === 'string') {
      notify.warn(customMsg);
    } else if (this.getState() === 'creating') {
      notify.info('Your ' + this.displayClass + ' has been created.');
    } else {
      notify.info('Your ' + this.displayClass + ' has been saved.');
    }

    this.$el.trigger('stopEditing');
    this.clearState();

    this.$inputTime.prop('readonly', true);
    this.$inputText.prop('readonly', true);
  };

  this.saveFail = function(customMsg) {
    if (typeof customMsg === 'string') {
      notify.warn(customMsg);
    } else if (this.getState() === 'creating') {
      notify.warn('There was an error creating your  ' + this.displayClass + '.');
    } else {
      notify.warn('There was an error saving your ' + this.displayClass + '.');
    }
  };

  this.cancel = function() {
    this.$el.trigger('stopEditing');

    if (this.getState() === 'creating') {
      this.remove();
    } else {
      this.clearState();
      this.$inputTime.prop('readonly', true);
      this.$inputText.prop('readonly', true);
      this.$inputTime.val(this.originalTimeVal);
      this.$inputText.val(this.originalTextVal);
    }
  };

};
