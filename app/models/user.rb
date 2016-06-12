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

  def assign_as!(role, to:)
    role = Role.find_by(name: role.to_s) if !role.is_a? Role
    Assignment.create(role: role, user: self, object: to)
  end

  def may?(permission, object)
    Permission.joins(role: :assignments)
      .where(assignments: { user_id: id, object_id: object.id }, 
             name: permission)
      .first
      .present?

  end
end
