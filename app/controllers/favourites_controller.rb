class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favourite = current_user.favourites.new quote: current_quote
    if favourite.save
      flash[:notice] = "Favourited!"
    else
      flash[:alert] = "Failed to favourite.  Had you already favourited?"
    end
    redirect_to quotes_path
  end

  def destroy
    favourite = current_user.favourites.find params[:id]
    favourite.destroy
    redirect_to quotes_path, notice: "Favourite removed."
  end

  private

  def current_quote
    Quote.find params[:quote_id]
  end
end
