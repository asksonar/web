$(function(){
  if ($('#analysis-wb').length === 0) {
    return;
  }

  var fieldMap = {
    "id": "Id",
    "aircraft_status": "Aircraft Status",
    "aircraft_type": "Aircraft Type",
    "serial_number": "Serial Number",
    "build_year": "Build Year",
    "operator": "Operator",
    "aircraft_series": "Aircraft Series",
    "aircraft_manufacturer": "Manufacturer",
    "aircraft_age": "Aircraft Age"
  };

  webix.ui({
    container: "pivot-table",
    id: "pivot-table",
    view: "pivot",
    height: 1500,
    max: true,
    fieldMap: fieldMap,
    data: input,
    structure: {
      rows: ["aircraft_type", "aircraft_series"],
      columns: [{ id: "aircraft_status", sort: "string" }],
      values: [{ name: "serial_number", operation: "count" }],
      filters: [{ name: "operator", type: "select" }, { name: "build_year", type: "text" }]
    }
  });

  webix.ui({
    container:"pivot-chart",
    id:"pivot-chart",
    view:"pivot-chart",
    height: 500,
    fieldMap: fieldMap,
    data: input,
    structure:{
      rows: ["aircraft_type", "aircraft_series"],
      groupBy: "aircraft_status",
      values: [{ name: "serial_number", operation: "count" }],
      filters:[{ name: "operator", type: "select" }, { name: "build_year", type: "text" }]
    },
    chartType: "bar",
		chart: {
			barWidth: 25,
			legend: {
				layout: "x",
				align: "center",
				valign: "bottom"
			}
		},
    chartMap: {
      "Area Chart": function(color){
        return {
         type: "area"
        }
      }
    }
  });

  // $$("pivot-chart").$$("toolbar").hide();
  $$("pivot-table").$$("data").data.attachEvent("onStoreUpdated",function() {
    var tableValues = webix.copy($$("pivot-table").config.structure.values);
    var column = $$("pivot-table").config.structure.columns.slice(-1);
    var filters= webix.copy($$("pivot-table").config.structure.filters);

    $$("pivot-chart").define("structure", {
      values: tableValues,
      groupBy: column[0]["id"] || column,
      filters: filters
    });

    if($$("pivot-chart").data.count())
      $$("pivot-chart").data.refresh();
    else
      $$("pivot-chart").parse($$("pivot-table").data.getRange());
    }
  );

});
