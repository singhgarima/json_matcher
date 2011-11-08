require 'spec_helper'

describe JsonMatcher do
  it "should check if both json arguments match" do
    actual = { :key => "value" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_true
  end

  it "should check if both json arguments dont match" do
    actual = { :key => "value1" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_false
  end

  it "should check if number of keys are unequal" do
    actual = { :key => "value", :extra_key => "value" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_false
  end

  it "should check if number of keys are equal but values aren't" do
    actual = { :key => "value", :extra_key => "value" }.to_json
    expected = { :key => "value", :extra_key => "value_new" }.to_json
    JsonMatcher.similar(actual, expected).should be_false
  end

  it "should check if number of keys are equal, values are equal but order is different" do
    actual = { :key => "value", :extra_key => "value2", :another_key => "value3" }.to_json
    expected = { :extra_key => "value2", :another_key => "value3", :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_true
  end

  it "should check if number of keys and values are equal but array value is not sorted" do
    actual = { :key => "value", :extra_key => "value2", :array_key => [1,2,3] }.to_json
    expected = { :extra_key => "value2", :array_key => [3,2,1], :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_true
  end
end
