require 'faraday'

module Dianping
  module Api

    class Client

      attr_reader :app_key, :site, :token, :redirect_url

      def initialize(app_key, secret)
        @app_key = app_key
        @secret = secret
        @site = 'https://openapi.dianping.com'
        @redirect_url = ''
        @token = Token.new(self)
      end

      def connection
        @connection ||= begin
          Faraday.new(url: @site) do |conn|
            conn.request :retry
            conn.request :dianping, self
            conn.request :url_encoded
            conn.response :logger
            conn.response :raise_error
            conn.adapter :net_http
          end
        end
      end

      def auth(auth_code)
        res = Faraday.new(url: @site).post('/router/oauth/token') do |req|
          req.body = {
            app_key: @app_key,
            app_secret: @secret,
            auth_code: auth_code,
            grant_type: 'authorization_code',
            redirect_url: redirect_url
          }
        end
        convert_json(res)
      end

      def refresh(refresh_code)
        res = Faraday.new(url: @site).post('/router/oauth/token') do |req|
          req.body = {
            app_key: @app_key,
            app_secret: @secret,
            refresh_token: refresh_code,
            grant_type: 'refresh_token'
          }
        end
        convert_json(res)
      end

      def convert_json(response)
        # puts response.body
        MultiJson.load(response.body, symbolize_keys: true)
      end

      def share_params
        {
          app_key: app_key,
          timestamp: Time.now.strftime('%F %T'),
          session: token.access_token,
          format: 'json',
          v: 1,
          sign_method: 'MD5'
        }
      end

      def sign_with_share(params = {})
        merged = share_params.merge(params).dup
        content = merged.to_a.sort.flatten.join.encode!('UTF-8')
        # puts @secret + content
        sign = Digest::MD5.hexdigest(@secret + content + @secret)
        merged.merge(sign: sign)
      end
    end
  end
end