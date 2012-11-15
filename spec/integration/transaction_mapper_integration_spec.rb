require 'rspec'
require_relative '../../model/transaction_mapper'

module Scrooge
  describe TransactionMapper do
    let(:dataset) {
      db = Sequel.sqlite
      db.create_table :transactions do
        primary_key :id
        String :description
        BigDecimal :amount, size: [10, 2]
      end
      db[:transactions]
    }
    let(:mapper) { TransactionMapper.new(dataset) }
    let(:transaction) { Transaction.new("Test transaction", 12.34) }

    describe '#save' do
      context 'when the transaction has never been saved' do
        it 'inserts the transaction' do
          mapper.save(transaction)
          found = mapper.find(id: transaction.id)
          found.description.should == transaction.description
          found.amount.should == transaction.amount
        end
      end

      context 'when the transaction has already been saved' do
        it 'updates the transaction' do
          mapper.save(transaction)
          transaction.description = "Test transaction new description"
          transaction.amount = 56.78
          mapper.save(transaction)
          found = mapper.find(id: transaction.id)
          found.description.should == transaction.description
          found.amount.should == transaction.amount
        end
      end
    end

    describe '#find' do
      it 'finds a previously inserted transaction by id' do
        mapper.save(transaction)
        found = mapper.find(id: transaction.id)
        found.id.should == transaction.id
        found.description.should == transaction.description
        found.amount.should == transaction.amount
      end
    end

    describe '#delete' do
      it 'deletes a transaction successfully' do
        mapper.save(transaction)
        mapper.find(id: transaction.id).should_not be_nil
        mapper.delete(transaction)
        mapper.find(id: transaction.id).should be_nil
      end
    end
  end
end
