class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @quote = Quote.find params[:quote_id]
    @vote = @quote.votes.new vote_params
    @vote.user = current_user
    if @vote.save
      flash[:notice] = "Voted!"
    else
      flash.now[:alert] = "Something went wrong!"
    end
    redirect_to quotes_path
  end

  private

  def vote_params
    params.require(:vote).permit(:value)
  end
end
