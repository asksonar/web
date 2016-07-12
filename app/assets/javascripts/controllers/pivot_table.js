PivotTable = function(config, rowArrays, colArrays) {
  this.$pivotContainer = config.pivotContainer;
  this.rowArrays = rowArrays;
  this.colArrays = colArrays;

  this.chartAreaSize = {};

  this.utils = $.pivotUtilities;
  this.renderers = this.utils.renderers;
  this.gchartRenderers = this.utils.gchart_renderers;
  this.aggregators = this.utils.aggregators;

  this.table =  this.renderers["Table"];
  this.tableBarChart =  this.renderers["Table Barchart"];
  this.heatmap =  this.renderers["Heatmap"];
  this.colHeatmap =  this.renderers["Col Heatmap"];
  this.rowHeatMap =  this.renderers["Row Heatmap"];
  this.areaChart =  this.gchartRenderers["Area Chart"];
  this.barChart =  this.gchartRenderers["Bar Chart"];
  this.lineChart =  this.gchartRenderers["Line Chart"];
  this.scatterChart =  this.gchartRenderers["Scatter Chart"];
  this.stackedBarChart =  this.gchartRenderers["Stacked Bar Chart"];

  this.count =  this.aggregators["Count"];
  this.countUnique =  this.aggregators["Count Unique Values"];
  this.listUnique =  this.aggregators["List Unique Values"];
  this.sum =  this.aggregators["Sum"];
  this.intergerSum =  this.aggregators["Integer Sum"];
  this.average =  this.aggregators["Average"];
  this.mini =  this.aggregators["Minimum"];
  this.max =  this.aggregators["Maximum"];

  this.init();
};

PivotTable.prototype.init = function() {
  this.$pivotContainer.pivot(
    data, {
      rows: this.rowArrays,
      cols: this.colArrays,
      renderer: this.table
    }
  );

  this.refreshChartAreaSize();
};

PivotTable.prototype.refreshChartAreaSize = function() {
  this.chartAreaSize.width = $('#pivotHolder .pvtRendererArea').width() - 50;
  this.chartAreaSize.height = $('#pivotHolder .pvtRendererArea').width() / 2;
};
