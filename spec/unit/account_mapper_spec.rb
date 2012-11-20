require 'spec_helper'
require_relative '../../model/account_mapping'

module Scrooge
  describe AccountMapping do
    let(:dataset) { double("Dataset") }
    let(:mapper) { Mapper.new(dataset, AccountMapping.new) }
    let(:account) { Account.new("Test account") }
    let(:saved_account) { a = account; a.id = 1; a }

    describe '#save' do
      context 'when the account has never been saved' do
        it 'calls insert on the dataset and sets the account id' do
          dataset.should_receive(:insert).with(name: account.name).and_return(1)

          mapper.save(account)

          account.id.should == 1
        end
      end

      context 'when the account has already been saved' do
        it 'calls update on the dataset' do
          account_dataset = double("Account dataset")
          dataset.should_receive(:where).with(id: saved_account.id).and_return(account_dataset)
          account_dataset.should_receive(:update).with(name: account.name)

          mapper.save(saved_account)
        end
      end
    end

    describe '#delete' do
      context 'when the account has already been saved' do
        it 'calls delete on the dataset' do
          account_dataset = double("Account dataset")
          dataset.should_receive(:where).with(id: saved_account.id).and_return(account_dataset)
          account_dataset.should_receive(:delete)

          mapper.delete(saved_account)
        end
      end

      context 'when the account has not been saved' do
         it 'does nothing' do
           dataset.should_not_receive(:where)

           mapper.delete(account)
         end
      end
    end

    describe '#find' do
      it 'calls where on the dataset' do
        record = { id: 1, name: "Test account" }
        account_dataset = double("Account dataset")
        dataset.should_receive(:where).with(id: 1).and_return(account_dataset)
        account_dataset.should_receive(:first).and_return(record)
        account_dataset.stub(:empty?).and_return(false)

        found = mapper.find(1)

        found.should be_instance_of Account
        found.id.should == 1
        found.name.should == "Test account"
      end

      it 'returns nil if no account is found' do
        empty_dataset = double("Empty dataset")
        dataset.should_receive(:where).with(id: 99).and_return(empty_dataset)
        empty_dataset.should_receive(:empty?).and_return(true)

        found = mapper.find(99)

        found.should be_nil
      end
    end
  end
end
