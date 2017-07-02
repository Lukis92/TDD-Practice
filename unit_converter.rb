# UnitConverter.new.convert(2, :cup, :liter) # => 0.473
# UnitConverter.new.convert(2, :cup, :gram) # => DimensionalMismatchError!!!
# require "rspec/autorun"
require 'pry'

DimensionalMismatchError = Class.new(StandardError)

Quantity = Struct.new(:amount, :unit) #Struct = Ruby class take number of arguments and provide getter and setter

class UnitConverter
  def initialize(initial_quantity, target_unit)
    @initial_quantity = initial_quantity
    @target_unit = target_unit
  end

  def convert
    Quantity.new(
    @initial_quantity.amount * conversion_factor(from: @initial_quantity.unit, to: @target_unit),
    @target_unit
    )
  end

  private

  # No need to test private method, user can't call it
  CONVERSION_FACTORS = {
    liter: {
      cup: 4.226775,
      liter: 1,
      pint: 2.11338
    },
    gram: {
      gram: 1,
      kilgram: 1000
    }
  }

  # If common unit is found then convert the unit
  # else return DimensionalMismatchError
  def conversion_factor(from:, to:)
    dimension = common_dimension(from, to)
    unless dimension.nil?
      CONVERSION_FACTORS[dimension][to] / CONVERSION_FACTORS[dimension][from]
    else
      raise(DimensionalMismatchError, "Can't convert from #{from} to #{to}")
    end
  end

  # Find the common dimension between 2 units
  # Search through CONVENSION_FACTORS and find the common unit(key) that is included in both unit
  def common_dimension(from, to)
    CONVERSION_FACTORS.keys.find do |canonical_unit|
      CONVERSION_FACTORS[canonical_unit].keys.include?(from) && CONVERSION_FACTORS[canonical_unit].keys.include?(to)
    end
  end
end

# TESTS

describe UnitConverter do
  describe "#convert" do
    xit 'translates between objects of the same dimension' do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :liter)

      result = converter.convert

      expect(result.amount).to be_within(0.001).of(0.473)
      expect(result.unit).to eq(:liter)
    end

    it "can convert between quantities of the same unit" do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :cup)

      result = converter.convert

      expect(result.amount).to be_within(0.001).of(2)
      expect(result.unit).to eq(:cup)
    end

    xit 'raises an error if the two quantities are of differing dimensions' do
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :gram)

      # pass in a { block } to raise an error
      expect { converter.convert }.to raise_error(DimensionalMismatchError)
    end
  end
end
