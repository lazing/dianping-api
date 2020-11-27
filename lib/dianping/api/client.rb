require 'faraday'

module Dianping
  module Api
    class Client

      include Modules::Tuangou

      attr_reader :app_key, :site, :token, :redirect_url

      def initialize(app_key, secret, **options)
        @app_key = app_key
        @secret = secret
        @site = 'https://openapi.dianping.com'
        @redirect_url = options[:redirect_url]
        @token = Token.new(self)
      end

      def connection
        Faraday.new(url: @site) do |conn|
          conn.request :retry
          conn.request :dianping, self
          conn.request :url_encoded
          conn.response :logger
          conn.response :raise_error
          conn.adapter :net_http
        end
      end

      def get(url = nil, params = nil, headers = nil)
        res = connection.get(url, sign_with_share(params), headers)
        json(res.body)
      end

      def post(url = nil, body = nil, headers = nil)
        res = connection.post(url, sign_with_share(body), headers)
        json(res.body)
      end

      def auth(auth_code)
        token.auth(auth_code)
      end

      def auth_conn
        Faraday.new(url: @site) do |conn|
          conn.request :url_encoded
          conn.response :logger
          conn.response :raise_error
          conn.adapter :net_http
        end
      end

      def auth_token(auth_code)
        res = auth_conn.post('/router/oauth/token') do |req|
          req.body = {
            app_key: @app_key,
            app_secret: @secret,
            auth_code: auth_code,
            grant_type: 'authorization_code',
            redirect_url: redirect_url
          }
        end
        json(res.body)
      end

      def refresh_token(refresh_code)
        res = auth_conn.post('/router/oauth/token') do |req|
          req.body = {
            app_key: @app_key,
            app_secret: @secret,
            refresh_token: refresh_code,
            grant_type: 'refresh_token'
          }
        end
        json(res.body)
      end

      def json(text)
        MultiJson.load(text || '{}', symbolize_keys: true)
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
        merged = share_params.merge(params || {}).dup
        content = merged.to_a.sort.flatten.join.encode!('UTF-8')
        # puts @secret + content
        sign = Digest::MD5.hexdigest(@secret + content + @secret)
        merged.merge(sign: sign)
      end
    end
  end
end