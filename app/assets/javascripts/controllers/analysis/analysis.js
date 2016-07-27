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
    rowAttributes: $('.ctn-selected-attributes #rows'),
    columnAttributes: $('.ctn-selected-attributes #columns'),
    btnUpdateFilter: $('.btn-update-filter'),
    btnSelectAll: $('.btn-select-all'),
    btnSelectNone: $('.btn-select-none'),
    inputFilter: $('.pvtSearch'),
    filterAttributes: $('.pvtCheckContainer p')
  }, pivotTable);

});
