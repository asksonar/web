$(function(){
  if ($('#view-show').length === 0) {
    return;
  }

  var viewSettings = new ViewSettings({
    survey_settings: $('.edit_survey_settings')
  });


  viewSettings.init();
});
