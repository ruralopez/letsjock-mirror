class RecognitionsController < ApplicationController

  def create
    @user = User.find(params[:recognition][:user_id])
    if signed_in? && current_user.id == @user.id
      @recognition = @user.recognitions.build(params[:recognition])
      if @recognition.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @recognition = Recognition.find(params[:id])
    if signed_in? && current_user.id == @recognition.user_id
      respond_to do |format|
        if @recognition.update_attributes(params[:recognition])
          format.html { redirect_to '/profile/' + @recognition.user_id.to_s, notice: 'Recognition was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @recognition.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @recognition = Recognition.find(params[:id])
    @user = User.find(@recognition.user_id)
    if signed_in? && current_user.id == @user.id
      @recognition.destroy

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
