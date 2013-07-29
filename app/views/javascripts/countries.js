var countries = <%= @countries.any? ? @countries.to_json.html_safe : "{}" %>;
var fixed_countries = <%= @countries.map{|p| {:label=>p.name, :value=>p.id}}.to_json.html_safe %>;
