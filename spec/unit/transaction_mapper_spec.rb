require 'sequel/core'
require_relative '../../model/transaction'
require_relative '../../model/transaction_mapper'

module Scrooge
  describe TransactionMapper do
    let(:dataset) { double("Dataset") }
    let(:mapper) { TransactionMapper.new(dataset) }
    let(:transaction) { Transaction.new("Test transaction", 12.34) }
    let(:saved_transaction) { t = transaction; t.id = 1; t }

    describe '#save' do
      context 'when the transaction has never been saved' do
        it 'calls insert on the dataset and sets the transaction id' do
          args = { description: transaction.description, amount: transaction.amount }
          dataset.should_receive(:insert).with(args).and_return(1)

          mapper.save(transaction)

          transaction.id.should == 1
        end
      end

      context 'when the transaction has already been saved' do
        it 'calls update on the dataset' do
          transaction_dataset = double("Transaction dataset")
          dataset.should_receive(:where).with(id: saved_transaction.id).and_return(transaction_dataset)
          transaction_dataset.should_receive(:update).with(description: transaction.description, amount: transaction.amount)

          mapper.save(saved_transaction)
        end
      end
    end

    describe '#delete' do
      context 'when the transaction has already been saved' do
        it 'calls delete on the dataset' do
          transaction_dataset = double("Transaction dataset")
          dataset.should_receive(:where).with(id: saved_transaction.id).and_return(transaction_dataset)
          transaction_dataset.should_receive(:delete)

          mapper.delete(saved_transaction)
        end
      end

      context 'when the transaction has not been saved' do
         it 'does nothing' do
           dataset.should_not_receive(:where)

           mapper.delete(transaction)
         end
      end
    end

    describe '#find' do
      it 'calls where on the dataset' do
        record = { id: 1, description: "Test transaction", amount: 12.34 }
        transaction_dataset = double("Transaction dataset")
        dataset.should_receive(:where).with(id: 1).and_return(transaction_dataset)
        transaction_dataset.should_receive(:first).and_return(record)
        transaction_dataset.stub(:empty?).and_return(false)

        found = mapper.find(1)

        found.should be_instance_of Transaction
        found.id.should == 1
        found.description.should == "Test transaction"
        found.amount.should == 12.34
      end

      it 'returns nil if no transaction is found' do
        empty_dataset = double("Empty dataset")
        dataset.should_receive(:where).with(id: 99).and_return(empty_dataset)
        empty_dataset.should_receive(:empty?).and_return(true)

        found = mapper.find(99)

        found.should be_nil
      end
    end
  end
end
