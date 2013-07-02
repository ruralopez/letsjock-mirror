//= require validations

$(function(){
    $("#button-facebook-login").click(function(e){
        e.preventDefault();
        window.location.href='/auth/facebook';
    });

});