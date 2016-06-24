$(function(){
  if ($('#fleets-index').length === 0) {
    return;
  }

  $('[data-submenu]').submenupicker();

  var datatableFilters = new DatatableFilters({
    newFleetTemplate: $('#new-fleet-template'),
    fleetTable: $('.fleet-table'),
    fleetTableBody: $('.fleet-table tbody'),
    filterContainer: $('.filter-container'),
    btnExportCsv: $('#btn-export-csv'),
    resultCount: $('#result-count'),
    ctnDisplayCountSelect: $('#select-display-count'),
    displayCountSelect: $('#select-display-count a'),
    inputCheckbox: $('.filter input[type="checkbox"]'),
    filtersSelect: $('nav .selectpicker')
  });

  var datatableController = new DatatableController({
    btnEditMode: $('#btn-edit-mode'),
    btnEditColumn: $('.btn-edit-column'),
    btnMoveLeft: $('.btn-move-left'),
    btnMoveRight: $('.btn-move-right'),
    columnHeader: $('.column-header')
  });

  $('.collapse').on('hide.bs.collapse', function(){
    var id = $(this).attr('id');
    $('li[href="#' + id + '"]').find(".glyphicon-chevron-down")
      .removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-right");
  }).on('show.bs.collapse', function(){
    var id = $(this).attr('id');
    $('li[href="#' + id + '"]').find(".glyphicon-chevron-right")
      .removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-down");
  })

  $('.div-collapse-sidebar .glyphicon').on('click', function() {
    $('#main-wrapper').toggleClass('sidebar-collapsed');
    $('#btn-expand-sidebar').toggleClass('hide');
    $('.main-content-header').css("padding-left", "0px");
  });

  $('#btn-expand-sidebar').on('click', function() {
    $('#main-wrapper').toggleClass('sidebar-collapsed');
    $('#btn-expand-sidebar').toggleClass('hide');
    $('.main-content-header').css("padding-left", "40px");
  })

});
