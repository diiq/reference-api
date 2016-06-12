class ReferencesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def show
    requires_user_may(:view, reference)
  end

  private

  def reference
    @reference ||= Reference.find(params[:id])
  end
end
