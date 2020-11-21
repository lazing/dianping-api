require 'faraday'

module Dianping
  module Api
    class MiddleWare
      def initialize(app, client)
        @app = app
        @client = client
      end

      def call(env)
        check_session(env)
        @app.call(env).on_complete do |response_env|
          check_response(response_env)
        end
      end

      def check_session(_env)
        return unless client.token.expire?

        client.token.refresh
        raise 'token expires'
      end

      def check_response(env)
      end
    end
  end
end
