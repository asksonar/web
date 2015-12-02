$(function(){

  var company_uuid = '93e4cce6-58f3-49e8-804d-c69265333490';
  var survey_uuid;

  var drawSurvey = function() {
    $('body').append($('#survey-template').html());

    $('.survey').delay(1000).slideDown('slow');

    initHandlers();
  };

  var touch = function() {

    var pad = function(number) {
      if (number < 10) {
        return '0' + number;
      }
      return number;
    };

    var date = new Date();
    var date_yyyymmdd = date.getFullYear() + '' + pad(date.getMonth() + 1) + '' + pad(date.getDate());

    $.ajax({
      type: 'POST',
      url: 'https://my-local.asksonar.com/responses/',
      data: {
        company_uuid: company_uuid,
        email: sonar.user.email,
        date_yyyymmdd: date_yyyymmdd
      },
      dataType: 'json',
      success: function(data) {
        if (data && data.uuid) {
          survey_uuid = data.uuid;
          drawSurvey();
        }
      }
    });
  };

  var submitRating = function(rating) {
    console.log('Rating: ' + rating);

    $.ajax({
      type: 'POST',
      url: 'https://my-local.asksonar.com/responses/' + survey_uuid,
      data: {
        _method: 'PATCH',
        rating: rating
      }
    });
  };

  var submitWhy = function(why) {
    console.log('Why: ' + why);

    $.ajax({
      type: 'POST',
      url: 'https://my-local.asksonar.com/responses/' + survey_uuid,
      data: {
        _method: 'PATCH',
        text: why
      }
    });
  };

  var submitDismiss = function() {
    console.log('Dismissed!');

    $.ajax({
      type: 'POST',
      url: 'https://my-local.asksonar.com/responses/' + survey_uuid,
      data: { _method: 'DELETE' }
    });
  };

  var initHandlers = function() {
    $('.survey .close').on('click', function() {
      submitDismiss();

      $('.survey-wrapper').remove();
    });

    $('.survey .likeliness div').on('click', function() {
      submitRating($(this).text());

      $('.survey .nps').hide();
      $('.survey .why').fadeIn('fast');
    });

    $('.survey .submit').on('click', function() {
      submitWhy($(this).closest('.why').find('textarea').val());

      $('.survey .why').hide();
      $('.survey .thanks').fadeIn('fast');

      $('.survey').delay(3000).slideUp(null, function() {
        $('.survey-wrapper').remove();
      });
    });

    $('.survey .nope').on('click', function() {
      $('.survey .why').hide();
      $('.survey .thanks').fadeIn('fast');

      $('.survey').delay(3000).slideUp(null, function() {
        $('.survey-wrapper').remove();
      });
    });
  };

  $(window).load(function() {
    touch();
  });

});
