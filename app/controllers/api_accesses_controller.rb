class ApiAccessesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def verify_api_level
    @api = ApiAccess.find_by_key(params[:key])
  end
end
