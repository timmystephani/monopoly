class Api::V1::ApplicationController < ActionController::Base
	def authenticate
        auth_header = request.headers['Authorization']

        render_unauthorized if auth_header.nil?

        puts 'auth header'
        puts auth_header
        puts ''

        # TODO: add try catch around this
        token = auth_header.scan(/Token\s(.*)/).first.first 
        
        @current_user = User.find_by_auth_token token

        render_not_found if @current_user.nil?
      end

      def render_not_found
        raise Exceptions::NotFoundError
      end

      def render_unauthorized
        raise Exceptions::AuthenticationError
      end

      rescue_from Exceptions::NotFoundError do
        render json: {}, status: 404
      end

      rescue_from Exceptions::AuthenticationError do
        response.headers['WWW-Authenticate'] = 'Token realm="Application"'
        render json: {}, status: 401
      end
end