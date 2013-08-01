(function(e){var t=function(){var t={email:{check:function(e){return e?n(e,"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])"):!0},msg:"Enter a valid e-mail address."},required:{check:function(e){return e?!0:!1},msg:"This field is required."},lengthMin6:{check:function(e){return e.length>5?!0:!1},msg:"Your password must contain at least 6 characters."},lengthMax255:{check:function(e){return e.length<255?!0:!1},msg:"This text cant contain more than 255 characters."},passMatch:{check:function(t){return t==e("#user_password").val()?!0:!1},msg:"Confirmation does not match password."},notBlank:{check:function(e){return e.trim().length>0?!0:!1},msg:"This field can't be blank."},imageFormat:{check:function(e){return e=e.split(".")[1],e=="jpg"||e=="gif"||e=="bmp"||e=="jpeg"||e=="svg"||e=="png"||e==undefined?!0:!1},msg:"Incorrect image format."},positiveInteger:{check:function(e){return e>0&&e%1==0?!0:!1},msg:"The value must be a positive integer."},rutConGuion:{check:function(e){if(e.indexOf("-")!=-1){var t=e.split("-");if((parseInt(t[1])<10||t[1]=="k"||t[1]=="K")&&(t[0].length==7||t[0].length==8)&&parseInt(t[0])<99999999&&parseInt(t[0])>999999)return!0}return!1},msg:"Formato de rut inválido."}},n=function(e,t){var n=new RegExp(t,"");return n.test(e)};return{addRule:function(e,n){t[e]=n},getRule:function(e){return t[e]}}},n=function(t){var n=[];t.find("[validation]").each(function(){var t=e(this);t.attr("validation")!==undefined&&n.push(new r(t))}),this.fields=n};n.prototype={validate:function(){for(field in this.fields)this.fields[field].validate()},isValid:function(){for(field in this.fields)if(!this.fields[field].valid)return this.fields[field].field.focus(),!1;return!0}};var r=function(e){this.field=e,this.valid=!1,this.attach("change")};r.prototype={attach:function(e){var t=this;e=="change"&&t.field.bind("change",function(){return t.validate()}),e=="keyup"&&t.field.bind("keyup",function(e){return t.validate()})},validate:function(){var t=this,n=t.field,r="errorClass",i=e(document.createElement("span")).addClass(r),s=n.attr("validation").split(" "),o=n.parent(),u=[];n.next(".errorClass").remove();for(var a in s){var f=e.Validation.getRule(s[a]);f.check(n.val())||(o.addClass("error"),u.push(f.msg))}u.length?(t.field.unbind("keyup"),t.attach("keyup"),n.after(i.empty()),i.append("<span>"+u[0]+"</span>"),t.valid=!1):(i.remove(),o.removeClass("error"),t.valid=!0)}},e.extend(e.fn,{validation:function(){var t=new n(e(this));e.data(e(this)[0],"validator",t),e(this).bind("submit",function(e){t.validate(),t.isValid()||e.preventDefault()})},validate:function(){var t=e.data(e(this)[0],"validator");return t.validate(),t.isValid()}}),e.Validation=new t})(jQuery);