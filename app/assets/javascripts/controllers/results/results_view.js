function ResultsView(config, modal) {
  this.$divAllContent = config.divAllContent;
  this.$divMainContent = config.divMainContent;
  this.$btnCopyShareLink = config.btnCopyShareLink;
  this.$inputShareLink = config.inputShareLink;
  this.$btnArchive = config.btnArchive;
  this.$btnHeroCopyShareLink = config.btnHeroCopyShareLink;
  this.$inputHeroShareLink = config.inputHeroShareLink;
  this.$panelHero = config.panelHero;

  this.modal = modal;

  this.init();
}

ResultsView.prototype.init = function() {
  this.$divAllContent.on('click', '.video-link', $.proxy(this.loadModal, this));
  this.$divMainContent.on('click', '.fa-chevron-down', $.proxy(this.showPanel, this));
  this.$divMainContent.on('click', '.fa-chevron-up', $.proxy(this.hidePanel, this));
  this.$btnArchive.on('click', $.proxy(this.toggleArchive, this));
  new ClipboardInput(this.$btnCopyShareLink, this.$inputShareLink);
  new ClipboardInput(this.$btnHeroCopyShareLink, this.$inputHeroShareLink);
  this.showAllPanels();
  this.highlightHero();
}

ResultsView.prototype.toggleArchive = function() {
  var isOn = this.$btnArchive.find('.btn-success').hasClass('active');

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
      this.$btnCopyShareLink.hide();
      this.$btnArchive.attr('data-original-title', 'Re-open the study');
      this.$btnArchive.tooltip('show');
    } else {
      notify.info('<strong>Study Active</strong> - Your share link is now active.');
      this.$inputShareLink.slideDown();
      this.$btnCopyShareLink.show();
      this.$btnArchive.attr('data-original-title', 'Close the study');
      this.$btnArchive.tooltip('show');
    }

  }, this)).fail($.proxy(function(jqXHR){
    notify.error(jqXHR.responseText, 'There was an error setting the Live state.');
  }, this));
}

ResultsView.prototype.loadModal = function(event) {
  var thisEl = $(event.currentTarget);
  var resultStepHashId = thisEl.attr('data-result-step-hashid');
  var timeSeconds = parseFloat(thisEl.attr('data-feeling-at-seconds') || 0);

  this.modal.load(resultStepHashId, timeSeconds);
}

ResultsView.prototype.showPanel = function(event) {
  var chevron = $(event.currentTarget);
  var panelBody = chevron.closest('.panel').find('.panel-body');

  chevron.removeClass('fa-chevron-down').addClass('fa-chevron-up');

  var timesArray = JSON.parse(panelBody.find('script').html());
  var graphId = panelBody.find('.graph').attr('id');
  panelBody.slideDown(400, $.proxy(function(){
    this.setupGraph(timesArray, graphId);
  }, this));
}

ResultsView.prototype.showAllPanels = function() {
  $('.fa-chevron-down').click();
}

ResultsView.prototype.hidePanel = function(event) {
  var chevron = $(event.currentTarget);
  var panelBody = chevron.closest('.panel').find('.panel-body');

  chevron.removeClass('fa-chevron-up').addClass('fa-chevron-down');
  panelBody.slideUp();
}

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
      "columnWidth": .75,
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
    var details = event.item.dataContext['details'];
  });
}

ResultsView.prototype.highlightHero = function() {
  window.overlay.show(this.$panelHero, true);
}
