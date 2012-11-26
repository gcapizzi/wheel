require 'spec_helper'
require_relative '../../lib/mapper'
require_relative '../../lib/mapping/account_mapping'

module Scrooge

  describe Mapper, AccountMapping do
    let(:dataset) {
      db = Sequel.sqlite
      db.create_table :accounts do
        primary_key :id
        String :name
      end
      db[:accounts]
    }
    let(:mapping) { AccountMapping }
    let(:mapper) { Mapper.new(dataset, mapping) }
    let(:account) { Account.new("Test account") }

    describe '#save' do
      context 'when the account has never been saved' do
        it 'calls insert on the dataset and sets the account id' do
          mapper.save(account)
          found = mapper.find(account.id)
          found.name.should == account.name
        end
      end

      context 'when the account has already been saved' do
        it 'calls update on the dataset' do
          mapper.save(account)
          account.name = "Test account new name"
          mapper.save(account)
          found = mapper.find(account.id)
          found.name.should == account.name
        end
      end
    end

    describe '#find' do
      it 'finds a previously inserted account' do
        mapper.save(account)
        found = mapper.find(account.id)
        found.id.should == account.id
        found.name.should == account.name
      end
    end

    describe '#delete' do
      it 'deletes an account successfully' do
        mapper.save(account)
        mapper.find(account.id).should_not be_nil
        mapper.delete(account)
        mapper.find(account.id).should be_nil
      end
    end
  end

end
