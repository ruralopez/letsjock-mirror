$('.best_in_place').best_in_place();

$(function(){
    if($("#appendedInput").val() != undefined){
        $("#appendedInput").each(function(){
            var elem = $(this);
            elem.data('oldVal', elem.val());
            elem.bind("propertychange keyup input paste", function(event){
                if(elem.data('oldVal') != elem.val())
                {
                    elem.data('oldVal', elem.val());
                    var divUsers = $('.socialDiv');
                    for(var i=0; i<divUsers.length; i++)
                    {
                        for(var j=0; j<divUsers[i].childNodes.length; j++)
                        {
                            var aux = divUsers[i].childNodes[j];
                            if(aux.className == "item-info")
                            {
                                var h4 = aux.getElementsByTagName("h4");
                                var link = h4[0].getElementsByTagName("a");
                                var name = link[0].innerText;
                                if(name.indexOf(elem.data('oldVal')) != -1)
                                {
                                    divUsers[i].style.display = "block";
                                }
                                else
                                {
                                    divUsers[i].style.display = "none";
                                }
                            }
                        }
                    }
                }
            });
        });
    }
});
