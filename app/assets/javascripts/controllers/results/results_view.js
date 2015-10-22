function ResultsView(config, videoModal, deleteModal) {
  this.$divAllContent = config.divAllContent;
  this.$btnCopyShareLink = config.btnCopyShareLink;
  this.$inputShareLink = config.inputShareLink;
  this.$btnArchive = config.btnArchive;
  this.$btnDelete = config.btnDelete;
  this.$btnHeroCopyShareLink = config.btnHeroCopyShareLink;
  this.$inputHeroShareLink = config.inputHeroShareLink;
  this.$panelHero = config.panelHero;

  this.videoModal = videoModal;
  this.deleteModal = deleteModal;

  this.init();
}

ResultsView.prototype.init = function() {
  this.$divAllContent.on('click', '.video-link', $.proxy(this.loadVideoModal, this));
  this.$btnDelete.on('click', $.proxy(this.loadDeleteModal, this));
  this.$btnArchive.on('click', $.proxy(this.toggleArchive, this));
  new ClipboardInput(this.$btnCopyShareLink, this.$inputShareLink);
  new ClipboardInput(this.$btnHeroCopyShareLink, this.$inputHeroShareLink);
  this.highlightHero();
  this.showAllPanelGraphs();
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
  var thisEl = $(event.currentTarget);
  var resultStepHashId = thisEl.attr('data-result-step-hashid');
  var timeSeconds = parseFloat(thisEl.attr('data-feeling-at-seconds') || 0);

  this.videoModal.load(resultStepHashId, timeSeconds);
};

ResultsView.prototype.loadDeleteModal = function(event) {
  this.deleteModal.show();
};

ResultsView.prototype.showPanelGraph = function(panelBody) {
  var timesArray = JSON.parse(panelBody.find('script').html());
  var graphId = panelBody.find('.graph').attr('id');
  this.setupGraph(timesArray, graphId);
};

ResultsView.prototype.showAllPanelGraphs = function() {
  var showPanelGraph = $.proxy(this.showPanelGraph, this);
  $('.panel-body').each(function() {
    showPanelGraph($(this));
  });
};

ResultsView.prototype.setupGraph = function(timesArray, graphId) {
  var chart = AmCharts.makeChart(graphId, {
    "type": "serial",
    "theme": "light",
    "creditsPosition": "top-right",
    "hideBalloonTime": 2000,
    "categoryField": "display",
    "gridAboveGraphs": true,
    "backgroundColor": '#FAFAFA',
    "backgroundAlpha": 1,
    "graphs": [{
      "fillAlphas": 1,
      "lineAlphas": 0,
      "type": "column",
      "valueField": "count",
      "columnWidth": 0.75,
      "showBalloon": false
    }],
    categoryAxis: {
      "title": "time",
      "titleBold": false,
      "gridAlpha": 0,
      "tickLength": 0,
      "gridCount": 0,
      "autoGridCount": false
    },
    "valueAxes": [{
      "title": "users",
      "titleBold": false,
      "gridAlpha": 0,
      "tickLength": 0,
      "labelsEnabled": false
    }],
    "balloon": {
      "fixedPosition": true
    },
    "dataProvider": timesArray
  });

  chart.addListener('clickGraphItem', function(event) {
    var details = event.item.dataContext.details;
  });
};

ResultsView.prototype.highlightHero = function() {
  window.overlay.show(this.$panelHero, true);
};
