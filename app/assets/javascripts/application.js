// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery/jquery-2.1.1.js
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require chosen/chosen.jquery.js
//= require slimscroll/jquery.slimscroll.min.js
//= require inspinia.js
//= require jquery.raty
//= require ratyrate

$( document ).ready(function() {
  $("#btnNewsLetter").click(function(){
    $('#succss_msg').html('');
    if (typeof(AUTH_TOKEN) == "undefined") return;
        var email = $('#news_letter_email').val();
        $.ajax({
            type: "POST",
            url: "/news_letters?authenticity_token=" + encodeURIComponent( AUTH_TOKEN )+'&email='+email,
            dataType: "script",
            success: function (data) {
                //alert(data);
            },
            error: function (data) {
                //alert(data);
            }
        });
    });
    
    
  })