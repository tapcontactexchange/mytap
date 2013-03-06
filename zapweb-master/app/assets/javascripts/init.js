$(function() {
  
  $('#cards').accordion({
  	change: function(event, ui) { 
  		$("#more_info_" + ui.oldHeader.attr("id")).hide();
  		$("#more_info_" + ui.newHeader.attr("id")).show();
  	}
  });
  
  $("#more_infos").children(".more_info").first().show();
  
});