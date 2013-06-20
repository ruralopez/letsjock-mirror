$('.best_in_place').best_in_place();

$(function(){
  // BEST IN PLACE
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
                if(name.toLowerCase().indexOf(elem.data('oldVal').toLowerCase()) != -1)
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
  
  /*
   *  view: _profile_user
   */
  $(".date").datepicker();
  $('.dropdown-toggle').dropdown();
  
  // EDIT PROFILE
  $('#edit-profile-link').click(function(){
    $('#edit-profile').toggle("normal").toggleClass("hidden");
  });
  $('#edit_user_cancel').click(function(e){
    e.preventDefault();
    $('#edit-profile-link').click();
  });
  
  // ADD EXPERIENCE
  $(".resume .add-new").click(function(e){
    e.preventDefault();
    $(this).next("form").toggle("normal").toggleClass("hidden");
  });
  
  // EDIT EXPERIENCE
  // Solo para el ul.experience padre
  $('ul.experience').not("ul.experience ul.experience").append($('.edit-experience'));
  
  // SHOW LOADING WHILE AJAX CALLING
  $(document).ajaxStart(function(){
    $(".box-info .async-form").append("<div id=loading></div>");
  });
  $(document).ajaxStop(function(){
    $("#loading").remove();
  });
  $('.edit-experience-button').click(function(e){
    e.preventDefault();
    var data = {};
    data["object_id"] = $(this).parents("ul.experience").attr("data-id");
    data["object_type"] = $(this).parents("ul.experience").attr("data-type");
    
    // WORKING EXPERIENCE
    if(data["object_type"] == "work" && $(this).parents("ul.experience").find("ul.experience").length){
      data["object_id"] = $(this).parents("ul.experience").find("ul.experience").attr("data-id");
      data["object_type"] = $(this).parents("ul.experience").find("ul.experience").attr("data-type");
    }
    
    $(this).parents(".resume").toggle("normal").after($(".async-form"));
    $(".box-info .async-form").show().load("/profile/" + $("#user_id").val() + "/edit_profile", data);
  });

  // REMOVE EXPERIENCE
  $('.delete-experience-button').click(function(e){
    e.preventDefault();
    
    $(this).parents("ul.experience").append($('.alert-delete').toggleClass("hide"));
  });
  
  $(".alert-delete .btn-cancel").click(function(e){
    $(this).parents("ul.experience .alert-delete").toggleClass("hide");
  });
  
  $(".alert-delete .btn-confirm").click(function(e){
    var data = {};
    data["object_id"] = $(this).parents("ul.experience").attr("data-id");
    data["object_type"] = $(this).parents("ul.experience").attr("data-type");
    
    $.post("/profile/" + $("#user_id").val() + "/remove_profile", data, function(){
      location = "/profile/" + $("#user_id").val();
    });
  });
  
  // LIKES
  $(".btn-like").click(function(){
    var span = $(this).parent().next().find("span.likes-count");
    var count = parseInt(span.attr("data-count"));
    
    if($(this).hasClass("liked")){
      $(this).find("span").text("Like");
      count--;
    }
    else{
      $(this).find("span").text("Liked");
      count++;
    }
    
    span.text(count + " likes").attr("data-count", count);
    $(this).toggleClass("liked");
  });
  
  // COMMENTS
  $(".single-comment textarea").keypress(function(e){
    if ( event.which == 13 && $(this).val() != "") {
      event.preventDefault();
      
      var data = {};
      data["object_id"] = $(this).attr("data-id");
      data["object_type"] = $(this).attr("data-type");
      data["comment"] = $(this).val();
      objeto = $(this).attr("disabled", "disabled");
      
      $.post("/add_comment", data, function(data){
        var li = objeto.parents("li.new_comment").prev();
        objeto.parents("li.new_comment").before(li.clone());
        
        li.find(".comment_text").text(objeto.val());
        li.show();
        
        objeto.val("").removeAttr("disabled");
      }, "json");
    }
  });
  
});

/*
 *  VIEWS FUNCTIONS
 *  views: _profile_form, _working_profile_form
 */
function form_profile_cancel(btn){
  $(".alert-error").text("...").hide('fast');
  
  if(btn.parents(".async-form").length){
    $(".resume:hidden ul.experience").parent().toggle("normal");
    btn.parents(".async-form").toggle("fast").empty();
  }else
    btn.parents("form").toggle("normal").toggleClass("hidden");
}

function form_profile_validate(form, errors){
  if(keyCount(errors) == 0)
    form.find("fieldset > div:visible[data-validate]").each(function(){
      var fields = $.parseJSON($(this).attr("data-validate"));
      
      for(var i = 0; i < fields.length; i++){
        var input = form.find("#" + fields[i]);
        
        if( input.val().length == 0 ){
          errors[input.attr("id")] = input.attr("placeholder");
        }
      }
    });
  
  var cnt = keyCount(errors);
  
  if(cnt == 1 && errors[form.attr("id")])
    form.find(".alert").html(errors[form.attr("id")]).show("fast");
  else if(cnt)
    form.find(".alert").html( "<h4>Following fields are required</h4>" + $.map(errors, function(n, i) { return ( lastKey(errors) == i && cnt > 1 ) ? " and " + n : n; }).join(", ") ).show("fast");
  else
    form.submit();
  
  return false;
}

/*
 *  Additional functions
 */
function ValidUrl(str) {
  var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
    '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
    '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
    '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
  if(!pattern.test(str)) {
    return false;
  } else {
    return true;
  }
}
function validDate(str){
  if(!/^(0[1-9]|[12][0-9]|3[01])\-(0[1-9]|1[012])\-(19|20)\d\d$/.test(str))
    return false
  else
    return true;
}
function keyCount(obj){
  var count = 0;
  
  for ( var i in obj ) {
    if (obj.hasOwnProperty(i)) {
      count++;
    }
  }
  
  return count;
}
function lastKey(obj){
  var last;
  
  for ( var i in obj ) {
    if (obj.hasOwnProperty(i)) {
      last = i;
    }
  }
  
  return last;
}
