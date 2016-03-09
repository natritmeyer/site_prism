module SitePrism
  module ElementContainer
    attr_reader :mapped_items

    def element(element_name, *find_args)
      build element_name, *find_args do
        define_method element_name.to_s do |*runtime_args, &element_block|
          self.class.raise_if_block(self, element_name.to_s, !element_block.nil?)
          find_first(*find_args, *runtime_args)
        end
      end
    end

    def elements(collection_name, *find_args)
      build collection_name, *find_args do
        define_method collection_name.to_s do |*runtime_args, &element_block|
          self.class.raise_if_block(self, collection_name.to_s, !element_block.nil?)
          find_all(*find_args, *runtime_args)
        end
      end
    end
    alias collection elements

    def section(section_name, *args, &block)
      section_class, find_args = extract_section_options args, &block
      build section_name, *find_args do
        define_method section_name do |*runtime_args, &runtime_block|
          section_class.new self, find_first(*find_args, *runtime_args), &runtime_block
        end
      end
    end

    def sections(section_collection_name, *args, &block)
      section_class, find_args = extract_section_options args, &block
      build section_collection_name, *find_args do
        define_method section_collection_name do |*runtime_args, &element_block|
          self.class.raise_if_block(self, section_collection_name.to_s, !element_block.nil?)
          find_all(*find_args, *runtime_args).map do |element|
            section_class.new self, element
          end
        end
      end
    end

    def iframe(iframe_name, iframe_page_class, selector)
      element_selector = deduce_iframe_element_selector(selector)
      scope_selector = deduce_iframe_scope_selector(selector)
      add_to_mapped_items iframe_name
      create_existence_checker iframe_name, element_selector
      create_nonexistence_checker iframe_name, element_selector
      create_waiter iframe_name, element_selector
      define_method iframe_name do |&block|
        within_frame scope_selector do
          block.call iframe_page_class.new
        end
      end
    end

    def add_to_mapped_items(item)
      @mapped_items ||= []
      @mapped_items << item.to_s
    end

    def raise_if_block(obj, name, has_block)
      return unless has_block
      raise SitePrism::UnsupportedBlock, "#{obj.class}##{name} does not accept blocks, did you mean to define a (i)frame?"
    end

    private

    def build(name, *find_args)
      if find_args.empty?
        create_no_selector name
      else
        add_to_mapped_items name
        yield
      end
      add_helper_methods name, *find_args
    end

    def add_helper_methods(name, *find_args)
      create_existence_checker name, *find_args
      create_nonexistence_checker name, *find_args
      create_waiter name, *find_args
      create_visibility_waiter name, *find_args
      create_invisibility_waiter name, *find_args
    end

    def create_helper_method(proposed_method_name, *find_args)
      if find_args.empty?
        create_no_selector proposed_method_name
      else
        yield
      end
    end

    def create_existence_checker(element_name, *find_args)
      method_name = "has_#{element_name}?"
      create_helper_method method_name, *find_args do
        define_method method_name do |*runtime_args|
          wait_time = SitePrism.use_implicit_waits ? Waiter.default_wait_time : 0
          Capybara.using_wait_time wait_time do
            element_exists?(*find_args, *runtime_args)
          end
        end
      end
    end

    def create_nonexistence_checker(element_name, *find_args)
      method_name = "has_no_#{element_name}?"
      create_helper_method method_name, *find_args do
        define_method method_name do |*runtime_args|
          wait_time = SitePrism.use_implicit_waits ? Waiter.default_wait_time : 0
          Capybara.using_wait_time wait_time do
            element_does_not_exist?(*find_args, *runtime_args)
          end
        end
      end
    end

    def create_waiter(element_name, *find_args)
      method_name = "wait_for_#{element_name}"
      create_helper_method method_name, *find_args do
        define_method method_name do |timeout = nil, *runtime_args|
          timeout = timeout.nil? ? Waiter.default_wait_time : timeout
          Capybara.using_wait_time timeout do
            element_exists?(*find_args, *runtime_args)
          end
        end
      end
    end

    def create_visibility_waiter(element_name, *find_args)
      method_name = "wait_until_#{element_name}_visible"
      create_helper_method method_name, *find_args do
        define_method method_name do |timeout = Waiter.default_wait_time, *runtime_args|
          Timeout.timeout timeout, SitePrism::TimeOutWaitingForElementVisibility do
            Capybara.using_wait_time 0 do
              sleep 0.05 until element_exists?(*find_args, *runtime_args, visible: true)
            end
          end
        end
      end
    end

    def create_invisibility_waiter(element_name, *find_args)
      method_name = "wait_until_#{element_name}_invisible"
      create_helper_method method_name, *find_args do
        define_method method_name do |timeout = Waiter.default_wait_time, *runtime_args|
          Timeout.timeout timeout, SitePrism::TimeOutWaitingForElementInvisibility do
            Capybara.using_wait_time 0 do
              sleep 0.05 while element_exists?(*find_args, *runtime_args, visible: true)
            end
          end
        end
      end
    end

    def create_no_selector(method_name)
      define_method method_name do
        raise SitePrism::NoSelectorForElement.new, "#{self.class.name} => :#{method_name} needs a selector"
      end
    end

    def deduce_iframe_scope_selector(selector)
      selector.is_a?(Integer) ? selector : selector.split('#').last
    end

    def deduce_iframe_element_selector(selector)
      selector.is_a?(Integer) ? "iframe:nth-of-type(#{selector + 1})" : selector
    end

    def extract_section_options(args, &block)
      case
      when args.first.is_a?(Class)
        section_class = args.shift
      when block_given?
        section_class = Class.new SitePrism::Section, &block
      else
        raise ArgumentError, 'You should provide section class either as a block, or as the second argument'
      end
      return section_class, args
    end
  end
end
