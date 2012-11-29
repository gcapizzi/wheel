require 'spec_helper'
require_relative '../../lib/mapper'

module Scrooge

  class Fake < Struct.new(:id, :one, :two, :three); end

  describe Mapper do
    let(:db) do
      db = Sequel.sqlite
      db.create_table :fake do
        primary_key :id
        String :one
        Integer :two
        Decimal :three
      end
      db
    end
    let (:mapping) do
      mapping = Mapping.new
      mapping.maps Fake, to: :fake
      mapping.fields :one, :two, :three
      mapping
    end
    let(:mapper) { Mapper.new(db, mapping) }
    let(:object) { Fake.new(nil, "one", 2, 3.0) }

    describe '#save' do
      context 'when the object has never been saved' do
        it 'calls insert on the dataset and sets the object id' do
          mapper.save(object)
          found = mapper.find(object.id)
          found.one.should == object.one
          found.two.should == object.two
          found.three.should == object.three
        end
      end

      context 'when the object has already been saved' do
        it 'calls update on the dataset' do
          mapper.save(object)
          object.one = "new one"
          object.two = 22
          object.three = 3.33
          mapper.save(object)
          found = mapper.find(object.id)
          found.one.should == object.one
          found.two.should == object.two
          found.three.should == object.three
        end
      end
    end

    describe '#find' do
      it 'finds a previously inserted account' do
        mapper.save(object)
        found = mapper.find(object.id)
        found.id.should == object.id
        found.one.should == object.one
        found.two.should == object.two
        found.three.should == object.three
      end
    end

    describe '#delete' do
      it 'deletes an account successfully' do
        mapper.save(object)
        mapper.find(object.id).should_not be_nil
        mapper.delete(object)
        mapper.find(object.id).should be_nil
      end
    end
  end

end
