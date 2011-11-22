require 'term/ansicolor'
require 'json'
require 'json_matcher/version'
module JsonMatcher

  def self.similar(actual, expected, opts = {})
    result = Matcher.new(actual, expected, opts)
    result.similar? ? nil : result.to_s
  end

  class Matcher
    include Term::ANSIColor

    def initialize actual, expected, opts = {}
      @actual = actual
      @expected = expected
      @actual_hash = JSON.parse actual
      @expected_hash = JSON.parse expected
      @options = opts
      @failure_msg = { :extra => {}, :less => {}}
    end

    def similar?

      return @options[:exact] ? equal : equal_without_order
    end

    def to_s
      red { bold {"Diff:\n+#{@failure_msg[:extra].to_json}\n-#{@failure_msg[:less].to_json}" } }
    end

    private
    def equal
      @actual == @expected
    end

    def equal_without_order
      return true if @actual_hash == @expected_hash
      @failure_msg[:extra] = @actual_hash.select {|key,val| !@expected_hash.keys.include? key}
      @failure_msg[:less] = @expected_hash.select {|key,val| !@actual_hash.keys.include? key}
      hash_matcher @actual_hash, @expected_hash
      @failure_msg[:extra].length == 0 and @failure_msg[:less].length == 0
    end

    def hash_matcher first, second
      first.each do |key, value|
        return false unless first[key].class == second[key].class
        if value and second[key]
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
