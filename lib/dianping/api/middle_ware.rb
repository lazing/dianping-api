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
          hash = MultiJson.load response_env.body, symbolized_keys: true
          check_response(hash)
        end
      end

      def check_session(_env)
        raise TokenMissingError unless @client.token.authorized?
        return unless @client.token.expired?

        @client.token.refresh
        raise TokenExpireError
      end

      def check_response(body)
        code = body[:code].to_i
        msg = format('[%<code>d]%<msg>s', code: code, msg: body[:msg])

        raise TokenExpireError, msg if code == 608
        raise UsageError, msg if code >= 800
        raise Error, msg unless code == 200
      end
    end
  end
end
