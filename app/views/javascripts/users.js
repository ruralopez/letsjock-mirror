var users = <%= @users.any? ? @users.to_json.html_safe : "{}" %>;