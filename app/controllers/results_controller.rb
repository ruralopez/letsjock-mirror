class ResultsController < ApplicationController

  def create
    @user = User.find(params[:result][:user_id])
    if signed_in? && current_user.id == @user.id
      @result = @user.results.build(params[:result])
      if @result.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def update
    @result = Result.find(params[:id])
    if signed_in? && current_user.id == @result.user_id
      respond_to do |format|
        if @result.update_attributes(params[:result])
          format.html { redirect_to '/profile/' + @result.user_id.to_s, :notice => 'Result was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @result.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  def destroy
    @result = Result.find(params[:id])
    @user = User.find(@result.user_id)
    if signed_in? && current_user.id == @user.id
      @result.destroy

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
