require 'sequel/core'
require_relative '../model/account_mapper.rb'

module Scrooge
  describe AccountMapper do
    let(:db) { double("DB") }
    let(:dataset) { double("Dataset") }
    let(:mapper) { AccountMapper.new(db) }
    let(:account) do
      account = Account.new("Test account")
      account.id = 1
      account
    end

    describe '#insert' do
      it 'calls insert on the db' do
        db.should_receive(:insert).with(name: account.name)

        mapper.insert(account)
      end
    end

    describe '#update' do
      it 'calls update on the db' do
        db.should_receive(:where).with(id: account.id).and_return(dataset)
        dataset.should_receive(:update).with(name: account.name)

        mapper.update(account)
      end
    end

    describe '#delete' do
      it 'calls delete on the db' do
        db.should_receive(:delete).with(id: account.id)

        mapper.delete(account)
      end
    end
  end
end
