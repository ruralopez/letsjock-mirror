$(function(){

    $('#conversation_link').live('ajax:success', function() {
        $(this).closest('div').fadeOut();
    });
});
