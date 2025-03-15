class V1::AuthController < ApplicationController
  def register
    user = User.new(username: params[:username], password: BCrypt::Password.create(params[:password]))
    if user.save
      render json: { message: "User registered successfully" }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(username: params[:username])
    if user && BCrypt::Password.new(user.password) != params[:password]
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end

    # endcode token for login auth
    token = JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.credentials.secret_key_base,
      "HS256"
    )

    render json: { message: "Login successful", data: token }, status: :ok
  end
end
