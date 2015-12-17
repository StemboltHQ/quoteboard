class QuotesController < ApplicationController
  before_action :authenticate_user!
  def show
    @quote = Quote.find_by(id: params[:id])
    if @quote.nil?
      render :error
    else
      @quote
    end
  end

  def error
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

  def destroy
    @quote = current_user.quotes.find params[:id]
    @quote.destroy
    redirect_to quotes_path
  end

  private

  def quote_params
    params.require(:quote).permit(:body, :author, :location)
  end
end
