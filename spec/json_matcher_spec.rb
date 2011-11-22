require 'term/ansicolor'
require 'spec_helper'

describe JsonMatcher do
  it "should check if both json arguments match" do
    actual = { :key => "value" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_nil
  end

  it "should check if both json arguments dont match" do
    actual = { :key => "value1" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should == "\e[31m\e[1mDiff:\n+{\"key\":\"value1\"}\n-{\"key\":\"value\"}\e[0m\e[0m"
  end

  it "should check if number of keys are unequal" do
    actual = { :key => "value", :extra_key => "extra_value" }.to_json
    expected = { :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should == "\e[31m\e[1mDiff:\n+{\"extra_key\":\"extra_value\"}\n-{}\e[0m\e[0m"
  end

  it "should check if number of keys are equal but values aren't" do
    actual = { :key => "value", :extra_key => "value" }.to_json
    expected = { :key => "value", :extra_key => "value_new" }.to_json
    JsonMatcher.similar(actual, expected).should == "\e[31m\e[1mDiff:\n+{\"extra_key\":\"value\"}\n-{\"extra_key\":\"value_new\"}\e[0m\e[0m"
  end

  it "should check if number of keys are equal, values are equal but order is different" do
    actual = { :key => "value", :extra_key => "value2", :another_key => "value3" }.to_json
    expected = { :extra_key => "value2", :another_key => "value3", :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_nil
  end

  it "should check if number of keys and values are equal but array value is not sorted" do
    actual = { :key => "value", :extra_key => "value2", :array_key => [1,2,3] }.to_json
    expected = { :extra_key => "value2", :array_key => [3,2,1], :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should be_nil
  end

  it "should not match if array for the a key doesnt match and give required error" do
    actual = { :key => "value", :array_key => [1,2,3] }.to_json
    expected = { :array_key => [3,2,1,4], :key => "value" }.to_json
    JsonMatcher.similar(actual, expected).should == "\e[31m\e[1mDiff:\n+{\"array_key\":[1,2,3]}\n-{\"array_key\":[3,2,1,4]}\e[0m\e[0m"
  end

  it "should match if json with a hash with a array has different sort but exact value" do
    actual = { :key => "value", :array_key => [1,2,3], :hash_key => { :normal_key => 1, :array_key => [4,5,6] }, :zkey => 9 }.to_json
    expected = { :array_key => [3,2,1], :key => "value", :hash_key => { :array_key => [6,4,5], :normal_key => 1 }, :zkey =>9 }.to_json
    JsonMatcher.similar(actual, expected).should be_nil
  end

  it "should not match if json with a hash with a array has different sort but exact value" do
    actual = { :key => "value", :array_key => [1,2,3], :hash_key => { :normal_key => 1, :array_key => [4,5,6,7] } }.to_json
    expected = { :array_key => [3,2,1], :key => "value", :hash_key => { :array_key => [6,4,5], :normal_key => 1 } }.to_json
    JsonMatcher.similar(actual, expected).should == "\e[31m\e[1mDiff:\n+{\"array_key\":[4,5,6,7]}\n-{\"array_key\":[6,4,5]}\e[0m\e[0m"
  end
end
