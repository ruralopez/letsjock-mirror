class TrainsController < ApplicationController

  def create
    @user = User.find(params[:train][:user_id])
    if signed_in? && current_user.id == @user.id
      @train = @user.trains.build(params[:train])
      if @train.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @train = Train.find(params[:id])
    if signed_in? && current_user.id == @train.user_id
      respond_to do |format|
        if @train.update_attributes(params[:train])
          format.html { redirect_to '/profile/' + @train.user_id.to_s, notice: 'Train was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @train.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @train = Train.find(params[:id])
    @user = User.find(@train.user_id)
    if signed_in? && current_user.id == @user.id
      @train.destroy

      respond_to do |format|
        format.html { redirect_to @user }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
