//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.purr

var currentPageNotification = 1;
var intervalID = -1000;

function getNotifications() {
    currentPageNotification++;
    jQuery.ajax('?page=' + currentPageNotification, {asynchronous:true, evalScripts:true, method:'get', success: function(data, textStatus, jqXHR) {
        $('#notifications-area').append(jQuery(data).find('#notifications-area').html());
        if(typeof jQuery(data).find('#notifications-area').html() == 'undefined' || jQuery(data).find('#notifications-area').html().trim().length == 0){
            clearInterval(intervalID);
        }
    },});
}

$('document').ready(function(){
    $('#see-more-notifications').bind("click",function(){
        getNotifications();
        return false;
    });
})