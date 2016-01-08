$(function(){
  if ($('#send-show').length === 0) {
    return;
  }

  $('#survey_settings_email_followup_enabled').on('click', function() {
    if ($(this).prop('checked')) {
      $('.email_followup').removeClass('disabled');
      $('#survey_settings_email_followup').prop('disabled', false);
    } else {
      $('.email_followup').addClass('disabled');
      $('#survey_settings_email_followup').prop('disabled', true).val('');
    }
  });

  $("input[name='survey_settings[survey_type]']").on('click', function() {
    if ($(this).val() === 'inapp') {
      $('.email_followup').removeClass('hidden');
    } else {
      $('.email_followup').addClass('hidden');
    }
  });
});
