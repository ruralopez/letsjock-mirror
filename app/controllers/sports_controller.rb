class SportsController < ApplicationController

  def index
    @sports = Sport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sports }
    end
  end

  def new
    @sport = Sport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @sport }
    end
  end

  def create
    @sport = Sport.new(params[:sport])

    respond_to do |format|
      if @sport.save

      end
    end
  end

end
