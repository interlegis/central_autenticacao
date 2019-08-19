$(document).on('turbolinks:load', function() {
    var filesInput = document.getElementById("files");
    console.log("PASOSDFASDOFIOASDOFIDS")
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
})