module SitePrism
  module ElementChecker
    def all_there?
      Capybara.using_wait_time(0) do
        self.class.mapped_items.all? { |element| send "has_#{element}?" }
      end
    end
  end
end
