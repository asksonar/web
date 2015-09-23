HighlightTimeline = function(config) {

  this.$highlightStart = config.highlightStart;
  this.$highlightFinish = config.highlightFinish;

  // target.setHighlightStart = function(timeSeconds) {
  //   this.setHighlightStartFinish(timeSeconds, this.finishTime);
  // };

  // target.setHighlightFinish = function(timeSeconds) {
  //   this.setHighlightStartFinish(this.startTime, timeSeconds);
  // };

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

    this.findTextLinks().removeClass('ctn-highlight-disabled');
    this.findTextLinksBefore(startTime).addClass('ctn-highlight-disabled');
    this.findTextLinksAfter(finishTime).addClass('ctn-highlight-disabled');
  };

};
