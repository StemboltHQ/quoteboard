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
