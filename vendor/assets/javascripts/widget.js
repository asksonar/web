$(function(){

  var company_id = document.company_id;
  var user_id = document.user_settings.email;
  var survey_uuid;

  var resizeIframe = function() {
    $(document.iframeDiv).height($('.survey').outerHeight());
  };

  var slideInIframe = function(delay, speed, callback) {
    $(document.iframeDiv).delay(delay || 0).slideDown(speed, callback);
  };

  var slideOutIframe = function(delay, speed, callback) {
    $(document.iframeDiv).delay(delay || 0).slideUp(speed, callback);
  };

  var destroyIframe = function() {
    $(document.iframeDiv).remove();
  };

  var styleIframe = function() {
    $(document.iframeDiv).css({
      'z-index': 9999998,
      'width': '420px',
      'max-width': '100%',
      'position': 'fixed',
      'bottom': 0,
      'right': 0,
      'height': '135px' // start off with it hardcoded (since is hidden), and then use resizeIframe afterwards
    });

    $(document.iframeDiv).children('iframe').css({
      'height': '100%',
      'width': '100%',
      'border': 'none'
    });
  };

  var drawSurvey = function(style_elements) {
    var company_product_name = style_elements.company_product_name || 'us';

    $('body').append("\
          <div class='survey clearfix'>\
            <div class='close'>X</div>\
            <div class='nps'>\
              <div class='text'>How likely is it that you would recommend " + company_product_name + "<br/>to a friend or colleague?</div>\
              <div class='likeliness'>\
                <div>0</div>\
                <div>1</div>\
                <div>2</div>\
                <div>3</div>\
                <div>4</div>\
                <div>5</div>\
                <div>6</div>\
                <div>7</div>\
                <div>8</div>\
                <div>9</div>\
                <div>10</div>\
              </div>\
              <span class='not-likely'>Not likely</span>\
              <span class='likely'>Very likely</span>\
            </div>\
            <div class='why' style='display:none'>\
              <div class='text'>Are there any particular reasons why?</div>\
              <textarea rows='3'></textarea>\
              <span class='submit'>Submit</span>\
              <span class='nope'>Nope</span>\
            </div>\
            <div class='thanks' style='display:none'>\
              <div>Thanks for your feedback.  We will use it to keep on improving the service for you.</div>\
            </div>\
          </div>\
      ");
    styleIframe();
    slideInIframe(1000, 'slow');

    initHandlers();
  };

  var touch = function(email) {

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
      url: 'https://my.asksonar.com/responses/',
      data: {
        company_uuid: company_id,
        email: email,
        date_yyyymmdd: date_yyyymmdd
      },
      dataType: 'json',
      success: function(data) {
        if (data && data.uuid) {
          survey_uuid = data.uuid;
          drawSurvey(data.style_elements);
        }
      }
    });
  };

  var submitRating = function(rating) {
    // console.log('Rating: ' + rating);

    $.ajax({
      type: 'POST',
      url: 'https://my.asksonar.com/responses/' + survey_uuid,
      data: {
        _method: 'PATCH',
        rating: rating
      }
    });
  };

  var submitWhy = function(why) {
    // console.log('Why: ' + why);

    $.ajax({
      type: 'POST',
      url: 'https://my.asksonar.com/responses/' + survey_uuid,
      data: {
        _method: 'PATCH',
        text: why
      }
    });
  };

  var submitDismiss = function() {
    // console.log('Dismissed!');

    $.ajax({
      type: 'POST',
      url: 'https://my.asksonar.com/responses/' + survey_uuid,
      data: { _method: 'DELETE' }
    });
  };

  var initHandlers = function() {
    $('.survey .close').on('click', function() {
      submitDismiss();

      destroyIframe();
    });

    $('.survey .likeliness div').on('click', function() {
      submitRating($(this).text());

      $('.survey .nps').hide();
      $('.survey .why').fadeIn('fast');
      resizeIframe();
    });

    $('.survey .submit').on('click', function() {
      submitWhy($(this).closest('.why').find('textarea').val());

      $('.survey .why').hide();
      $('.survey .thanks').fadeIn('fast');
      resizeIframe();

      slideOutIframe(3000, null, function() {
        destroyIframe();
      });
    });

    $('.survey .nope').on('click', function() {
      $('.survey .why').hide();
      $('.survey .thanks').fadeIn('fast');
      resizeIframe();

      slideOutIframe(3000, null, function() {
        destroyIframe();
      });
    });
  };

  touch(user_id);

});
