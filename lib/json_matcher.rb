require 'json_matcher/version'
require 'json'
module JsonMatcher

  def self.similar actual, expected
    return equal_without_order JSON.parse(actual), JSON.parse(expected)
  end

  private
  def self.equal_without_order actual, expected
    return true if actual == expected
    return false if actual.keys.count != expected.keys.count
    actual.each do |key, value|
      return false unless actual[key].class == expected[key].class
      if actual[key].is_a? Array
        return false if actual[key].sort != expected[key].sort
      else
        return false if actual[key] != expected[key]
      end
    end
    true
  end
end
