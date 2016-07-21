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
    return unless raw_params[:quoted_person]
    person = raw_params[:quoted_person]
    if person.starts_with('@')
      Person.find_or_create_by(slack_name: person)
    else
      Person.find_or_create_by(full_name: person)
    end
  end
end
