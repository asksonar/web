function WalkthroughView(config, overlay) {
  this.$start = config.start;
  this.$one = config.one;
  this.$oneBee = config.oneBee;
  this.$two = config.two;
  this.$three = config.three;
  this.$threeBee = config.threeBee;
  this.$finish = config.finish;

  this.$btnCreate = config.btnCreate;
  this.$btnTemplate = config.btnTemplate;
  this.$dropdownTemplate = config.dropdownTemplate;
  this.$btnPublish = config.btnPublish;
  this.$panelHero = config.panelHero;
  this.$btnCopyHero = config.btnCopyHero;
  this.$linkFirstResult = config.linkFirstResult;
  this.$modal = config.modal;

  this.overlay = overlay;

  this.init();
  this.initHandlers();
}

WalkthroughView.prototype.init = function() {
}

WalkthroughView.prototype.initHandlers = function() {
}

WalkthroughView.prototype.hidePopups = function() {
  this.$start.hide();
  this.$one.hide();
  this.$oneBee.hide();
  this.$two.hide();
  this.$three.hide();
  this.$threeBee.hide();
  this.$finish.hide();
}

WalkthroughView.prototype.showStart = function() {
  if (!this.overlay.show(this.$btnCreate)) {
    return;
  }

  this.hidePopups();
  this.$start.show();
  this.$start.find('i').popover('show');

  var btnCreateHref = this.$btnCreate.attr('href');
  this.$btnCreate.attr('href', btnCreateHref + '?walkthrough=create');
}

WalkthroughView.prototype.showOne = function() {
  if (!this.overlay.show(this.$btnTemplate)) {
    return;
  }

  this.hidePopups();
  this.$one.show();
  this.$one.find('i').popover('show');

  this.prepShowOneAy();
}

WalkthroughView.prototype.prepShowOneAy = function() {
  this.$btnTemplate.on('shown.bs.dropdown', $.proxy(this.showOneAy,this));
  this.$btnTemplate.find('.dropdown-menu li').addClass('disabled');
  this.$btnTemplate.find('.dropdown-menu').prepend("<li><a href='?template=sample&walkthrough=create'>Sample study</a></li>");
}

WalkthroughView.prototype.showOneAy = function() {
  if (!this.overlay.show(this.$btnTemplate.find('ul li:first-child'))) {
    return;
  }

  // awaiting page load
  this.$btnTemplate.on('hidden.bs.dropdown', $.proxy(function() {
    this.overlay.show(this.$btnTemplate);
  }, this));
}

WalkthroughView.prototype.showOneBee = function() {
  if (!this.overlay.show(this.$btnPublish)) {
    return;
  }

  this.hidePopups();
  this.$oneBee.show();
  this.$oneBee.find('i').popover('show');
}

WalkthroughView.prototype.showTwo = function() {
  if (!this.overlay.show(this.$panelHero)) {

  }

  this.hidePopups();
  this.$two.show();
  this.$two.find('i').popover('show');

  new ZeroClipboard(this.$btnCopyHero.get()).on( "copy", $.proxy(this.createSampleResponse, this));
}

WalkthroughView.prototype.createSampleResponse = function() {
  $.ajax({
    type: 'POST',
    url: new URL(window.location.href).pathname,
    data: {
      _method: 'PATCH',
      walkthrough: true,
      authenticity_token: AUTH_TOKEN
    }
  }).success(function() {
    location = new URL(location.href).pathname + '?walkthrough=results';
  }).fail(function(jqXHR) {
    notify.error(jqXHR.responseText, 'There was an error retrieving the sample response.');
  });
}

WalkthroughView.prototype.showThree = function() {
  this.hidePopups();
  this.$three.show();
  this.$three.find('i').popover('show');
  this.overlay.show(this.$linkFirstResult);

  this.prepShowThreeBee();
}

WalkthroughView.prototype.prepShowThreeBee = function() {
  this.$linkFirstResult.on('click', $.proxy(this.showThreeBee, this));
}

WalkthroughView.prototype.showThreeBee = function() {
  this.$modal.css({
    'padding-top': '200px'
  });
  this.hidePopups();
  this.$threeBee.show();
  this.$threeBee.find('i').popover('show');
  this.overlay.coverAll();

  this.prepShowFinish();
}

WalkthroughView.prototype.prepShowFinish = function() {
  this.$modal.on('hidden.bs.modal', $.proxy(this.showFinish, this));
}

WalkthroughView.prototype.showFinish = function() {
  this.hidePopups();
  this.$finish.show();
  this.$finish.find('i').popover('show');
  this.overlay.coverAll();
}


