(function($) {
    var Validation = function() {
        var rules = {
            email : {
                check: function(value) {
                    if(value)
                        return testPattern(value,"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])");
                    return true;
                },
                msg : "Enter a valid e-mail address."
            },
            required : {
                check: function(value) {
                    if(value)
                        return true;
                    else
                        return false;
                },
                msg : "This field is required."
            },
            lengthMin6 : {
                check: function(value) {
                    if(value.length > 5)
                        return true;
                    else
                        return false;
                },
                msg : "Your password must contain at least 6 characters."
            },
            lengthMax255 : {
                check: function(value) {
                    if(value.length < 255)
                        return true;
                    else
                        return false;
                },
                msg : "This text cant contain more than 255 characters."
            },
            passMatch : {
                check: function(value) {
                    if(value == $('#user_password').val())
                        return true;
                    else
                        return false;
                },
                msg : "Confirmation does not match password."
            },
            notBlank : {
                check: function(value) {
                    if(value.trim().length > 0)
                        return true;
                    else
                        return false;
                },
                msg : "This field can't be blank."
            },
            imageFormat : {
                check: function(value) {
                    value = value.split('.')[1];
                    if(value == "jpg" || value == "gif" || value == "bmp" || value == "jpeg" || value == "svg" || value == "png" || value == undefined)
                        return true;
                    else
                        return false;
                },
                msg : "Incorrect image format."
            },
            positiveInteger : {
                check: function(value) {
                    if(value > 0 && value % 1 == 0)
                        return true;
                    else
                        return false;
                },
                msg : "The value must be a positive integer."
            }
        }
        var testPattern = function(value, pattern) {
            var regExp = new RegExp(pattern,"");
            return regExp.test(value);
        }
        return {
            addRule : function(name, rule) {
                rules[name] = rule;
            },
            getRule : function(name) {
                return rules[name];
            }
        }
    }
    var Form = function(form) {
        var fields = [];
        form.find("[validation]").each(function() {
            var field = $(this);
            if(field.attr('validation') !== undefined) {
                fields.push(new Field(field));
            }
        });
        this.fields = fields;
    }
    Form.prototype = {
        validate : function() {
            for(field in this.fields) {
                this.fields[field].validate();
            }
        },
        isValid : function() {
            for(field in this.fields) {
                if(!this.fields[field].valid) {
                    this.fields[field].field.focus();
                    return false;
                }
            }
            return true;
        }
    }

    var Field = function(field) {
        this.field = field;
        this.valid = false;
        this.attach("change");
    }
    Field.prototype = {
        attach : function(event) {
            var obj = this;
            if(event == "change") {
                obj.field.bind("change",function() {
                    return obj.validate();
                });
            }
            if(event == "keyup") {
                obj.field.bind("keyup",function(e) {
                    return obj.validate();
                });
            }
        },
        validate : function() {
            var obj = this,
                field = obj.field,
                errorClass = "errorClass",
                errorlist = $(document.createElement("span")).addClass(errorClass),
                types = field.attr("validation").split(" "),
                container = field.parent(),
                errors = [];
            field.next(".errorClass").remove();
            for (var type in types) {
                var rule = $.Validation.getRule(types[type]);
                if(!rule.check(field.val())) {
                    container.addClass("error");
                    errors.push(rule.msg);
                }
            }
            if(errors.length) {
                obj.field.unbind("keyup")
                obj.attach("keyup");
                field.after(errorlist.empty());
                errorlist.append("<span>"+ errors[0] +"</span>");
                obj.valid = false;
            }
            else {
                errorlist.remove();
                container.removeClass("error");
                obj.valid = true;
            }
        }
    }

    $.extend($.fn, {
        validation : function() {
            var validator = new Form($(this));
            $.data($(this)[0], 'validator', validator);
            $(this).bind("submit", function(e) {
                validator.validate();
                if(!validator.isValid()) {
                    e.preventDefault();
                }
            });
        },
        validate : function() {
            var validator = $.data($(this)[0], 'validator');
            validator.validate();
            return validator.isValid();
        }
    });
    $.Validation = new Validation();
})(jQuery);