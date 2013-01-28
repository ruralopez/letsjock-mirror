class CompetitionsController < ApplicationController

  def create
    @user = User.find(params[:competition][:user_id])
    @competition = @user.competitions.build(params[:competition])
    if @competition.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

  def update
    @competition = Competition.find(params[:id])
    respond_to do |format|
      if @competition.update_attributes(params[:competition])
        format.html { redirect_to '/profile/' + @competition.user_id.to_s, notice: 'Competition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

end
