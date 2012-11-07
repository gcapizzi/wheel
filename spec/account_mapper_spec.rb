require 'sequel/core'
require_relative '../model/account_mapper.rb'

module Scrooge
  describe AccountMapper do
    describe '#insert' do
      it 'calls insert on the db' do
        db = double("DB")
        db.should_receive(:insert).with(name: "Test account")

        mapper = AccountMapper.new(db)
        mapper.insert(Account.new("Test account"))
      end
    end
  end
end
