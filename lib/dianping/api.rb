require 'dianping/api/version'
require 'faraday'
require 'logger'

module Dianping
  module Api
    class TokenExpireError < Faraday::RetriableResponse; end
    class Error < StandardError; end
    class TokenMissingError < Error; end
    class UsageError < Error; end

    def self.logger
      @@logger ||= defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT)
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.client
      return @client = yield(Client) if block_given?

      @client || raise(::Dianping::Api::Error, 'initialize client with block first')
    end

    module Modules; end
  end
end

require 'dianping/api/modules/tuangou'

require 'dianping/api/middle_ware'
require 'dianping/api/token'
require 'dianping/api/client'

Faraday::Request.register_middleware dianping: ::Dianping::Api::MiddleWare
