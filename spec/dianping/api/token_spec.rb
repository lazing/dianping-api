require File.expand_path('../../../spec_helper', __FILE__)

module Dianping::Api
  RSpec.describe Token do

    let(:client) { double(:client) }

    subject do
      allow(client).to receive(:app_key) { 'app_key' }
      Token.new(client)
    end

    context :tokens do
      it :can_save_token do
        auth_hash = {
          access_token: "6b53c12aadbe71b150a1a0c4958fabcd69daf52e",
          expires_in: 100,
          token_type: "bearer",
          scope: "tuangou,ugc,poi,shopping,,merchant_data",
          refresh_token: "cb9023ebe8aae27592a446aa41978b78032e3435",
          bid: "a12312b2312c",
          code: 200,
          msg: nil
        }

        subject.save_token(auth_hash)
      end

      it { should be_authorized }
      its(:access_token) { should match(/^6b53/) }
      its(:expires_in) { should eq(100) }
      its(:expires_at) { should <= (Time.now + 100) }
      its(:remain_refresh_count) { should eq(12) }
      it { should_not be_expired }
    end

    context :token_destory do
      it { expect { subject.destory }.not_to raise_error }
    end
  end
end
