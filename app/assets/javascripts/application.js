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
//= require jquery.validate
//= require cloudinary
//= require jquery.infinitescroll
//= require jquery.textchange.min
//= require jquery.Jcrop.min
//= require jquery.royalslider.custom.min.js
//= require async
//= require numeral
//= require redactor
//= require underscore.string.min
//= require chartkick
//= require_tree .

$(document).ready(function() {
  $(document).foundation();
  $(document).trigger('foundation-initialized');

  // initialize form validation
  $('.form-validation').each(function() {
    $(this).validate();
  })

  $("a.disabled").on("click", function(e) {
    e.preventDefault();
  })
})
