function WalkthroughController(config, overlay, view, arrow) {
  this.$btnCreate = config.btnCreate;
  this.$btnTemplate = config.btnTemplate;
  this.$dropdownTemplate = config.dropdownTemplate;
  this.$btnPublish = config.btnPublish;
  this.$panelHero = config.panelHero;
  this.$btnCopyHero = config.btnCopyHero;
  this.$btnCopyLink = config.btnCopyLink;
  this.$linkFirstResult = config.linkFirstResult;
  this.$modal = config.modal;

  this.overlay = overlay;
  this.view = view;
  this.arrow = arrow;
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
      $(window).on('load', $.proxy(this.showShareHero, this));
      break;
    case '?walkthrough=results':
      this.overlay.showNone();
      $(window).on('load', $.proxy(this.showResults, this));
      break;
  }
}

WalkthroughController.prototype.showStart = function() {
  var target = this.overlay.showCreate();
  if (!target) {
    return;
  }

  var popup = this.view.showStart();
  this.arrow.draw(
    popup.offset().left + 10, popup.offset().top + popup.outerHeight() / 2,
    target.offset().left + target.outerWidth() + 30, target.offset().top + target.outerHeight() / 2,
    'horizontal'
  );
  this.arrow.show();

  var btnCreateHref = this.$btnCreate.attr('href');
  this.$btnCreate.attr('href', btnCreateHref + '?walkthrough=template');
}

WalkthroughController.prototype.showTemplate = function() {
  var target = this.overlay.showTemplate();
  if (!target) {
    return;
  }

  var popup = this.view.showTemplate();
  this.arrow.draw(
    popup.offset().left + popup.outerWidth() - 10, popup.offset().top + popup.outerHeight() / 2,
    target.offset().left - 30, target.offset().top + target.outerHeight() / 2,
    'horizontal'
  );
  this.arrow.show();

  this.$btnTemplate.on('shown.bs.dropdown', $.proxy(this.showDropdown, this, popup));
  this.$btnTemplate.find('.dropdown-menu li').addClass('disabled');
  this.$btnTemplate.find('.dropdown-menu').prepend("<li><a href='?template=sample&walkthrough=create'>Sample study</a></li>");
}

WalkthroughController.prototype.showDropdown = function(popup) {
  var target = this.overlay.showDropdown();
  if (!target) {
    return;
  }

  this.arrow.draw(
    popup.offset().left + popup.outerWidth() - 10, popup.offset().top + popup.outerHeight() / 2,
    target.offset().left - 30, target.offset().top + target.outerHeight() / 2,
    'horizontal'
  );
  this.arrow.show();

  this.$btnTemplate.on('hidden.bs.dropdown', $.proxy(function() {
    var target = this.overlay.show(this.$btnTemplate);
    this.arrow.draw(
      popup.offset().left + popup.outerWidth() - 10, popup.offset().top + popup.outerHeight() / 2,
      target.offset().left - 30, target.offset().top + target.outerHeight() / 2,
      'horizontal'
    );
    this.arrow.show();
  }, this));
}

WalkthroughController.prototype.showCreate = function() {
  var target = this.overlay.showPublish();
  if (!target) {
    return;
  }

  var popup = this.view.showCreate();

  this.arrow.draw(
    popup.offset().left + popup.outerWidth() / 2, popup.offset().top + popup.outerHeight() - 10,
    target.offset().left - 30, target.offset().top + target.outerHeight() / 2,
    'horizontal'
  );
  this.arrow.show();
}

WalkthroughController.prototype.showShareHero = function() {
  var target = this.overlay.showHero();
  if (!target) {
    this.showShareCopyLink();
    return;
  }

  var popup = this.view.showShare();

  target = this.$btnCopyHero;

  this.arrow.draw(
    popup.offset().left + popup.outerWidth() / 2, popup.offset().top + popup.outerHeight() - 10,
    target.offset().left + target.outerWidth() / 2, target.offset().top - 25,
    'vertical'
  );
  this.arrow.show();

  // shouldn't trigger if zeroclipboard is available
  this.$btnCopyHero.on('click', $.proxy(this.createSampleResponse, this));
  // shouldn't trigger is flash isn't available
  //new ZeroClipboard(this.$btnCopyHero.get()).on("copy", $.proxy(this.createSampleResponse, this));
}

WalkthroughController.prototype.showShareCopyLink = function() {
  var target = this.overlay.showCopyLink();
  if (!target) {
    return;
  }

  var popup = this.view.showShare();

  this.arrow.draw(
    popup.offset().left + popup.outerWidth() - 10, popup.offset().top + popup.outerHeight() / 2,
    target.offset().left - 25, target.offset().top + target.outerHeight() / 2,
    'horizontal'
  );
  this.arrow.show();

  var linkToResults = function() {
    location = new URL(location.href).pathname + '?walkthrough=results';
  }

  // shouldn't trigger if zeroclipboard is available
  this.$btnCopyLink.on('click', linkToResults);
  // shouldn't trigger is flash isn't available
  //new ZeroClipboard(this.$btnCopyLink.get()).on("copy", linkToResults);

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
  var target = this.overlay.showResults();
  if (!target) {
    return;
  }

  var popup = this.view.showResults();

  this.arrow.draw(
    popup.offset().left + popup.outerWidth() / 2, popup.offset().top + popup.outerHeight() - 10,
    target.offset().left + target.outerWidth() / 2, target.offset().top - 30,
    'vertical'
  );
  this.arrow.show();

  this.$linkFirstResult.on('click', $.proxy(this.showModal, this));
}

WalkthroughController.prototype.showModal = function() {
  this.overlay.showNone();

  this.$modal.css({
    'padding-top': '200px'
  });

  this.arrow.hide();
  var popup = this.view.showModal();

  this.$modal.on('shown.bs.modal', $.proxy(function() {
    var target = this.$modal.find('button.close');
    this.arrow.draw(
      popup.offset().left + popup.outerWidth() - 10, popup.offset().top + popup.outerHeight() / 2 ,
      target.offset().left + target.outerWidth() / 2, target.offset().top - 45,
      'vertical'
    );
    this.arrow.show();
  }, this));

  this.$modal.on('hide.bs.modal', $.proxy(this.arrow.hide, this.arrow));
  this.$modal.on('hidden.bs.modal', $.proxy(this.showFinish, this));
}

WalkthroughController.prototype.showFinish = function() {
  this.view.showFinish();

  this.arrow.hide();
}
