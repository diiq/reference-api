class ReferencesController < ApplicationController
  before_action :authenticate_user!, except: :letsencrypt
  respond_to :json

  def index
    @references = current_user.references_I_may_view
  end

  def show
    ensure_has_tags_I_may :view
  end

  def create
    # TODO: ENSURE I MAY EDIT ALL TAGS IN LIST
    ensure_current_user_owns
    @reference = Reference.create! reference_params
  end

  def set_from_url
    ensure_has_tags_I_may :edit_references

    if params[:url]
      reference.set_from_url params[:url]
    else
      reference.set_from_presigned_put
    end

    reference.save!
  end

  def destroy
    # TODO: This should be 'remove from all tags I can edit,
    # then destroy if no tags left
    new_tags = reference.tags.reject do |tag|
      current_user.may? :edit_references, tag
    end

    if new_tags.count == 0
      reference.destroy!
    else
      reference.tags = new_tags
      reference.save!
    end

    render json: {}, status: :no_content
  end

  def add_tag
    tag = Tag.find(params[:tag_id])
    requires_user_may :edit, tag

    # You can't assign yourself as the creator of a tag, either.
    raise AuthorizationError if tag == current_user.creator_tag

    ReferenceTag.where(
      tag_id: tag.id,
      reference_id: params[:reference_id]
    ).first_or_create!

    reference
  end

  def remove_tag
    tag = Tag.find(params[:tag_id])
    requires_user_may :edit, tag

    ReferenceTag.where(
      tag_id: tag.id,
      reference_id: params[:reference_id]
    ).destroy_all

    reference
  end

  def letsencrypt
    # use your code here, not mine
    render text: "bG9dYOpzqASdFIS2dZRjVXufJpsaY4oHpS1zBsnOoDY.enTw7CVUA0X1NCs4YCL3YRaG1_vzNKlvw5Wpfg2bg3A"
  end

  private

  def reference
    @reference ||= Reference.find(params[:id] || params[:reference_id])
  end

  def reference_params
    @reference_params ||= params.require(:reference).permit(
      :notes,
      tag_ids: []
    )
  end

  def ensure_current_user_owns
    reference_params[:tag_ids] ||= []
    reference_params[:tag_ids] << current_user.creator_tag.id
  end

  def ensure_has_tags_I_may(permission)
    fail AuthorizationError unless reference.tags.any? do |tag|
      current_user.may?(permission, tag)
    end
  end
end
