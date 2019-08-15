// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require jquery-mask-plugin
// = require_tree .

$.jMaskGlobals.watchDataMask = true;

$(document).ready(function () {
    if ($('#user_phone').length) {
        $("#user_phone").on('change paste keyup', function() {
            var firstNum = $(this).val().substring(5, 6);
            if (firstNum === '9') {
                $('#user_phone').attr('data-mask', '(00) 90000-0000')
            } else {
                $('#user_phone').attr('data-mask', '(00) 0000-0000')
            }
        });
    }
});

