class StatsController < ApplicationController

  def index
    @stats = Stat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stats }
    end
  end

end
