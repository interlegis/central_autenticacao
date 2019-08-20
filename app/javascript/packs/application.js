/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker')

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("jquery");
import '../src/application'


$(document).ready(function () {
    $('#user_cpf').mask('000.000.000-00');
    $('#user_birth_date').mask('00/00/0000');
    if ($('#user_phone').length) {
        $("#user_phone").on('change paste keyup', function() {
            var firstNum = $(this).val().substring(5, 6);
            if (firstNum === '9') {
                $('#user_phone').mask('(00) 90000-0000')
            } else {
                $('#user_phone').mask('(00) 0000-0000')
            }
        });
    }
});

$(document).on('turbolinks:load', function() {
    var filesInput = document.getElementById("files");
    filesInput.addEventListener("change", function(event){
        var files = event.target.files; //FileList object
        var output = document.getElementById("result");

        for(var i = 0; i< files.length; i++)
        {
            var file = files[i];
            //Only pics
            if(!file.type.match('image')){
                div = document.getElementById('imagem');
                div.style.maxWidth = '0px';
                div.style.maxHeight = '0px';
                div.src='';
                break;
            }

            var picReader = new FileReader();

            picReader.addEventListener("load",function(event){
                var picFile = event.target;
                div = document.getElementById('imagem');
                div.style.maxWidth = '200px';
                div.style.maxHeight = '200px';
                div.src=''+picFile.result+'';
            });

            picReader.readAsDataURL(file);
        }

    });
});