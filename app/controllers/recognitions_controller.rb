class RecognitionsController < ApplicationController

  def create
    @user = User.find(params[:recognition][:user_id])
    @recognition = @user.recognitions.build(params[:recognition])
    if @recognition.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
