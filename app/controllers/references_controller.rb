class ReferencesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def index
    @references = current_user.references_I_may_view
  end

  def show
    fail AuthorizationError unless reference.tags.any? do |tag|
      current_user.may?(:view, tag)
    end
  end

  def create
    # TODO: ENSURE I MAY EDIT ALL TAGS IN LIST
    ensure_current_user_owns
    @reference = Reference.create! reference_params
  end

  def set_from_url
    if params[:url]
      reference.set_from_url params[:url]
    else
      reference.set_from_presigned_put
    end

    reference.save!
  end

  def destroy
    if reference.tags.include? current_user.creator_tag
      reference.destroy!
      render json: {}, status: :no_content
    else
      fail AuthorizationError
    end
  end

  private

  def reference
    @reference ||= Reference.find(params[:id] || params[:reference_id])
  end

  def reference_params
    @reference_params ||= params.require(:reference).permit(
      :notes,
      :tag_ids
    )
  end

  def ensure_current_user_owns
    reference_params[:tag_ids] ||= []
    reference_params[:tag_ids] << current_user.creator_tag.id
  end
end
