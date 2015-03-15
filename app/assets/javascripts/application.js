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
//= require jquery-ui
//= require gritter
//= require jquery.infinitescroll.min
//= require chat
//= require form
//= require jquery.form
//= require jquery.magnific-popup
//= require jquery.remodal
//= require jquery.serializeJson
//= require jquery.tokeninput
//= require popover
//= require post

$(document).ready(function() {
  $('.infinity-scroll').infinitescroll({
    loading: { msgText: '', finishedMsg: '' },
    navSelector : '#page_nav',
    nextSelector : '#page_nav a',
    itemSelector : '.infinity-scroll .infinity-item'
  });

  $('.modal').remodal();
});

$(document).on('ready page:load', function(){
  $("a[rel=popover]").popover({html:true}).click(function(e) {
    e.preventDefault()
  });
});

$(document).on('mouseenter', ".close-js", function () {
  $(this).find(".on-hover").first().show();
}).on('mouseleave', ".close-js", function () {
  $(this).find(".on-hover").first().hide();
});

$(document).on("keydown", "textarea", function (event) {
  if (event.keyCode === 13 && event.ctrlKey) {
    $(this).val(function(i,val) {
        return val + "\n";
    });
  }
}).on("keypress", "textarea", function(event) {
  if (event.keyCode === 13 && !event.ctrlKey) {
    $(this).closest('form').find(".btn").click();
    return false;  
  } 
});

$(document).on('mouseenter', ".zoom-gallery", function() {
  $('.zoom-gallery').magnificPopup({
    delegate: 'a',
    type: 'image',
    closeOnContentClick: false,
    closeBtnInside: false,
    mainClass: 'mfp-with-zoom mfp-img-mobile',
    image: {
      verticalFit: true,
      titleSrc: function(item) {
        return;
      }
    },
    gallery: {
      enabled: true
    },
    zoom: {
      enabled: true,
      duration: 300, // don't foget to change the duration also in CSS
      opener: function(element) {
        return element.find('img');
      }
    }
  });  
});

$(document).on('click', ".type", function() {
   $(".type").removeClass("current");
   $(this).addClass( "current" );
});
