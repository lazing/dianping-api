module Dianping
  module Api

    class Client

      def initialize(key, secret)
        @key = key
        @secret = secret
        @site = 'https://openapi.dianping.com'
      end

      def connection
        @connection ||= begin
          Faraday.new(url: @site) do |conn|
            conn.request :multipart
            conn.request :url_encoded

            conn.response :logger
            conn.response :raise_error

            conn.adapter :net_http
          end
        end
      end
    end
  end
end