function ClipboardInput($button, $input) {

  $input.on('click', function() {
    this.setSelectionRange(0, this.value.length);
  });

  new ZeroClipboard($button.get()).on( "copy", $.proxy(function (event) {
    event.clipboardData.setData("text/plain", $input.val());
    var el = $input.get(0);
    el.setSelectionRange(0, el.value.length);
  }, this));

}
