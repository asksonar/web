$(function(){
  if ($('#view-show').length === 0) {
    return;
  }

  var viewSettings = new ViewSettings({
    survey_settings: $('#survey_settings_style_elements')
  });

  viewSettings.init();
});
