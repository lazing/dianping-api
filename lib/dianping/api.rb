require 'dianping/api/version'
require 'faraday'

module Dianping
  module Api
    class TokenExpireError < Faraday::RetriableResponse; end
    class TokenMissingError < StandardError; end
    class UsageError < StandardError; end
    class Error < StandardError; end

    module Modules; end
  end
end

require 'dianping/api/modules/tuangou'

require 'dianping/api/middle_ware'
require 'dianping/api/token'
require 'dianping/api/client'

Faraday::Request.register_middleware dianping: ::Dianping::Api::MiddleWare
