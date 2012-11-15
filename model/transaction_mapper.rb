module Scrooge
  class TransactionMapper
    def initialize(dataset)
      @dataset = dataset
    end

    def save(transaction)
      if saved? transaction
        update(transaction)
      else
        insert(transaction)
      end
    end

    def delete(transaction)
      @dataset.where({id: transaction.id}).delete if saved? transaction
    end

    def find(args)
      record = @dataset.where(args)

      if !record.empty?
        record = record.first
        transaction = Transaction.new()
        transaction.id = record[:id]
        transaction.description = record[:description]
        transaction.amount = record[:amount]
      end

      return transaction
    end

    private

    def insert(transaction)
      id = @dataset.insert(description: transaction.description, amount: transaction.amount)
      transaction.id = id
    end

    def update(transaction)
      @dataset.where(id: transaction.id).update(description: transaction.description, amount: transaction.amount)
    end

    def saved?(transaction)
      !transaction.id.nil?
    end
  end
end
