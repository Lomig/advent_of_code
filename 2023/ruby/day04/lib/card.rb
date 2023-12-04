# frozen_string_literal: true

class Card
  attr_reader :copies
  private attr_reader :wallet, :id, :rewarded_card_count

  def initialize(wallet:, id:, winning:, scratched:)
    @wallet = wallet
    @id = id
    @rewarded_card_count = winning.intersection(scratched).count
    @copies = 1
  end

  def score = rewarded_card_count.zero? ? 0 : 2**(rewarded_card_count - 1)

  def scratch = wallet.add_cards(id:, rewarded_card_count:, copies:)

  def add_copies!(count:)
    @copies += count
  end
end
