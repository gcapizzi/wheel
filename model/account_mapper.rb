module Scrooge
  class AccountMapper
    def initialize(dataset)
      @dataset = dataset
    end

    def save(account)
      if saved? account
        update(account)
      else
        insert(account)
      end
    end

    def delete(account)
      @dataset.where({id: account.id}).delete if saved? account
    end

    def find(id)
      record = @dataset.where(id: id)

      if !record.empty?
        record = record.first
        account = Account.new()
        account.id = record[:id]
        account.name = record[:name]
      end

      return account
    end

    private

    def insert(account)
      id = @dataset.insert(name: account.name)
      account.id = id
    end

    def update(account)
      @dataset.where(id: account.id).update(name: account.name)
    end

    def saved?(account)
      !account.id.nil?
    end
  end
end
