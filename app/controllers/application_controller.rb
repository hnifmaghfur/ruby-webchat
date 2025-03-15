class ApplicationController < ActionController::API
  def server
    render json: { message: "server running well." }
  end
end
