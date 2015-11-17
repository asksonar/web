$(function(){

  if (sonar.request.controller !== 'feedback') {
    return;
  }

  window.extension = new ExtensionController(sonar.chrome_app_id);
  window.view = new FeedbackView({
    btnRecordFeedback: $('#btn-record-feedback'),
  }, extension);

});
