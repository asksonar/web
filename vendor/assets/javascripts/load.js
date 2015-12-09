(function() {
  var loadJS = function(path) {
    var xhrObj = new XMLHttpRequest();
    xhrObj.open('GET', path, false);
    xhrObj.send(null);
    eval(xhrObj.responseText);
  };

  var loadCSS = function(path) {
    var css = document.createElement('link');
    css.rel='stylesheet';
    css.href=path;
    css.id='bootstrap-css';
    document.head.appendChild(css);
  };

  loadCSS('https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css');
  loadCSS('https://s3-us-west-1.amazonaws.com/assets.asksonar.com/survey.css');

  loadJS('https://code.jquery.com/jquery-1.11.3.min.js');
  loadJS('https://s3-us-west-1.amazonaws.com/assets.asksonar.com/widget.js');
}());
