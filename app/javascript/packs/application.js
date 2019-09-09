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

// Verifica CEP e preenche campos automático
function verificaCEP(){
    let cep_el=$('#user_cep');
    if (cep_el.length) {
        cep_el.on('change paste keyup', function() {
            let cep = cep_el.val();

            cep = cep.replace(/\D/g, '');

            $.get("/users/cep?cep=" + cep, function (data, status, xhr) {

                if (xhr.status != 200 || data.erro == true) {
                    $(cep_el).removeClass('is-valid').addClass('is-invalid');
                } else {
                    $(cep_el).removeClass('is-invalid').addClass('is-valid');
                    $('#user_state').val(data.uf);
                    $('#user_city').val(data.localidade);
                    $('#user_address').val(data.logradouro + ' ' + data.bairro);
                }
            });
        });
    }
}

$(document).ready(function () {
    $('#user_cpf').mask('000.000.000-00');
    $('#user_birth_date').mask('00/00/0000');
    $('#user_cep').mask('00000-000');
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
    verificaCEP();
});

$(document).on('turbolinks:load', function() {
    let filesInput = $("#files");
    if (filesInput.length) {
        filesInput.addEventListener("change", function (event) {
            var files = event.target.files; //FileList object

            for (var i = 0; i < files.length; i++) {
                var file = files[i];

                if (!file.type.match('image')) {
                    var div = document.getElementById('imagem');
                    div.style.maxWidth = '0px';
                    div.style.maxHeight = '0px';
                    div.src = '';
                    break;
                }

                var picReader = new FileReader();

                picReader.addEventListener("load", function (event) {
                    var picFile = event.target;
                    var div = document.getElementById('imagem');
                    div.style.maxWidth = '200px';
                    div.style.maxHeight = '200px';
                    div.src = '' + picFile.result + '';
                });

                picReader.readAsDataURL(file);
            }

        });
        verificaCEP();
    }
});