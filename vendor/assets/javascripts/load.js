(function() {
  var script = document.createElement('script');
  script.src='https://code.jquery.com/jquery-1.11.3.min.js';
  script.id='jquery-js';
  document.body.appendChild(script);

  var css = document.createElement('link');
  css.rel='stylesheet';
  css.href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css';
  css.id='bootstrap-css';
  document.head.appendChild(css);

  css = document.createElement('link');
  css.rel='stylesheet';
  css.href='https://assets.asksonar.com/survey.css';
  css.id='survey-css';
  document.head.appendChild(css);

  script = document.createElement('script');
  script.src='https://assets.asksonar.com/widget.js';
  script.id='widget-js';
  document.body.appendChild(script);
}());
