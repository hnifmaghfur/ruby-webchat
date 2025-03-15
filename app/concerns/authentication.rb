module Authentication
  extend ActiveSupport::Concern

  def validate_token
    # Get token from header
    token = request.headers["Authorization"]&.split(" ")&.last

    begin
      # Verify token
      decoded_token = JWT.decode(
        token,
        Rails.application.credentials.secret_key_base,
        true,
        { algorithm: "HS256" }
      )

      # Get user id from token
      @user_id = decoded_token[0]["user_id"]

      # Validate user exists
      @current_user = User.find_by(id: @user_id)
      if !@current_user
        render json: { error: "User not found" }, status: :not_found and return
      end
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
