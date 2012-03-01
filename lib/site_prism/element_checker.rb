module SitePrism::ElementChecker
  def all_there?
    !self.class.element_names.map {|element| self.send "has_#{element}?" }.include? false
  end
end

