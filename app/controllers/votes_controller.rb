class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = current_quote.votes.new vote_params.merge(user: current_user)
    if vote.save
      flash[:notice] = "Voted!"
    else
      flash[:alert] = "Something went wrong!"
    end
    redirect_to quotes_path
  end

  def update
    @quote = current_quote
    vote = @quote.votes.find_by!(user: current_user)
    if vote.update vote_params
      redirect_to quotes_path, notice: "Vote updated"
    else
      redirect_to quotes_path, alert: "Vote failed to update"
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:value)
  end

  def current_quote
    Quote.find params[:quote_id]
  end
end
