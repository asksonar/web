function WalkthroughController(config, overlay, view) {
  this.$btnCreate = config.btnCreate;
  this.$btnTemplate = config.btnTemplate;
  this.$dropdownTemplate = config.dropdownTemplate;
  this.$btnPublish = config.btnPublish;
  this.$panelHero = config.panelHero;
  this.$btnCopyHero = config.btnCopyHero;
  this.$linkFirstResult = config.linkFirstResult;
  this.$modal = config.modal;

  this.overlay = overlay;
  this.view = view;
}

WalkthroughController.prototype.init = function() {

}

WalkthroughController.prototype.show = function() {

  switch(window.location.search) {
    case '?walkthrough=start':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showStart, this));
      break;
    case '?walkthrough=template':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showTemplate, this));
        break;
    case '?template=sample&walkthrough=create':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showCreate, this));
      break;
    case '?walkthrough=share':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showShare, this));
      break;
    case '?walkthrough=results':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showResults, this))
      break;
  }
}

WalkthroughController.prototype.showStart = function() {
  if (!this.overlay.showCreate()) {
    return;
  }

  this.view.showStart();

  var btnCreateHref = this.$btnCreate.attr('href');
  this.$btnCreate.attr('href', btnCreateHref + '?walkthrough=template');
}

WalkthroughController.prototype.showTemplate = function() {
  if (!this.overlay.showTemplate()) {
    return;
  }

  this.view.showTemplate();

  this.$btnTemplate.on('shown.bs.dropdown', $.proxy(this.showDropdown,this));
  this.$btnTemplate.find('.dropdown-menu li').addClass('disabled');
  this.$btnTemplate.find('.dropdown-menu').prepend("<li><a href='?template=sample&walkthrough=create'>Sample study</a></li>");
}

WalkthroughController.prototype.showDropdown = function() {
  if (!this.overlay.showDropdown()) {
    return;
  }

  this.$btnTemplate.on('hidden.bs.dropdown', $.proxy(function() {
    this.overlay.show(this.$btnTemplate);
  }, this));
}

WalkthroughController.prototype.showCreate = function() {
  if (!this.overlay.showPublish()) {
    return;
  }

  this.view.showCreate();
}

WalkthroughController.prototype.showShare = function() {
  if (!this.overlay.showHero()) {
    return;
  }

  this.view.showShare();

  // shouldn't trigger if zeroclipboard is available
  this.$btnCopyHero.on('click', $.proxy(this.createSampleResponse, this));
  // shouldn't trigger is flash isn't available
  new ZeroClipboard(this.$btnCopyHero.get()).on( "copy", $.proxy(this.createSampleResponse, this));
}

WalkthroughController.prototype.createSampleResponse = function() {
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

WalkthroughController.prototype.showResults = function() {
  if (!this.overlay.showResults()) {
    return;
  }

  this.view.showResults();

  this.$linkFirstResult.on('click', $.proxy(this.showModal, this));
}

WalkthroughController.prototype.showModal = function() {
  this.overlay.showNone();

  this.$modal.css({
    'padding-top': '200px'
  });

  this.view.showModal();

  this.$modal.on('hidden.bs.modal', $.proxy(this.showFinish, this));
}

WalkthroughController.prototype.showFinish = function() {
  this.view.showFinish();
}
