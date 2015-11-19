function ResultsView(config, videoModal, deleteModal) {
  this.$divAllContent = config.divAllContent;
  this.$btnCopyShareLink = config.btnCopyShareLink;
  this.$inputShareLink = config.inputShareLink;
  this.$btnArchive = config.btnArchive;
  this.$btnDelete = config.btnDelete;
  this.$btnHeroCopyShareLink = config.btnHeroCopyShareLink;
  this.$inputHeroShareLink = config.inputHeroShareLink;
  this.$panelHero = config.panelHero;
  this.$resultPanelToggle = config.resultPanelToggle;

  this.videoModal = videoModal;
  this.deleteModal = deleteModal;

  this.init();
}

ResultsView.prototype.init = function() {
  this.$divAllContent.on('click', '.video-link', $.proxy(this.loadVideoModal, this));
  this.$btnDelete.on('click', $.proxy(this.loadDeleteModal, this));
  this.$btnArchive.on('click', $.proxy(this.toggleArchive, this));
  this.$resultPanelToggle.on('click', 'li.active', $.proxy(this.collapseTab, this));
  new ClipboardInput(this.$btnCopyShareLink, this.$inputShareLink);
  new ClipboardInput(this.$btnHeroCopyShareLink, this.$inputHeroShareLink);
  this.highlightHero();
};

ResultsView.prototype.collapseTab = function(event) {
  event.stopPropagation();

  var thisEl = $(event.currentTarget);
  thisEl.removeClass('active');
  thisEl.children().attr('aria-expanded', 'false');

  var $href = thisEl.children().attr('href');
  this.$resultPanelToggle.find($href).toggleClass('active');
};

ResultsView.prototype.toggleArchive = function() {
  var isOn = this.$btnArchive.find('.btn-active-on').hasClass('active');

  $.ajax({
    type: 'POST',
    url: new URL(window.location.href).pathname,
    data: {
      _method: 'PATCH',
      is_on: isOn,
      authenticity_token: AUTH_TOKEN
    }
  }).success($.proxy(function(){

    this.$btnArchive.find('.btn').toggleClass('active');
    if (isOn) {
      notify.info('<strong>Study Archived</strong> - Your share link is no longer active.');
      this.$inputShareLink.slideUp();
      this.$btnCopyShareLink.slideUp();
      this.$btnArchive.attr('data-original-title', 'Re-open the study');
      this.$btnArchive.tooltip('show');
    } else {
      notify.info('<strong>Study Active</strong> - Your share link is now active.');
      this.$inputShareLink.slideDown();
      this.$btnCopyShareLink.slideDown();
      this.$btnArchive.attr('data-original-title', 'Close the study');
      this.$btnArchive.tooltip('show');
    }

  }, this)).fail($.proxy(function(jqXHR){
    notify.error(jqXHR.responseText, 'There was an error setting the Live state.');
  }, this));
};

ResultsView.prototype.loadVideoModal = function(event) {
  event.preventDefault();
  var thisEl = $(event.currentTarget);
  var scenarioResultHashId = thisEl.attr('data-scenario-result-hashid');
  var timeSeconds = parseFloat(thisEl.attr('data-result-step-offset-seconds') || 0);

  this.videoModal.load(scenarioResultHashId, timeSeconds);
};

ResultsView.prototype.loadDeleteModal = function(event) {
  this.deleteModal.show();
};

ResultsView.prototype.highlightHero = function() {
  window.overlay.show(this.$panelHero, true);
};
