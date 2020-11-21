require File.expand_path('../../../spec_helper', __FILE__)

module Dianping::Api
  RSpec.describe Client do
    let(:app_key) { 'app_key' }
    let(:secret) { 'secret' }

    subject { Client.new(app_key, secret) }

    context :setup do
      its(:connection) { should_not be_nil }
      its(:token) { should be_expired }
      it :auth_process do
        stub_request(:post, /token/).to_return(body: '{"OK": true}')
        subject.auth('1111')
      end
    end

    context :sign do
      let(:token) { double(:token) }
      subject do
        client = Client.new(app_key, secret)
        allow(client).to receive(:token) { token }
        allow(token).to receive(:access_token) { '123' }
        client
      end

      it :sign_with_share do
        signed = subject.sign_with_share(a: 1)
        expect(signed).to have_key(:sign)
      end
    end
  end
end
