# frozen_string_literal: true

class Announcement < ApplicationRecord
  scope :live, ->(now = Time.now.utc) { where(arel_table[:scheduled_at].lteq(now)).where(arel_table[:ends_at].eq(nil).or(arel_table[:ends_at].gteq(now))) }

  def mentions
    @mentions ||= Account.from_text(text)
  end

  def tags
    @tags ||= Tag.find_or_create_by_names(Extractor.extract_hashtags(text))
  end

  def emojis
    @emojis ||= CustomEmoji.from_text(text)
  end
end
