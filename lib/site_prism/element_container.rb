module SitePrism::ElementContainer

  def element element_name, *find_args 
    build element_name, *find_args do
      define_method element_name.to_s do
        find_first *find_args
      end
    end
  end

  def elements collection_name, *find_args
    build collection_name, *find_args do
      define_method collection_name.to_s do
        find_all *find_args
      end
    end
  end
  alias :collection :elements

  def section section_name, section_class, *find_args
    build section_name, *find_args do
      define_method section_name do
        section_class.new find_first *find_args
      end
    end
  end

  def sections section_collection_name, section_class, *find_args
    build section_collection_name, *find_args do
      define_method section_collection_name do
        find_all(*find_args).collect do |element|
          section_class.new element
        end
      end
    end
  end

  def iframe iframe_name, iframe_page_class, iframe_id
    add_to_mapped_items iframe_name
    create_existence_checker iframe_name, iframe_id
    create_waiter iframe_name, iframe_id
    define_method iframe_name do |&block|
      within_frame iframe_id.split("#").last do
        block.call iframe_page_class.new
      end
    end
  end

  def add_to_mapped_items item
    @mapped_items ||= []
    @mapped_items << item.to_s
  end

  def mapped_items
    @mapped_items
  end

  private
  
  def build name, *find_args
    if find_args.empty?
      create_no_selector name
    else
      add_to_mapped_items name
      yield
    end
    add_checkers_and_waiters name, *find_args
  end
  
  def add_checkers_and_waiters name, *find_args
    create_existence_checker name, *find_args
    create_waiter name, *find_args
    create_visibility_waiter name, *find_args
    create_invisibility_waiter name, *find_args
  end
  
  def build_checker_or_waiter element_name, proposed_method_name, *find_args
    if find_args.empty?
      create_no_selector element_name, proposed_method_name
    else
      yield
    end
  end

  def create_existence_checker element_name, *find_args
    method_name = "has_#{element_name.to_s}?"
    build_checker_or_waiter element_name, method_name, *find_args do
      define_method method_name do
        Capybara.using_wait_time 0 do
          element_exists? *find_args
        end
      end
    end
  end

  def create_waiter element_name, *find_args
    method_name = "wait_for_#{element_name.to_s}"
    build_checker_or_waiter element_name, method_name, *find_args do
      define_method method_name do |timeout = Capybara.default_wait_time|
        Capybara.using_wait_time timeout do
          element_exists? *find_args
        end
      end
    end
  end

  def create_visibility_waiter element_name, *find_args
    method_name = "wait_until_#{element_name.to_s}_visible"
    build_checker_or_waiter element_name, method_name, *find_args do
      define_method method_name do |timeout = Capybara.default_wait_time|
        Capybara.using_wait_time timeout do
          element_exists? *find_args
        end
        Timeout.timeout timeout, SitePrism::TimeOutWaitingForElementVisibility do
          sleep 0.1 until find_first(*find_args).visible?
        end
      end
    end
  end

  def create_invisibility_waiter element_name, *find_args
    method_name = "wait_until_#{element_name.to_s}_invisible"
    build_checker_or_waiter element_name, method_name, *find_args do
      define_method method_name do |timeout = Capybara.default_wait_time|
        Timeout.timeout timeout, SitePrism::TimeOutWaitingForElementInvisibility do
          sleep 0.1 while element_exists?(*find_args) && find_first(*find_args).visible?
        end
      end
    end
  end

  def create_no_selector element_name, method_name = nil
    no_selector_method_name = method_name.nil? ? element_name : method_name
    define_method no_selector_method_name do
      raise SitePrism::NoSelectorForElement.new("#{self.class.name} => :#{element_name} needs a selector")
    end
  end
end

