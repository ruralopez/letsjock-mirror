//= require validations

$(function(){
    $("#button-facebook-login").click(function(){
        window.location.href='/auth/facebook';
    });

    var newUserForm;
    newUserForm = $("#new_user");
    var loginForm;
    loginForm = $(".form-login");
    newUserForm.validation();
    loginForm.validation();

});