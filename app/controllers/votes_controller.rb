class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = current_quote.votes.new vote_params.merge(user: current_user)
    vote.save
    redirect_to quotes_path, notice: "Voted!" # error thrown if save fails
  end

  def update
    @quote = current_quote
    vote = @quote.votes.find_by!(user: current_user)
    vote.update vote_params
    redirect_to quotes_path, notice: "Vote updated" # error thrown if update fails
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

  def current_quote
    Quote.find params[:quote_id]
  end
end
