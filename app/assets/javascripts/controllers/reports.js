$(function(){
  if ($('#reports-index').length === 0) {
    return;
  }

  $('#btn-add-filter').on('click', function() {
    var sub_filter = $('#select-aircraft-type').val();
    var filters = { "aircraft_type": [sub_filter] };
    window.location.href = new URI(window.location.href).addSearch(filters);
  })
});
