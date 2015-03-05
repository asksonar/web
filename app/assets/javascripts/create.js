/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){

  $('.templateHasLinks').hover(function(){
    $(this).find('.templateTitle').parent().slideUp();
  }, function(){
    $(this).find('.templateTitle').parent().slideDown();
  });

  $('.templateCustomPanel').click(function(){
    window.location.href = '/create/new?template=custom';
  });

});
