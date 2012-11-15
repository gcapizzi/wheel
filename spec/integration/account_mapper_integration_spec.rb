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
    let(:account) { Account.new("Test account") }

    describe '#save' do
      it 'updates an account successfully' do
        mapper.save(account)
        account.name = "Test account new name"
        mapper.save(account)
        found = mapper.find(id: account.id)
        found.name.should == account.name
      end
    end

    describe '#find' do
      it 'finds a previously inserted account by id' do
        mapper.save(account)
        found = mapper.find(id: account.id)
        found.id.should == account.id
        found.name.should == account.name
      end

      it 'finds a previously inserted account by name' do
        mapper.save(account)
        found = mapper.find(name: account.name)
        found.id.should == account.id
        found.name.should == account.name
      end
    end

    describe '#delete' do
      it 'deletes an account successfully' do
        mapper.save(account)
        mapper.find(id: account.id).should_not be_nil
        mapper.delete(account)
        mapper.find(id:account.id).should be_nil
      end
    end
  end
end
