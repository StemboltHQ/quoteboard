class QuotesController < ApplicationController
  before_action :authenticate_user!

  def show
    @quote = Quote.find params[:id]
    @vote = @quote.votes.find_by(user: current_user)
    @user_votes = current_user.votes
    @user_favourites = current_user.favourite_quotes
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
    @quotes = Quote.order(created_at: :desc)
    @user_votes = current_user.votes
    @user_favourites = current_user.favourite_quotes
  end

  def destroy
    @quote = current_user.quotes.find params[:id]
    @quote.destroy
    redirect_to quotes_path
  end

  private

  def quote_params
    raw_params.merge(person: quoted_person)
  end

  def raw_params
    params.require(:quote).permit(:body, :location, :quoted_person)
  end

  def quoted_person
    return unless raw_params[:quoted_person]
    person = raw_params[:quoted_person]
    if person.starts_with('@')
      Person.find_or_create_by(slack_name: person)
    else
      Person.find_or_create_by(full_name: person)
    end
  end
end
