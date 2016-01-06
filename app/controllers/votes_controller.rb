class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @quote = Quote.find params[:quote_id]
    @vote = @quote.votes.new vote_params
    @vote.user = current_user
    if @vote.save
      flash[:notice] = "Voted!"
    end
    redirect_to quotes_path
  end

  def update
    @quote = Quote.find params[:quote_id]
    @vote = current_user.votes.find params[:id]
    flash[:notice] = "Vote updated" if @vote.update vote_params
    redirect_to quotes_path
  end

  def destroy
    @vote = current_user.votes.find params[:id]
    flash[:notice] = "Vote deleted" if @vote.destroy
    redirect_to quotes_path
  end

  private

  def vote_params
    params.require(:vote).permit(:value)
  end
end
