class Api::V1::PeopleController < ActionController::Base

  def create
    @person = Person.new person_params
    if @person.save
      render :show, status: :created, format: :json
    else
      render json: { message: @person.errors }, status: 400
    end
  end

  private

  def person_params
    params.require(:person).permit(:slack_name, :full_name)
  end
end
