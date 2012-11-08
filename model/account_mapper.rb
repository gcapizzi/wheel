module Scrooge
  class AccountMapper
    def initialize(db)
      @db = db
    end

    def insert(account)
      @db.insert(name: account.name)
    end

    def update(account)
      @db.where(id: account.id).update(name: account.name)
    end

    def delete(account)
      @db.delete({id: account.id})
    end

    def find(args)
      record = @db.where(args)

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
