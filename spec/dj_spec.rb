require 'spec_helper'

describe Dj do
  describe '#request' do
    it "subtracts request by 1" do
      test_dj = Dj.create({name: 'test', requests: 4})
      test_dj.request
      expect test_dj.requests to eq 3
    end
  end
end
