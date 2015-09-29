HighlightTimeline = function(config) {
  this.$highlightStart = config.highlightStart;
  this.$highlightFinish = config.highlightFinish;
  this.checkboxSelector = config.checkboxSelector;
  this.$checkAll = config.checkAll;

  this.onInit(function() {
    this.$container.on('click', this.checkboxSelector, $.proxy(this.updateCheckAll, this));
    this.$checkAll.on('click', $.proxy(this.setCheckAll, this));
  });

  this.onVideoRangeChange = function(event, startTime, finishTime) {
    this.setHighlightStartFinish(startTime, finishTime);
  };

  this.setHighlightStartFinish = function(startTime, finishTime) {
    var insertAfter = this.findTextLinkBefore(startTime);
    if (insertAfter.length === 0) {
      insertAfter = this.getTimelineBeginning();
    }
    insertAfter.after(this.$highlightStart);

    var insertBefore = this.findTextLinkAfter(finishTime);
    if (insertBefore.length === 0) {
      insertBefore = this.getTimelineEnding();
    }
    insertBefore.before(this.$highlightFinish);

    this.findTextLinks()
      .removeClass('ctn-highlight-disabled')
      .find("input[type='checkbox']")
      .prop('disabled', false);
    this.findTextLinksBefore(startTime)
      .addClass('ctn-highlight-disabled')
      .find("input[type='checkbox']")
      .prop('disabled', true);
    this.findTextLinksAfter(finishTime)
      .addClass('ctn-highlight-disabled')
      .find("input[type='checkbox']")
      .prop('disabled', true);;
  };

  this.updateCheckAll = function() {
    var visibleCheckboxes = $(this.checkboxSelector + ':visible');
    var checked = $.makeArray(visibleCheckboxes).reduce(function(prev, current) {
      return prev + ($(current).prop('checked') ? 1 : 0);
    }, 0);

    if (checked === 0) {
      this.$checkAll.prop('checked', false);
      this.$checkAll.prop('indeterminate', false);
    } else if (checked === visibleCheckboxes.length) {
      this.$checkAll.prop('checked', true);
      this.$checkAll.prop('indeterminate', false);
    } else {
      this.$checkAll.prop('checked', false);
      this.$checkAll.prop('indeterminate', true);
    }
  };

  this.setCheckAll = function() {
    var checked = this.$checkAll.prop('checked');
    var visibleCheckboxes = $(this.checkboxSelector + ':visible');
    visibleCheckboxes.prop('checked', checked);
  };

  this.setChecked = function(noteHashids, feelingHashids) {
    $(this.checkboxSelector).prop('checked', false);

    var selector = this.checkboxSelector + "[name='scenario_highlight[{{type}}][{{hashid}}]']";
    (noteHashids || []).forEach(function(hashid) {
      $(selector.replace('{{type}}', 'note').replace('{{hashid}}', hashid)).prop('checked', true);
    });
    (feelingHashids || []).forEach(function(hashid) {
      $(selector.replace('{{type}}', 'feeling').replace('{{hashid}}', hashid)).prop('checked', true);
    });
  };

  this.setCheckedNotes = function() {
    $(this.checkboxSelector).prop('checked', false);
    var visibleNotes = $(this.checkboxSelector + "[name^='scenario_highlight[note]']:visible");
    visibleNotes.prop('checked', true);
  };

};
