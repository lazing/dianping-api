require 'multi_json'

module Dianping
  module Api
    class Token
      attr_reader :client

      def initialize(client)
        @client = client
        @token_file = File.join('/tmp', "dianping-api-#{client.app_key}")
      end

      def access_hash
        @access_hash ||=
          begin
            token = MultiJson.load(File.read(@token_file), symbolize_keys: true)
            token[:access_hash] || (raise 'empty token')
          rescue Errno::ENOENT
            {}
          end
      end

      def refresh
        raise 'no_refresh_token' unless refresh_token && remain_refresh_count > 1

        save_token(client.refresh_token(@access_hash[:refresh_token]))
      end

      def auth(authcode)
        save_token(client.auth(authcode))
      end

      def save_token(token)
        json = MultiJson.dump(access_hash: { updated_at: Time.now }.merge(token))
        File.open(@token_file, 'w') { |f| f.write(json) }
        @access_hash = token
      end

      def access_token
        access_hash[:access_token]
      end

      def refresh_token
        access_hash[:refresh_token]
      end

      def expires_in
        access_hash[:expires_in]
      end

      def updated_at
        Time.parse(access_hash[:updated_at])
      end

      def expires_at
        updated_at + expires_in
      end

      def expired?
        # puts access_hash, authorized?, expires_at, Time.now
        !authorized? || Time.now > expires_at
      end

      def remain_refresh_count
        (access_hash[:remain_refresh_count] || 12).to_i
      end

      def authorized?
        !access_token.nil?
      end

      def destory
        save_token({})
      end
    end
  end
end
