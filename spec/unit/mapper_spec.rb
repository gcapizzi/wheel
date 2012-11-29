require 'spec_helper'
require 'ostruct'
require_relative '../../lib/mapper'

module Scrooge

  describe Mapper do
    let(:db) { double("DB") }
    let(:dataset) { double("Dataset") }
    let(:object_dataset) { double("Object dataset") }
    let(:empty_dataset) { double("Empty dataset") }
    let(:mapping) { double("Mapping") }
    let(:mapper) { Mapper.new(db, mapping) }
    let(:table) { :fake }

    let(:attributes) { { a: 1, b: 2, c: 3 } }
    let(:saved_attributes) { attributes.merge(id: 1) }
    let(:object) { double("Object") }

    def should_get_table_dataset!
      mapping.should_receive(:table).and_return(table)
      db.should_receive(:[]).with(table).and_return(dataset)
    end

    def should_get_object_dataset!
      object.should_receive(:id).at_least(:once).and_return(1)
      dataset.should_receive(:where).with(id: 1).and_return(object_dataset)
    end

    describe '#save' do
      context 'when the object has never been saved' do
        it 'calls insert on the dataset and sets the object id' do
          should_get_table_dataset!
          mapping.should_receive(:to_record).with(object)
            .and_return(attributes)
          object.should_receive(:id).and_return(nil)
          dataset.should_receive(:insert).with(attributes).and_return(1)
          object.should_receive(:id=).with(1)

          mapper.save(object)
        end
      end

      context 'when the object has already been saved' do
        it 'calls update on the dataset' do
          should_get_table_dataset!
          should_get_object_dataset!
          mapping.should_receive(:to_record).with(object)
            .and_return(attributes)
          object_dataset.should_receive(:update).with(attributes)

          mapper.save(object)
        end
      end
    end

    describe '#delete' do
      context 'when the object has already been saved' do
        it 'calls delete on the dataset' do
          should_get_table_dataset!
          should_get_object_dataset!
          object_dataset.should_receive(:delete)

          mapper.delete(object)
        end
      end

      context 'when the object has never been saved' do
        it 'does nothing' do
          object.should_receive(:id).and_return(nil)
          dataset.should_not_receive(:where)

          mapper.delete(object)
        end
      end
    end

    describe '#find' do
      it 'calls where on the dataset' do
        should_get_table_dataset!
        dataset.should_receive(:where).with(id: 1).and_return(object_dataset)
        object_dataset.should_receive(:empty?).and_return(false)
        object_dataset.should_receive(:first).and_return(saved_attributes)
        mapping.should_receive(:from_record).with(saved_attributes)
          .and_return(object)

        found = mapper.find(1)

        found.should == object
      end

      it 'returns nil if no object is found' do
        should_get_table_dataset!
        dataset.should_receive(:where).with(id: 99).and_return(empty_dataset)
        empty_dataset.should_receive(:empty?).and_return(true)

        found = mapper.find(99)

        found.should be_nil
      end
    end
  end

end
