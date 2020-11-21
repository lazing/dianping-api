require "dianping/api/version"

module Dianping
  module Api
    class UsageError < StandardError; end
    class Error < StandardError; end

  end
end

require 'dianping/api/middle_ware'
require 'dianping/api/token'
require 'dianping/api/client'

Faraday::Request.register_middleware dianping: ::Dianping::Api::MiddleWare