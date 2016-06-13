class ReferencesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def show
    requires_user_may(:view, reference)
  end

  def create
    @reference = Reference.create! reference_params
  end

  private

  def reference
    @reference ||= Reference.find(params[:id])
  end

  def reference_params
    params.require(:reference).permit(
      :notes
    )
  end
end
