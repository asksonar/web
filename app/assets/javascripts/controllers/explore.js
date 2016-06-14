$(function(){
  if ($('#explore-index').length === 0) {
    return;
  }
  
  var renderers = $.extend(
    $.pivotUtilities.renderers,
    $.pivotUtilities.gchart_renderers,
    $.pivotUtilities.export_renderers
  );

  $("#output").pivotUI(
    input, {
      rows: ["Aircraft Type", "Aircraft Series"],
      cols: ["Aircraft Status"],
      menuLimit: 2000,
      renderers: renderers,
      derivedAttributes: {
        "Age": function(record) {
          if (record["Build Year"] > 2013) {
            return "Under 3 years";
          } else if (record["Build Year"] <= 2013 && record["Build Year"] > 2006) {
            return "3-10 years";
          } else {
            return "10+ years";
          }
        }
      }
    }
  );

});
