class ReferenceTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :reference
end
