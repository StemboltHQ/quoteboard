class QuotesController < ApplicationController
  before_action :authenticate_user!

  def show
    @quote = Quote.find params[:id]
  end
  
  def edit
    @quote = current_user.quotes.find params[:id]
  end

  def new
    @quote = Quote.new
  end

  def create 
    @quote = Quote.new quote_params
    @quote.user = current_user
    if @quote.save
      redirect_to @quote
    else
      render :new
    end
  end
  
  def index
    @quotes = Quote.all
  end
  private

  def quote_params
    params.require(:quote).permit(:body, :author, :location)
  end
end
