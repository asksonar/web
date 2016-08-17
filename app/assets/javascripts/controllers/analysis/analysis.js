$(function(){
  if ($('#analysis-index').length === 0) {
    return;
  }

  var pivotParams = JSON.parse(pivot_params);

  var pivotTable = new PivotTable({
    pivotContainer: $("#pivot-container"),
    btnSaveImg: $('#btn-save-img')
  }, pivotParams);

  var analysisController = new AnalysisController({
    renderersSelect: $('.selectpicker.renderers'),
    aggregatorsSelect: $('.selectpicker.aggregators'),
    attributesSelect: $('.selectpicker.attributes'),
    ctnSelectedAttributes: $('.ctn-selected-attributes'),
    filterAttributes: $('.ctn-selected-attributes #filters'),
    rowAttributes: $('.ctn-selected-attributes #rows'),
    columnAttributes: $('.ctn-selected-attributes #columns'),
    availableAttributes: $('.ctn-available-attributes #available'),
    btnUpdateFilter: $('.btn-update-filter'),
    btnSelectAll: $('.btn-select-all'),
    btnSelectNone: $('.btn-select-none'),
    inputFilter: $('.pvtSearch')
  }, pivotTable);

  var analysisView = new AnalysisView({
    btnSaveView: $('#btn-save-view'),
    inputSaveView: $('#input-save-view'),
    divSavedViews: $('.saved-views'),
    deleteModal: $('#delete-with-ajax'),
    btnDeleteYes: $('#btn-delete-yes')
  }, analysisController);

});
