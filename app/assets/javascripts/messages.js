$(function(){

    $('#conversation_link').live('ajax:success', function() {
        $(this).closest('div').fadeOut();
    });

    if($("#messageSearch").val() != undefined){
        $("#messageSearch").each(function(){
            var elem = $(this);
            elem.data('oldVal', elem.val().toLowerCase());
            elem.bind("propertychange keyup input paste", function(event){
                if(elem.data('oldVal') != elem.val())
                {
                    elem.data('oldVal', elem.val().toLowerCase());
                    var divMessages = $('.messageDiv');
                    for(var i=0; i<divMessages.length; i++)
                    {
                        for(var j=0; j<divMessages[i].childNodes.length; j++)
                        {
                            var aux = divMessages[i].childNodes[j];
                            if(aux.className == "message-container")
                            {
                                for(var k=0; k<aux.childNodes.length; k++)
                                {
                                    var auxChild = aux.childNodes[k];
                                    if(auxChild.className == "full-message")
                                    {
                                        var message = auxChild.innerText.toLowerCase();
                                        if(message.indexOf(elem.data('oldVal')) != -1)
                                        {
                                            divMessages[i].style.display = "block";
                                        }
                                        else
                                        {
                                            divMessages[i].style.display = "none";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            });
        });
    }

});
