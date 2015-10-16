var bsh = bsh || {};

bsh.addError = function($inputEl, errorMessage) {
  var $formGroup = $inputEl.closest('.form-group');
  $formGroup.addClass('has-error');
  var $helpBlock = $formGroup.find('.help-block');
  if ($helpBlock.length === 0) {
    $formGroup.append("<span class='help-block'></span>");
    $helpBlock = $formGroup.find('.help-block');
  }
  $helpBlock.text(errorMessage);
};

bsh.removeError = function($inputEl) {
  var $formGroup = $inputEl.closest('.form-group');
  $formGroup.removeClass('has-error');
  var $helpBlock = $formGroup.find('.help-block');
  $helpBlock.remove();
};
