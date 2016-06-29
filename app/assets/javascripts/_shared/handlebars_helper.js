$(function(){
  Handlebars.registerHelper('pp_plural', function(number, text) {
    if (number == 1) {
      return text;
    } else {
      return text + 's';
    }
  });

  Handlebars.registerHelper('pp_plural_with_number', function(number, text) {
    if (number == 1) {
      return new Handlebars.SafeString(number + ' ' + text);
    } else {
      return new Handlebars.SafeString(number + ' ' + text + 's');
    }
  });

  Handlebars.registerHelper('get_object_value_with_key', function(object, key) {
    return object[key];
  });
});
