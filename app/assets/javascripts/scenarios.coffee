# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`
$(document).ready(function(){
	
	var templateNewStep = "<li><input type='text' name='steps[]'></input>&nbsp;<button type='button' class='btnCancelNewStep'>X</button></li>";

	$('#btnAddNewStep').click(function(event){
		$('#divNewSteps').append(templateNewStep);
	});

	$('#divNewSteps').on('click', '.btnCancelNewStep', function(event){
		$(this).parent().remove();
	});

});
`