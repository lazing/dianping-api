module Dianping
  module Api
    module Modules
      module Tuangou
        def receipt_pre_code(shop_uuid, code)
          post('/router/tuangou/receipt/prepare', open_shop_uuid: shop_uuid, receipt_code: code)
        end

        def receipt_consume(shop_uuid, code, count = 1, request_id = nil, **params)
          params.merge! open_shop_uuid: shop_uuid,
                        receipt_code: code,
                        requestid: request_id || requestid,
                        count: count
          keys = %i[requestid receipt_code count open_shop_uuid app_shop_account app_shop_accountname]
          raise "missing keys #{keys - params.keys}" unless (keys - params.keys).empty?

          post '/router/tuangou/receipt/consume', params
        end

        def shop_deals(shop_deals)
          get('/tuangou/deal/queryshopdeal', open_shop_uuid: shop_deals)
        end
      end
    end
  end
end
