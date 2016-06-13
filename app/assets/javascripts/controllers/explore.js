$(function(){
  if ($('#explore-index').length === 0) {
    return;
  }

  webix.ui({
    popup:{
  		width:800, height:600
  	},
    view: "pivot",
    fieldMap: { "id": "Id", "aircraft_status": "Aircraft Status", "aircraft_type": "Aircraft Type", "serial_number": "Serial Number", "build_year": "Build Year", "operator": "Operator", "aircraft_series": "Aircraft Series", "aircraft_manufacturer": "Manufacturer", "aircraft_age": "Aircraft Age" },
    height: 500,
    container: "testA",
    id: "pivot",
    data: input,
    max: true,
    structure: {
      rows: ["aircraft_type", "aircraft_series"],
      columns: [{ id: "aircraft_status", sort: "string"}],
      values: [{ name: "serial_number", operation: "count" }],
      filters: [{ name: "operator", type: "select" }, { name: "build_year", type: "text" }]
    }
  });

});
