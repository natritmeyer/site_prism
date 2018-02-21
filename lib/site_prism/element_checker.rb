# frozen_string_literal: true

module SitePrism
  module ElementChecker
    def all_there?
      self.class.mapped_items.all? { |element| send "has_#{element}?" }
    end
  end
end
