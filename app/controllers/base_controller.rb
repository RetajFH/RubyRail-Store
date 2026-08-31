class BaseController < ApplicationController
   skip_before_action :verify_authenticity_token

  def request_authentication
    render json: { error: "Not authenticated" }, status: :unauthorized
  end
end