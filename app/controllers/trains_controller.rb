class TrainsController < ApplicationController

  def create
    @user = User.find(params[:train][:user_id])
    @train = @user.trains.build(params[:train])
    if @train.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
