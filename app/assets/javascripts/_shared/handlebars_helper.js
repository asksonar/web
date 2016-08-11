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

  Handlebars.registerHelper('if_equal', function(val1, val2, options) {
    if ( val1 === val2 ) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  });

  Handlebars.registerHelper('if_one_equal', function() {
    var found = false;
    var args = [].slice.apply(arguments);
    var val = args.shift();
    var ops = args.pop();

    for (var i = 0; i < args.length; i++) {
      if (val === args[i]) {
        found = true;
        break;
      }
    }

    if ( found ) {
      return ops.fn(this);
    } else {
      return ops.inverse(this);
    }
  });

  Handlebars.registerHelper('titleize', function(str) {
    var strArray = str.split('_');
    strArray = strArray.map(function(str) {
      return str.charAt(0).toUpperCase() + str.slice(1);
    })
    return strArray.join(' ');
  });

  Handlebars.registerHelper('human_attribute_name', function(attribute) {
    var defaults = {
      "msn": "MSN",
      "aircraft_manufacturer": "Manufacturer"
    };

    if (defaults[attribute]) {
      return defaults[attribute];
    } else {
      var str = attribute.split('_').join(' ');
      return str.charAt(0).toUpperCase() + str.slice(1);
    }
  });
});
