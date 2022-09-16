var paginaActual = 0;

$('.contarPagina').on('click',function(){
    // if( paginaActual +1 === parseInt(document.getElementById('valorPage').value) ){
        $('.contarPagina').addClass('disabled');
    // }else{
        $('.contarPagina').removeClass('disabled');
        paginaActual = paginaActual + 1;
        paginar(paginaActual);
        console.log('pagina actual : ' + paginaActual);
    // }
});
$('.descontarPagina').on('click',function(){
    paginaActual = paginaActual - 1;
    paginar(paginaActual);
});

function pageSelected(page) {
    paginaActual = parseInt(page);
    paginar(paginaActual);
}

function paginar(page) {
    if( page + 1 === parseInt(document.getElementById('valorPage').value) ){
        $('#nextButton').addClass('disabled');
        $('#nextLink').addClass('disabled');
    }else{
        $('#nextButton').removeClass('disabled');
        $('#nextLink').removeClass('disabled');
    }
    if(page === 0){
        $('#beforeButton').addClass('disabled');
        $('#beforeLink').addClass('disabled');
    }else{
        $('#beforeButton').removeClass('disabled');
        $('#beforeLink').removeClass('disabled');
    }
    $(".linkPage").removeClass('active');
    $(".buttonPage").removeClass('active');

    document.getElementById('linkPage' + page ).classList.add('active');
    document.getElementById('page' + page ).classList.add('active');
    mostrarPagina(page);
}

function mostrarPagina(page) {
    $('.card-deck').removeClass('show');
    $('.card-deck').removeClass('active');

    document.getElementById('tab-card' + page ).classList.add('show');
    document.getElementById('tab-card' + page ).classList.add('active');
}