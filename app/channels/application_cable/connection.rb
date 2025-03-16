module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = extract_token
      p "Token from params: #{request.params[:token]}"
      p token
      if token
        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
          user_id = decoded_token[0]["user_id"]
          if verified_user = User.find_by(id: user_id)
            verified_user
          else
            reject_unauthorized_connection
          end
        rescue JWT::DecodeError
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end

    def extract_token
        # Try to extract token from headers (for HTTP upgrade request)
        token = request.headers["Authorization"]&.split(" ")&.last

        # Also try to extract from cookies
        token ||= cookies.encrypted["auth_token"]

        # Also try to extract from params (for WebSocket connection)
        token ||= request.params["token"]

        # Also try to extract from query string
        token ||= request.query_parameters["token"]

        token
      end
  end
end
