class QuotesController < ApplicationController
  before_action :authenticate_user!

  def show
    @quote = Quote.find params[:id]
    @vote = @quote.votes.find_by(user: current_user)
    @user_votes = current_user.votes
  end

  def edit
    @quote = current_user.quotes.find params[:id]
  end

  def update
    @quote = current_user.quotes.find params[:id]
    if @quote.update quote_params
      redirect_to @quote
    else
      render :edit
    end
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new quote_params
    @quote.created_by = current_user
    if @quote.save
      redirect_to @quote
    else
      render :new
    end
  end

  def index
    @quotes = Quote.all
    @user_votes = current_user.votes
  end

  def destroy
    @quote = current_user.quotes.find params[:id]
    @quote.destroy
    redirect_to quotes_path
  end

  private

  def quote_params
    params.require(:quote).permit(:body, :quoted_person, :location)
  end
end
