//= require validations

$(function(){
    var newUserForm;
    newUserForm = $("#new_user");
    var loginForm;
    loginForm = $(".loginForm");
    newUserForm.validation();
    loginForm.validation();
});