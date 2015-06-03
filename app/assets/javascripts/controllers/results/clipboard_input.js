function ClipboardInput($button, $input) {

  $input.on('click', function() {
    this.setSelectionRange(0, this.value.length);
  });

  new ZeroClipboard($button.get()).on( "copy", $.proxy(function (event) {
    event.clipboardData.setData("text/plain", $input.val());
  }, this));

}
