# Dianping::Api

美团点评北极星平台Open API SDK for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dianping-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dianping-api

## Usage

注册 https://open.dianping.com 按开发测试说明使用

```ruby

# redirect_url 专门给获取access_token (session)使用
client = Dianping::Api::Client.new 'app_key', 'app_secrent', redirect_url: 'https://example.org/callback'

# 公共请求参数会自动提供并签名
# 正常结果 `code 200` 以外的返回报文会抛出异常
body_json = client.post '/routers/xxxx', biz_key1: 1, biz_key2: 2 
body_json = client.get '/routers/xxxx', url_key1: 1, url_key2: 2 

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dianping-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
