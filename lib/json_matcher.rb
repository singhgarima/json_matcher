require 'term/ansicolor'
require 'json'
require 'json_matcher/version'
module JsonMatcher

  def self.similar(actual, expected)
    result = Matcher.new(actual, expected)
    result.similar? ? nil : result.to_s
  end

  class Matcher
    include Term::ANSIColor

    def initialize actual, expected, opt = {}
      @actual = JSON.parse actual
      @expected = JSON.parse expected
      @failure_msg = { :extra => {}, :less => {}}
    end

    def similar?
      return equal_without_order
    end

    def to_s
      red { bold {"Diff:\n+#{@failure_msg[:extra].to_json}\n-#{@failure_msg[:less].to_json}" } }
    end

    private
    def equal_without_order
      return true if @actual == @expected
      @failure_msg[:extra] = @actual.select {|key,val| !@expected.keys.include? key}
      @failure_msg[:less] = @expected.select {|key,val| !@actual.keys.include? key}
      hash_matcher @actual, @expected
      @failure_msg[:extra].length == 0 and @failure_msg[:less].length == 0
    end

    def hash_matcher first, second
      first.each do |key, value|
        return false unless first[key].class == second[key].class
        if value and @expected[key]
          if first[key].is_a? Hash
            hash_matcher first[key], second[key]
          elsif first[key].is_a? Array
            if value.sort != second[key].sort
              @failure_msg[:extra].merge!(key => value)
              @failure_msg[:less].merge!(key => second[key])
            end
          else
            if value != second[key]
              @failure_msg[:extra].merge!(key => value)
              @failure_msg[:less].merge!(key => second[key])
            end
          end
        end
      end
    end

  end
end
