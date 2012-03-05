module SitePrism::ElementChecker
  def all_there?
    Capybara.using_wait_time(0) do
      !self.class.element_names.map {|element| self.send "has_#{element}?" }.include? false
    end
  end
end

