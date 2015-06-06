// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//
//= require_tree .
//= require jquery
//= require s3_direct_upload

$(document).on('ready page:load', function(){

	$("#s3-uploader").S3Uploader();
	$('#s3-uploader').bind("ajax:success", function(e, data) {
  		//alert("server was notified of new file on S3; responded with '#{data}");
	});


    // run test on initial page load
    checkSize();
    $("#profile_section").hover(
    	function() {
	    	$("#expanded_user_menu").stop().toggle('fast');

		},
		function() {
	    	$("#expanded_user_menu").stop().toggle('fast');
		}

	);
    // run test on resize of the window
    $(window).resize(checkSize);

});



//Function to the css rule
function checkSize(){
    if ($(".screen-size").css("width") == "1px" ){
        $('.show-for-medium-up').remove();
    }
    if ($(".screen-size").css("width") == "2px" ){
        $('.show-for-small').remove();
    }
}
$(function(){ $(document).foundation(); });
