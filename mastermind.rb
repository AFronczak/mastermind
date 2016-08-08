class MasterMind
  PEG_COLORS = %w{Blue Orange Green Purple Yellow Pink}

  attr_accessor :secret

  def initialize
    @secret = PEG_COLORS.shuffle.take(4)
    @guess_history = []
    @result_history = []
  end

  # How many guesses have we done?
  def guess_count
    @guess_history.length
  end

  # Array of all previous guesses
  def guess_history
    @guess_history.dup
  end

  # Array of all results
  def result_history
    @result_history
  end

  # boolean, true if this result is a `win`
  def result_win?(result)
    result == [:exact_match]*4
  end

  # Make a guess, guess should be an Array
  # of four colors. The colors should be Strings
  # from PEG_COLORS
  #
  # Returns an array of four symbols, one for each
  # peg color supplied in the guess argument.
  #
  # If that color was correct *and* in the right
  # position, the value will be :exact_match. If
  # the color is correct but the position is wrong
  # the value will be :inexact_match. If the color
  # is totally wrong, the value will be :miss
  #
  # Example:
  #
  # ruby mastermind.rb
  #
  # The Game's secret is ["Pink", "Green", "Blue", "Purple"]
  # And when guessing ["Red", "Green", "Green", "Blue"]
  # the result is [:miss, :exact_match, :miss, :inexact_match]
  #
  def guess(guess)
    @guess_history << guess

    secret_dup = @secret.dup
    guess_dup  = guess.dup

    exact_match_indexes = []
    secret_dup.each.with_index do |color, index|
      exact_match_indexes << index if secret_dup[index] == guess_dup[index]
    end

    exact_match_indexes.reverse_each do |index|
      secret_dup.delete_at(index)
      guess_dup.delete_at(index)
    end

    inexact_match_indexes = []
    guess_dup.each.with_index do |color, index|
      if secret_dup.include?(color)
        inexact_match_indexes << guess.index(color)
        secret_dup.delete_at(secret_dup.index(color))
      end
    end

    result = [:miss] * 4
    exact_match_indexes.each do |index|
      result[index] = :exact_match
    end

    inexact_match_indexes.each do |index|
      result[index] = :inexact_match
    end

    @result_history << result

    result
  end
end

# This code allows us to run what is inside the
# if statement if you run this script directly
# (e.g. ruby mastermind.rb)
#
# Otherwise when `require_relative` this code
# this doesn't run.
#
# This lets you "test out" the MasterMind class
# to see if you understand how it works.
#
if $0 == __FILE__
  game = MasterMind.new
  user_guess = ["Red", "Green", "Green", "Blue"]
  result = game.guess(user_guess)
  puts "The Game's secret is #{game.secret.inspect}"
  puts "And when guessing #{user_guess.inspect}"
  puts "the result is #{result.inspect}"
end
