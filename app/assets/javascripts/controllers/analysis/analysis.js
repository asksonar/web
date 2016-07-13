$(function(){
  if ($('#analysis-index').length === 0) {
    return;
  }

  var utils = $.pivotUtilities;

  var table =  utils.renderers["Table"];
  var tableBarChart =  utils.renderers["Table Barchart"];
  var heatmap =  utils.renderers["Heatmap"];
  var colHeatmap =  utils.renderers["Col Heatmap"];
  var rowHeatMap =  utils.renderers["Row Heatmap"];
  var areaChart =  utils.renderers["Area Chart"];
  var barChart =  utils.renderers["Bar Chart"];
  var lineChart =  utils.renderers["Line Chart"];
  var scatterChart =  utils.renderers["Scatter Chart"];
  var stackedBarChart =  utils.renderers["Stacked Bar Chart"];

  var count =  utils.aggregators["Count"];
  var countUnique =  utils.aggregators["Count Unique Values"];
  var listUnique =  utils.aggregators["List Unique Values"];
  var sum =  utils.aggregators["Sum"];
  var intergerSum =  utils.aggregators["Integer Sum"];
  var average =  utils.aggregators["Average"];
  var mini =  utils.aggregators["Minimum"];
  var max =  utils.aggregators["Maximum"];

  var rowArray = ["Aircraft Model", "Aircraft Version"];
  var colArray = ["Aircraft Status"];

  var pivotTable = new PivotTable({
    pivotContainer: $("#pivot-container")
  }, rowArray, colArray);

  var analysisController = new AnalysisController({
    navSubContainer: $('.nav-sub-container'),
    renderersInputRadio: $('.renderers input[type="radio"]'),
    aggregatorsInputRadio: $('.aggregators input[type="radio"]'),
    aggregatorSelect: $('nav .selectpicker'),
  }, pivotTable);

});
