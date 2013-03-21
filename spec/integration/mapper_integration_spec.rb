require 'logger'
require 'spec_helper'
require_relative '../../lib/mapper'

module Wheel

  class Fake < Struct.new(:id, :one, :two, :three); end

  describe Mapper do
    let(:db) do
      db = Sequel.sqlite ''
      db.create_table :fake do
        primary_key :id
        String :one
        Integer :two
        Decimal :three
      end
      db
    end
    let (:mapping) do
      mapping = Mapping.new(Fake)
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
          expect(found.one).to eq(object.one)
          expect(found.two).to eq(object.two)
          expect(found.three).to eq(object.three)
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
          expect(found.one).to eq(object.one)
          expect(found.two).to eq(object.two)
          expect(found.three).to eq(object.three)
        end
      end
    end

    describe '#find' do
      it 'finds a previously inserted account' do
        mapper.save(object)
        found = mapper.find(object.id)
        expect(found.id).to eq(object.id)
        expect(found.one).to eq(object.one)
        expect(found.two).to eq(object.two)
        expect(found.three).to eq(object.three)
      end
    end

    describe '#delete' do
      it 'deletes an account successfully' do
        mapper.save(object)
        expect(mapper.find(object.id)).not_to be_nil
        mapper.delete(object)
        expect(mapper.find(object.id)).to be_nil
      end
    end
  end

end
