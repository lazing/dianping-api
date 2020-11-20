require File.expand_path('../../../spec_helper', __FILE__)

module Dianping::Api
  RSpec.describe Client do
    let(:app_key) { 'app_key' }
    let(:app_secret) { 'app_secret' }

    context :setup do
      subject { Client.new(app_key, app_secret) }
      its(:connection) { should_not be_nil }
      it(:get_root) { expect { subject.connection.get('/') }.not_to raise_error }
    end
  end
end