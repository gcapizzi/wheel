module Scrooge
  class AccountMapper
    def initialize(dataset)
      @dataset = dataset
    end

    def insert(account)
      @dataset.insert(name: account.name)
    end

    def update(account)
      @dataset.where(id: account.id).update(name: account.name)
    end

    def delete(account)
      @dataset.delete({id: account.id})
    end

    def find(args)
      record = @dataset.where(args)

      if !record.empty?
        record = record.first
        account = Account.new()
        account.id = record[:id]
        account.name = record[:name]
      end

      return account
    end
  end
end
