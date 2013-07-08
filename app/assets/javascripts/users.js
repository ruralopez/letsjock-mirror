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
  
  /*
   *  view: _autocomplete_country
   */  
  $('.typeahead.country').typeahead({minLength: 0, source: handlerSourceCountry, updater: handlerUpdaterCountry}).bind("focus", triggerShow);
  $('.typeahead.users').typeahead({minLength: 0, source: handlerSourceUser, updater: handlerUpdaterUser});
  
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
  
  // HIGHLIGHT: Solo para Jock
  $('ul.experience').not("ul.experience[data-type=work], ul.experience[data-type=education]").find("li.hide").removeClass("hide");
  
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
  
  // HIGHLIGHT EXPERIENCE
  $('.highlight-button').click(function(e){
    e.preventDefault();
    
    var data = {};
    var hito = $(this).parents("ul.experience");
    data["object_id"] = hito.attr("data-id");
    data["object_type"] = hito.attr("data-type");
    
    $.post("/profile/" + $("#user_id").val() + "/highlight", data, function(data){
      if(data){
        hito.toggleClass("destacado");
        
        if(data.highlight == 1)
          hito.append('<i class="icon-3x icon-bookmark icon-special-header"></i>');
        else
          hito.find("i.icon-special-header").remove();
      }
    }, "json");
  });

  // REMOVE EXPERIENCE
  $('.delete-experience-button').click(function(e){
    e.preventDefault();
    
    $(this).parents("ul.experience").append($('.alert-delete').toggleClass("hide"));
  });
  
  $("ul.experience").delegate(".alert-delete .btn-cancel", "click", function(e){
    $(this).parents("ul.experience .alert-delete").toggleClass("hide");
  });
  
  $("ul.experience").delegate(".alert-delete .btn-confirm", "click", function(e){
    $(this).attr("disabled", "disabled");
    var data = {};
    data["object_id"] = $(this).parents("ul.experience").attr("data-id");
    data["object_type"] = $(this).parents("ul.experience").attr("data-type");
    
    $.post("/profile/" + $("#user_id").val() + "/remove_profile", data, function(){
      location = "/profile/" + $("#user_id").val();
    });
  });
  
  // _profile_sponsor: CREATE POST
  $("#latest-post .post-actions .switch-user .dropdown-menu a").click(function(e){
    e.preventDefault();
    var i = $(this).parents(".switch-user").find("i");
    $("#latest-post .switch-user a.dropdown-toggle").text("Post as " + $(this).text()).append(i);
    $("#latest-post form #writer_id").val($(this).attr("data-id"));
  });
  
  // _profile_sponsor: DELETE POST
  $('#latest-post .delete-post-button').click(function(e){
    e.preventDefault();
    $(this).parents("li.post-item").before($('.alert-delete').toggleClass("hide"));
  });
  
  $("#latest-post").delegate(".alert-delete .btn-cancel", "click", function(e){
    $("#latest-post .alert-delete").toggleClass("hide");
  });
  
  $("#latest-post").delegate(".alert-delete .btn-confirm", "click", function(e){
    $(this).attr("disabled", "disabled");
    var data = {};
    data["post_id"] = $(this).parents(".alert-delete").next().attr("data-id");
    
    $.post("/profile/" + $("#user_id").val() + "/remove_post", data, function(){
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
    
    span.text(count).attr("data-count", count);
    $(this).toggleClass("liked");
    
    // Si es desde el modal-gallery
    if($(this).parents(".photo-like").length > 0){
      photo_id = $("#tagsForm input[name='tags[photo_id]']").val();
      
      var photo = $.grep(photos, function(element, index){
        return element.id == photo_id;
      })[0];
      
      photo.likes = count;
    }
  });
  
  // COMMENTS
  // _comments: SWITCH USER
  $(".new_comment .switch-user .dropdown-menu a").click(function(e){
    e.preventDefault();
    $(".new_comment .img-rounded img").attr("src", $(this).find("img").attr("src"));
    $(this).parents(".new_comment").find("#writer_id").val($(this).attr("data-id"));
  });
  
  // _comments: CREATE COMMENT
  $(".single-comment textarea").keypress(function(e){
    if ( event.which == 13 && $(this).val() != "") {
      event.preventDefault();
      
      var data = {};
      data["object_id"] = $(this).attr("data-id");
      data["object_type"] = $(this).attr("data-type");
      data["writer_id"] = $(this).prev().val();
      data["comment"] = $(this).val();
      objeto = $(this).attr("disabled", "disabled");
      
      $.post("/add_comment", data, function(data){
        if(data && data.comment_id){
          var li = objeto.parents("li.new_comment").prev();
          objeto.parents("li.new_comment").before(li.clone());
          
          li.find(".img-rounded img").attr("src", objeto.parents(".new_comment").find(".img-rounded img").attr("src"));
          li.find(".single-comment > a").text( objeto.parents("li.new_comment").find("a[data-id=" + data.user_id + "]").text() );
          li.find(".single-comment > a").attr("href", "/profile/" + data.user_id );
          li.find(".comment_text").text(objeto.val());
          li.find("a[data-remote=true]").attr("href", "/profile/" + data.user_id + "/like?object_id=" + data.comment_id + "&object_type=Comment")
          li.show();
          
          objeto.val("").removeAttr("disabled");
        }
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
 *  Autocomplete
 *  view: sports/_autocomplete
 */
function handlerSourceSport (query, process){
  parent_id = this.$element.attr("data-parent") || null;
  
  if(parent_id == null)
    sports_parents = $.grep(sports, function(element, index){ return true; });
  else
    sports_parents = $.grep(sports, function(element, index){
      return element.parent_id == parent_id;
    });
  
  var arr = $.map(sports_parents, function(el, i) {
    return el.name;
  });
  
  process(arr);
}
function handlerUpdaterSport (item) {
  sport = $.grep(sports_parents, function(element, index){
    return element.name == item;
  })[0];
  
  this.$element.parent().find("#sport_id").val(sport.id);
  
  this.$element.next(".typeahead").next(".typeahead").remove();
  this.$element.next(".typeahead").remove();
  
  var childs = $.grep(sports, function(element, index){ return element.parent_id == sport.id; }).length > 0;
  
  if(childs){
    this.$element.after("<input class='typeahead sports_" + sport.id + " span2' placeholder='Type position or category' data-provide='typeahead' type='text' data-parent='" + sport.id + "'>");
    $( '.typeahead.sports_' + sport.id ).typeahead({minLength: 0, source: handlerSourceSport, updater: handlerUpdaterSport}).focus();
  }
  return item;
}
function handlerHighlighterSport(item){
  sport = $.grep(sports_parents, function(element, index){
    return element.name == item;
  })[0];
  
  html = '<div class="typeahead">';
  html += '<div class="left">';
  html += '<div>'+sport.name+'</div>';
  html += '<div class="sport-parent">' + _getSportParent(sport.parent_id) + '</div>';
  html += '</div>';
  html += '<div class="clear"></div>';
  html += '</div>';
  return html;
}
function _getSportParent(id){
  var _tmp  = "";
  
  if(id){
    sports_parent = $.grep(sports, function(element, index){
      return element.id == id;
    })[0];
    
    _tmp = sports_parent.name;
    
    if(sports_parent.parent_id)
      _tmp += " < " + _getSportParent(sports_parent.parent_id);
  }
  
  return _tmp;
}

/*  
 *  views: users/_autocomplete_country
 */
function handlerSourceCountry (query, process){
  var arr = $.map(countries, function(el, i) {
    return el.name;
  });
  
  process(arr);
}
function handlerUpdaterCountry (item) {
  country = $.grep(countries, function(element, index){
    return element.name == item;
  })[0];
  
  this.$element.prev().val(country.id);
  return item;
}
function triggerShow(){
  if($(this).val() == ""){
    $(this).val("a");
    $(this).typeahead("lookup");
    $(this).val("");
  }
}

/*  
 *  views: layouts/_sponsor_leftbox, layouts/_modal_recommendation
 */
function handlerSourceUser (query, process){
  return $.get('/typeahead', { type: "User", query: query }, function (data) {
    results = data.options;
    
    var arr = $.map(data.options, function(el, i) {
      return el.name + " " + el.lastname;
    });
    
    return process(arr);
  });
}
function handlerUpdaterUser (item) {
  user = $.grep(results, function(element, index){
    return element.name + " " + element.lastname == item;
  })[0];
  
  this.$element.prev().val(user.id);
  
  return item;
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
