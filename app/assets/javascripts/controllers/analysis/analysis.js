$(function(){
  if ($('#analysis-index').length === 0) {
    return;
  }

  var rowArray = ["Aircraft Model"];
  var colArray = ["Aircraft Status"];

  var pivotTable = new PivotTable({
    pivotContainer: $("#pivot-container"),
    btnSaveImg: $('#btn-save-img')
  }, rowArray, colArray);

  var analysisController = new AnalysisController({
    renderersSelect: $('.selectpicker.renderers'),
    aggregatorsSelect: $('.selectpicker.aggregators'),
    attributesSelect: $('.selectpicker.attributes'),
    ctnSelectedAttributes: $('.ctn-selected-attributes'),
    btnUpdateFilter: $('.btn-update-filter'),
    btnSelectAll: $('.btn-select-all'),
    btnSelectNone: $('.btn-select-none')
  }, pivotTable);

});
