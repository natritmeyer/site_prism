module SitePrism::ElementChecker
  def all_there?
    Capybara.using_wait_time(0) do
      self.class.element_names.all? {|element| send "has_#{element}?" }
    end
  end
end

