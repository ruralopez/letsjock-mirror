class TagsController < ApplicationController

  def index
    @tags = Tags.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tags }
    end
  end

end
