var states = <%= @states.map{|p| {:label=>p.name, :value=>p.id, :parent=>p.country_id}}.to_json.html_safe %>;
