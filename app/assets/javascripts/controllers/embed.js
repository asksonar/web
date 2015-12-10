$(function(){
  if ($('#embed-index').length === 0) {
    return;
  }

  $('#btn-toggle-minified').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $('.snippet').hide();
      $('.snippet.minified').fadeIn('fast');
    } else {
      $(this).addClass('active');
      $('.snippet').hide();
      $('.snippet.unminified').fadeIn('fast');
    }
  });

  new ZeroClipboard($('#btn-copy-snippet').get())
    .on("copy", function (event) {
      var node = $('.snippet:visible')[0];
      event.clipboardData.setData('text/plain', node.textContent || node.innerText);
    })
    .on("aftercopy", function (event) {
      $('#btn-copy-snippet').tooltip('show');
      setTimeout(function() {
        $('#btn-copy-snippet').tooltip('hide');
      }, 1000);
    });

});
