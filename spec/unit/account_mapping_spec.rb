require 'spec_helper'

module Scrooge
  describe AccountMapping do
    let(:record) { { name: "Test account" } }
    let(:saved_record) { record.merge(id: 1) }
    let(:account) { a = Account.new("Test account"); a.id = 1; a }
    let(:mapping) { AccountMapping.new }

    describe '#from_record' do
      it 'builds an Account instance from a hash' do
        mapped_account = mapping.from_record(saved_record)

        mapped_account.should be_instance_of Account
        mapped_account.id.should == 1
        mapped_account.name.should == "Test account"
      end
    end

    describe '#to_record' do
      it 'builds a hash from an Account instance' do
        mapping.to_record(account).should == record
      end
    end
  end
end
