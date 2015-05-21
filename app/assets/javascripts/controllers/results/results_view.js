function ResultsView(config, modal) {
  this.$divMainContent = config.divMainContent;
  this.$btnCopyShareLink = config.btnCopyShareLink;
  this.$inputShareLink = config.inputShareLink;
  this.$btnArchive = config.btnArchive;

  this.modal = modal;

  this.init();
}

ResultsView.prototype.init = function() {
  this.$divMainContent.on('click', '.fa-chevron-down', $.proxy(this.showPanel, this));
  this.$divMainContent.on('click', '.fa-chevron-up', $.proxy(this.hidePanel, this));
  this.$divMainContent.on('click', '.feeling', $.proxy(this.loadModal, this));
  this.$btnArchive.on('click', $.proxy(this.toggleArchive, this));
  new ClipboardInput(this.$btnCopyShareLink, this.$inputShareLink);
}

ResultsView.prototype.toggleArchive = function() {
  this.$btnArchive.find('.btn').toggleClass('active');
}

ResultsView.prototype.loadModal = function(event) {
  var thisEl = $(event.target);
  var scenarioStepId = thisEl.attr('data-scenario-step-id');
  var scenarioResultId = thisEl.attr('data-scenario-result-id');
  var timeSeconds = parseFloat(thisEl.attr('data-feeling-at-seconds') || 0) - 5;

  this.modal.load(scenarioStepId, scenarioResultId, timeSeconds);
}

ResultsView.prototype.showPanel = function(event) {
  var chevron = $(event.target);
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
  var chevron = $(event.target);
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
