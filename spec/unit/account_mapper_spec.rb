require 'sequel/core'
require_relative '../../model/account_mapper'

module Scrooge
  describe AccountMapper do
    let(:dataset) { double("Dataset") }
    let(:mapper) { AccountMapper.new(dataset) }
    let(:account) do
      account = Account.new("Test account")
      account.id = 1
      account
    end

    describe '#insert' do
      it 'calls insert on the dataset' do
        dataset.should_receive(:insert).with(name: account.name)

        mapper.insert(account)
      end
    end

    describe '#update' do
      it 'calls update on the dataset' do
        account_dataset = double("Account dataset")
        dataset.should_receive(:where).with(id: account.id).and_return(account_dataset)
        account_dataset.should_receive(:update).with(name: account.name)

        mapper.update(account)
      end
    end

    describe '#delete' do
      it 'calls delete on the dataset' do
        dataset.should_receive(:delete).with(id: account.id)

        mapper.delete(account)
      end
    end

    describe '#find' do
      it 'calls where on the dataset' do
        record = { id: 1, name: "Test account" }
        account_dataset = double("Account dataset")
        dataset.should_receive(:where).with(id: 1).and_return(account_dataset)
        account_dataset.should_receive(:first).and_return(record)
        account_dataset.should_receive(:empty?).and_return(false)

        found = mapper.find(id: 1)

        found.should be_instance_of Account
        found.id.should == 1
        found.name.should == "Test account"
      end

      it 'returns nil if no account is found' do
        empty_dataset = double("Empty dataset")
        dataset.should_receive(:where).with(id: 99).and_return(empty_dataset)
        empty_dataset.should_receive(:empty?).and_return(true)

        found = mapper.find(id: 99)

        found.should be_nil
      end
    end
  end
end
