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
  end
end
