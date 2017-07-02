# Use TDD principles to build out name functionality for a Person.
# Here are the requirements:
# - Add a method to return the full name as a string. A full name includes
#   first, middle, and last name. If the middle name is missing, there shouldn't
#   have extra spaces.
# - Add a method to return a full name with a middle initial. If the middle name
#   is missing, there shouldn't be extra spaces or a period.
# - Add a method to return all initials. If the middle name is missing, the
#   initials should only have two characters.
#
# We've already sketched out the spec descriptions for the #full_name. Try
# building the specs for that method, watch them fail, then write the code to
# make them pass. Then move on to the other two methods, but this time you'll
# create the descriptions to match the requirements above.

class Person
  def initialize(first_name:, middle_name: nil, last_name:)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name
    [@first_name,@middle_name, @last_name].join(' ').squeeze(' ')
  end

  def full_name_with_middle_initial
    [@first_name,@middle_name ? @middle_name[0] : '', @last_name].join(' ').squeeze(' ')
  end

  def initials
    [@first_name[0], @middle_name ? @middle_name[0] : '', @last_name[0]].join(' ').squeeze(' ')
  end
end

RSpec.describe Person do
  let(:p) { Person.new(first_name: "Adam", middle_name: "Włodzimierz", last_name: "Nowak")}
  let(:p2) { Person.new(first_name: "Adam", last_name: "Nowak")}

  describe "#full_name" do
    it "concatenates first name, middle name, and last name with spaces" do
      expect(p.full_name).to eq('Adam Włodzimierz Nowak')
    end
    it "does not add extra spaces if middle name is missing" do
      expect(p2.full_name).to eq('Adam Nowak')
    end
  end

  describe "#full_name_with_middle_initial" do
    it "returns a full name with middle initial" do
      expect(p.full_name_with_middle_initial).to eq('Adam W Nowak')
    end

    it "returns a fullname without middle initial" do
      expect(p2.full_name_with_middle_initial).to eq('Adam Nowak')
    end
  end

  describe "#initials" do
    it 'returns all initials' do
      expect(p.initials).to eq('A W N')
    end

    it 'returns all initials without middle_name' do
      expect(p2.initials).to eq('A N')
    end
  end
end
