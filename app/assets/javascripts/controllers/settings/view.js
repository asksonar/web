$(function(){
  if ($('#view-show').length === 0) {
    return;
  }

  var viewSettings = new ViewSettings({
    companyProductName: $('.company-product-name')
  });

  viewSettings.init();
});
