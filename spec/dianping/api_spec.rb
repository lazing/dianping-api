require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Dianping::Api do

  it :client do

    expect { Dianping::Api.client }.to raise_error Dianping::Api::Error

    client = Dianping::Api.client do |klass|
      klass.new 'app_key', 'secret'
    end

    expect(Dianping::Api.client).to eq(client)
  end
  
  describe Dianping::Api::Error do
  end
end
