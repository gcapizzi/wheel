require 'rspec'
require_relative '../../model/account_mapper'

module Scrooge
  describe AccountMapper do
    let(:dataset) {
      db = Sequel.sqlite
      db.create_table :accounts do
        primary_key :id
        String :name
      end
      db[:accounts]
    }
    let(:mapper) { AccountMapper.new(dataset) }
    let(:account) do
      account = Account.new("Test account")
      account.id = 1
      account
    end

    it 'finds a previously inserted account' do
      mapper.insert(account)
      found = mapper.find(id: account.id)
      found.id.should == account.id
      found.name.should == account.name
    end
  end
end
