class JavascriptsController < ApplicationController
  layout false
  before_filter :js_content_type
  
  def js_content_type
    response.headers['Content-type'] = 'text/javascript; charset=utf-8'
  end
  
  def countries
    @countries = Country.select("id, name").find(:all)
  end
  
  def sports
    @sports = Sport.select("id, name, parent_id").find(:all)
  end
  
  def users
    @users = User.select("id, name, lastname, email").find(:all, :conditions => ["isSponsor = 0"])
  end
end
