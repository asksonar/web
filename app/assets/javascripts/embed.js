window.asksonar = window.asksonar || {};
asksonar.load = asksonar.load || function(user_settings) {
  var iframe = document.createElement("iframe");
  iframe.src = 'javascript:false';
  iframe.async = true;

  var iframeDiv = document.createElement('div');
  iframeDiv.style.cssText = 'display:none;';
  iframeDiv.appendChild(iframe);

  document.documentElement.appendChild(iframeDiv);

  var iframeDocument = iframe.contentWindow.document;
  iframeDocument.open();
  iframeDocument.loadScript = function() {
    this.company_id = '93e4cce6-58f3-49e8-804d-c69265333490';
    this.user_settings = user_settings;
    this.iframeDiv = iframeDiv;

    var script = this.createElement('script');
    script.src='https://my-local.asksonar.com/assets/load.js';
    script.id='embed-load-js';
    this.body.appendChild(script);
  };
  iframeDocument.write("<body onload='document.loadScript();''>");
  iframeDocument.close();
};

asksonar.load({email: sonar.user.email});
