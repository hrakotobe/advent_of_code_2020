# frozen_string_literal: true

class Game
  attr_accessor :decks, :winner, :history

  def initialize
    @decks = []
  end

  def parse_decks(input)
    current_player = -1
    input.each do |raw_line|
      line = raw_line.strip
      next if line.empty?

      player = line.match(/Player (\d+):/)
      unless player.nil?
        current_player += 1
        @decks[current_player] = []
        next
      end

      @decks[current_player] << line.to_i
    end

    @winner = nil
  end

  def play_round
    draw = @decks.map(&:shift)
    winning_player = draw.find_index(draw.max)
    @decks[winning_player] << draw.sort { |a, b| b <=> a }
    @decks[winning_player].flatten!
    @winner = winning_player if @decks.any?(&:empty?)
  end

  def play_recursive_round(local_decks = nil, sub_round = false, history = {})
    local_decks ||= @decks
    state = local_decks.map(&:join).join('-')

    # infinite loop control
    if history[state]
      cards = local_decks.flatten
      local_decks.replace([[]] * local_decks.length)
      local_decks[0] = cards
      @winner = 0 unless sub_round

      return 0
    end
    history[state] = true

    draw = local_decks.map(&:shift)
    need_recurse_round = draw.each_with_index.map { |card, player| local_decks[player].count >= card }.all?(true)

    winning_player = nil
    if need_recurse_round
      sub_decks = draw.each_with_index.map { |card, player| local_decks[player][0...card] }
      loop do
        winning_player = play_recursive_round(sub_decks, true, history)
        break if sub_decks.any?(&:empty?)
      end
    else
      winning_player = draw.find_index(draw.max)
    end

    card = draw.delete_at(winning_player)
    draw.unshift(card)
    local_decks[winning_player] << draw
    local_decks[winning_player].flatten!

    return unless local_decks.any?(&:empty?)

    @winner ||= winning_player unless sub_round
    winning_player
  end

  def score
    winning_deck = @decks[winner]
    winning_deck.each_with_index.map { |card, index| card * (winning_deck.length - index) }.sum
  end
end
