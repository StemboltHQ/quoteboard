class QuotesController < ApplicationController
  def show
    @quote = Quote.find params[:id]
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new quote_params
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
