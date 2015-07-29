function WalkthroughController(view) {
  this.view = view;

}

WalkthroughController.prototype.init = function() {

}

WalkthroughController.prototype.show = function() {
  switch(window.location.search) {
    case '?walkthrough=start': this.view.showStart(); break;
    case '?walkthrough=create': this.view.showOne(); break;
    case '?template=sample&walkthrough=create': this.view.showOneBee(); break;
    case '?walkthrough=share': this.view.showTwo(); break;
    case '?walkthrough=results': this.view.showThree(); break;
  }
}
