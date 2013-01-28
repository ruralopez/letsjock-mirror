class ResultsController < ApplicationController

  def create
    @user = User.find(params[:result][:user_id])
    @result = @user.results.build(params[:result])
    if @result.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

  def update
    @result = Result.find(params[:id])
    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to '/profile/' + @result.user_id.to_s, notice: 'Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Result.find(params[:id])
    @user = User.find(@result.user_id)
    @result.destroy

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end


end
