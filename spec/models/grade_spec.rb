require 'spec_helper'

describe Grade do
  it "should be valid with just a title" do
    grade = Grade.new(:title => "Pre-K")
    grade.should be_valid
  end

  it "should not be valid with duplicate title" do
    grade_one = Grade.create(:title => "Pre-K")
    grade_two = Grade.new(:title => "Pre-K")
    grade_two.should_not be_valid
  end

  it "should not be valid with duplicate title (case insensitive)" do
    grade_one = Grade.create(:title => "Pre-K")
    grade_two = Grade.new(:title => "pre-k")
    grade_two.should_not be_valid
  end

  it "should not be valid with title set to nil" do
    grade = Grade.new(:title => nil)
    grade.should_not be_valid
  end

  it "should not be valid with title set to empty" do
    grade = Grade.new(:title => '')
    grade.should_not be_valid
  end

  describe "resources" do
    it "should respond to resources" do 
      grade = Grade.new(:title => "Pre-K")
      grade.should respond_to(:resources)
    end
  end
end
