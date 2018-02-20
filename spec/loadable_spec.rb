# frozen_string_literal: true

require 'spec_helper'
require 'site_prism/loadable'

describe SitePrism::Loadable do
  let(:loadable) do
    Class.new do
      include SitePrism::Loadable
    end
  end

  describe 'class methods' do
    describe '#load_validations' do
      it 'returns the load_validations from the current and all ancestral classes in hierarchical, defined order' do
        subclass = Class.new(loadable)
        validation1 = -> { true }
        validation2 = -> { true }
        validation3 = -> { true }
        validation4 = -> { true }

        subclass.load_validation(&validation1)
        loadable.load_validation(&validation2)
        subclass.load_validation(&validation3)
        loadable.load_validation(&validation4)

        expect(subclass.load_validations).to eql [validation2, validation4, validation1, validation3]
      end
    end

    describe '#load_validation' do
      it 'adds validations to the load_validations list' do
        expect { loadable.load_validation { true } }.to change { loadable.load_validations.size }.by(1)
      end
    end
  end

  describe '#when_loaded' do
    it 'raises if no block given' do
      expect { loadable.new.when_loaded }.to raise_error(ArgumentError)
    end

    it 'executes and yields itself to the provided block when all load validations pass' do
      loadable.load_validation { true }
      instance = loadable.new

      expect(instance).to receive(:foo)

      instance.when_loaded { |l| l.foo }
    end

    it 'raises an exception if any load validation fails' do
      james_bond = spy

      loadable.load_validation { true }
      loadable.load_validation { false }

      expect do
        loadable.new.when_loaded { james_bond.drink_martini }
      end.to raise_error(SitePrism::NotLoadedError, /no reason given/)

      expect(james_bond).not_to have_received(:drink_martini)
    end

    it 'raises an exception with specific error message if available when a load validation fails' do
      loadable.load_validation { [false, 'all your base are belong to us'] }

      expect do
        loadable.new.when_loaded { :foo }
      end.to raise_error(SitePrism::NotLoadedError, /all your base are belong to us/)
    end

    it 'raises immediately on the first validation failure' do
      validation_spy1 = spy(valid?: false)
      validation_spy2 = spy(valid?: false)

      loadable.load_validation { validation_spy1.valid? }
      loadable.load_validation { validation_spy2.valid? }

      expect do
        loadable.new.when_loaded { puts 'foo' }
      end.to raise_error(SitePrism::NotLoadedError)

      expect(validation_spy1).to have_received(:valid?).once
      expect(validation_spy2).not_to have_received(:valid?)
    end

    it 'executes validations only once for nested calls' do
      james_bond = spy
      validation_spy1 = spy(valid?: true)

      loadable.load_validation { validation_spy1.valid? }
      instance = loadable.new

      instance.when_loaded do
        instance.when_loaded do
          instance.when_loaded do
            james_bond.drink_martini
          end
        end
      end

      expect(james_bond).to have_received(:drink_martini)
      expect(validation_spy1).to have_received(:valid?).once
    end

    it 'resets the loaded cache at the end of the block' do
      loadable.load_validation { true }

      instance = loadable.new
      expect(instance.loaded).to be nil

      instance.when_loaded do |i|
        expect(i.loaded).to be true
      end

      expect(instance.loaded).to be nil
    end
  end

  describe '#loaded?' do
    # We want to test with multiple inheritance
    let(:inheriting_loadable) { Class.new(loadable) }

    it 'returns true if loaded value is cached' do
      validation_spy1 = spy(valid?: true)
      loadable.load_validation { validation_spy1.valid? }
      instance = loadable.new
      instance.loaded = true

      expect(instance).to be_loaded
      expect(validation_spy1).not_to have_received(:valid?)
    end

    it 'returns true if all load validations pass' do
      loadable.load_validation { true }
      loadable.load_validation { true }
      inheriting_loadable.load_validation { true }
      inheriting_loadable.load_validation { true }

      expect(inheriting_loadable.new).to be_loaded
    end

    it 'returns false if any load validation fails' do
      loadable.load_validation { true }
      loadable.load_validation { true }
      inheriting_loadable.load_validation { true }
      inheriting_loadable.load_validation { false }

      expect(inheriting_loadable.new).not_to be_loaded
    end

    it 'returns false if any load validation fails at any point in the inheritance chain' do
      loadable.load_validation { true }
      loadable.load_validation { false }
      inheriting_loadable.load_validation { true }
      inheriting_loadable.load_validation { true }

      expect(inheriting_loadable.new).not_to be_loaded
    end

    it 'sets load_error if a failing load_validation supplies one' do
      loadable.load_validation { [true, 'this cannot fail'] }
      loadable.load_validation { [false, 'fubar'] }
      inheriting_loadable.load_validation { [true, 'this also cannot fail'] }
      inheriting_loadable.load_validation { [true, 'this also also cannot fail'] }

      instance = inheriting_loadable.new
      instance.loaded?
      expect(instance.load_error).to eql 'fubar'
    end
  end
end
