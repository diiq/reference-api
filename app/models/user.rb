class MissingRoleForAssignment < Exception; end

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
    role = Role.find_by(name: role.to_s) if !(role.is_a? Role)
    raise MissingRoleForAssignment.new(role.to_s) if !role
    Assignment.create!(role: role, user: self, object: to)
  end

  def may?(permission, object)
    Permission.joins(role: :assignments)
      .where(assignments: { user_id: id, object_id: object.id },
             name: permission)
      .first
      .present?

  end

  def things_I_may(permission, type)
    # Returns a list of ids.
    Assignment.joins(role: :permissions)
      .where(user_id: id, object_type: type.name.demodulize,
             permissions: {name: permission})
      .pluck(:object_id)
  end

  def authorization_method_missing(method_name, args)
    name = method_name.id2name
    if name =~ /^ids_of_(.*)_I_may$/
      return things_I_may(*args, $1.singularize.camelcase.constantize)
    end

    if name =~ /^(.*)_I_may$/
      type = $1.singularize.camelcase.constantize
      ids = things_I_may(*args, type)
      return type.find(ids)
    end
  end

  def method_missing(*args)
    if args[0] =~ /^(.*)_I_may$/
      authorization_method_missing *args
    end
  end

  def creator_tag
    special_tag("Created by #{email}")
  end

  def earmark_tag
    special_tag("earmarked")
  end

  def special_tag(name)
    tag = tags_I_may(:always_own).find {|t| t.name == name}
    return tag if tag

    tag = Tag.create!(name: name)
    assign_as!(:permanent_owner, to: tag)
    return tag
  end

  def references_I_may_view
    tags = ids_of_tags_I_may(:view)
    Reference.order(created_at: :asc).includes(:reference_tags)
      .where(reference_tags: {tag_id: tags}).uniq
  end
end
