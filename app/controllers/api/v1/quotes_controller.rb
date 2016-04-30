class Api::V1::QuotesController < ActionController::Base

  def create
    @quote = Quote.new quote_params
    if @quote.save
      render :show, status: :created, format: :json
    else
      render json: { message: @quote.errors }, status: 400
    end
  end

  private

  def quote_params
    raw_params.merge(person: quoted_person)
  end

  def raw_params
    params.require(:quote).permit(:body, :location, :quoted_person)
  end

  def quoted_person
    Person.find_or_create_by(full_name: raw_params[:quoted_person])
  end
end
