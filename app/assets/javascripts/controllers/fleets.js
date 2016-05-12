$(function(){
  if ($('#fleets-index').length === 0) {
    return;
  }

  var databaseFilters = new DatabaseFilters({
    btnSelect: $('.selectpicker'),
    btnSelectSubFilters: $('#select-sub-filters'),
    btnSelectMainFilters: $('#select-main-filters'),
    btnAddFilter: $('#btn-add-filter')
  });

});
