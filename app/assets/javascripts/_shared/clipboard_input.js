function ClipboardInput($button, $input) {

  $input.on('click', function() {
    var thisEl = this;
    window.setTimeout(function() {
      thisEl.setSelectionRange(0, thisEl.value.length);
    }, 0);

  });

  new ZeroClipboard($button.get()).on('copy', $.proxy(function(event) {
    event.clipboardData.setData('text/plain', $input.val());
    var el = $input.get(0);
    el.setSelectionRange(0, el.value.length);
  }, this));

}
