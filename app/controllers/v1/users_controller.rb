require_relative "../../concerns/authentication"

class V1::UsersController < ApplicationController
  include Authentication
  before_action :validate_token, only: [:index]

  def index
    begin
      # Get users data
      users = User.where.not(id: @user_id).select(:id, :username, :created_at)
      render json: { message: "success", data: users }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    begin
      # Get user by id
      user = User.find(params[:id])
      user = user.slice(:id, :username)
      render json: { message: "success", data: user }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
