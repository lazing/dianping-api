module Dianping
  module Api
    module Modules
      module Tuangou
        def receipt_pre_code(shop_uuid, code)
          post('/router/tuangou/receipt/prepare', open_shop_uuid: shop_uuid, receipt_code: code)
        end

        def receipt_consume(shop_uuid, code, request_id, count = 1, **params)
          params.merge! open_shop_uuid: shop_uuid,
                        receipt_code: code,
                        request_id: request_id,
                        count: count

          post '/router/tuangou/receipt/consume', params
        end

        def shop_deals(shop_deals)
          get('/tuangou/deal/queryshopdeal', open_shop_uuid: shop_deals)
        end
      end
    end
  end
end
