class User < ActiveRecord::Base
  # Columns:
  # email: string
  #
  has_many :assignments

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
end
