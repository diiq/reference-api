class Tag < ActiveRecord::Base
  has_many :reference_tags
  has_many :references, through: :reference_tags
  has_many :assignments, as: :object, dependent: :destroy
end
