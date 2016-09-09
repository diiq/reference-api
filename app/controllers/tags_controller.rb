class TagsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def index
    @tags = current_user.tags_I_may :view
  end

  def show
    requires_user_may :view, tag
  end

  def create
    @tag = Tag.create!(tag_params)
    current_user.assign_as!(:permanent_owner, to: @tag)
  end

  def destroy
    requires_user_may :edit, tag
    tag.destroy!

    render json: {}, status: :no_content
  end

  private

  def tag
    @tag ||= Tag.find(params[:id] || params[:tag_id])
  end

  def tag_params
    @tag_params ||= params.require(:tag).permit(
      :name,
    )
  end
end
