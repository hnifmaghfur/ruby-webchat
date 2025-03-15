require_relative "../../concerns/authentication"

class V1::UsersController < ApplicationController
  include Authentication
  before_action :validate_token, only: [:index]

  def index
    begin
      # Get users data
      users = User.all.select(:id, :username)
      render json: { message: "success", data: users }, status: :ok
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
