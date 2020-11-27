require File.expand_path('../../../spec_helper', __FILE__)

module Dianping::Api
  RSpec.describe MiddleWare do

    let(:client) { double(:client) }
    subject { described_class.new 'app_key', client }

    it { expect { subject.check_response(code: 200) }.not_to raise_error }
    it { expect { subject.check_response(code: 400) }.to raise_error Error }
    it { expect { subject.check_response(code: 608) }.to raise_error TokenExpireError }
    it { expect { subject.check_response(code: 801) }.to raise_error UsageError }
  end
end