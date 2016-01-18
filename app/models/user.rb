class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  )
  has_many :quotes
  has_many :votes, dependent: :destroy

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data["email"])

    unless user
      user = User.create(
        email: data["email"],
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  has_many :favourites, dependent: :destroy
  has_many :favourite_quotes, through: :favourites, source: :quote
end
