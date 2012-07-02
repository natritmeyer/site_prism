module SitePrism::ElementContainer

  def element element_name, element_locator = nil
    if element_locator.nil?
      create_no_locator element_name
    else
      add_element_name element_name.to_s
      define_method element_name.to_s do
        find_one element_locator
      end
    end
    create_existence_checker element_name, element_locator
    create_waiter element_name, element_locator
  end

  def elements collection_name, collection_locator = nil
    if collection_locator.nil?
      create_no_locator collection_name
    else
      add_element_name collection_name
      define_method collection_name.to_s do
        find_all collection_locator
      end
    end
    create_existence_checker collection_name, collection_locator
    create_waiter collection_name, collection_locator
  end
  alias :collection :elements

  def section section_name, section_class, section_locator
    add_element_name section_name
    create_existence_checker section_name, section_locator
    create_waiter section_name, section_locator
    define_method section_name do
      section_class.new find_one section_locator
    end
  end

  def sections section_collection_name, section_class, section_collection_locator
    add_element_name section_collection_name
    create_existence_checker section_collection_name, section_collection_locator
    create_waiter section_collection_name, section_collection_locator
    define_method section_collection_name do
      find_all(section_collection_locator).collect do |element|
        section_class.new element
      end
    end
  end

  def add_element_name element_name
    @element_names ||= []
    @element_names << element_name
  end

  def element_names
    @element_names
  end

  private

  def create_existence_checker element_name, element_locator
    method_name = "has_#{element_name.to_s}?"
    if element_locator.nil?
      create_no_locator element_name, method_name
    else
      define_method method_name do
        Capybara.using_wait_time 0 do
          element_exists? element_locator
        end
      end
    end
  end

  def create_waiter element_name, element_locator
    method_name = "wait_for_#{element_name.to_s}"
    if element_locator.nil?
      create_no_locator element_name, method_name
    else
      define_method method_name do |*args| #used to use block args, but they don't work under ruby 1.8 :(
        timeout = args.shift || Capybara.default_wait_time
        Capybara.using_wait_time timeout do
          element_waiter element_locator
        end
      end
    end
  end

  def create_no_locator element_name, method_name = nil
    no_locator_method_name = method_name.nil? ? element_name : method_name
    define_method no_locator_method_name do
      raise SitePrism::NoLocatorForElement.new("#{self.class.name} => :#{element_name} needs a locator")
    end
  end
end

