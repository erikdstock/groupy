class MonthlyTopArtist < ApplicationRecord
    belongs_to :user
  belongs_to :artist, autosave: true

  include TimeTools

  # updated_at month is greater than self's month property
  def final?
    month_in_question = month
    final_second = month_end(month_in_question)
    (final_second > updated_at) && !this_month?
  end

  def give_to_verified?
    artist.give_to_verified
  end

  private

  def this_month?
    if month.year == updated_at.year && month.month == updated_at.month
      logger.warn "Current month- maybe deal with this more selectively some day"
      return true
    end
    false
  end
end
