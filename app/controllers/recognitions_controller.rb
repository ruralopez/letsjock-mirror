class RecognitionsController < ApplicationController

  def create
    @user = User.find(params[:recognition][:user_id])
    @recognition = @user.recognitions.build(params[:recognition])
    if @recognition.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

  def update
    @recognition = Recognition.find(params[:id])
    respond_to do |format|
      if @recognition.update_attributes(params[:recognition])
        format.html { redirect_to '/profile/' + @recognition.user_id.to_s, notice: 'Recognition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recognition.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recognition = Recognition.find(params[:id])
    @user = User.find(@recognition.user_id)
    @recognition.destroy

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end

end
