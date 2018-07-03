# frozen_string_literal: true

module SitePrism
  module ElementContainer
    def self.included(klass)
      klass.extend ClassMethods
    end

    private

    def max_wait_time
      Capybara.default_max_wait_time
    end

    def raise_if_block(obj, name, has_block)
      return unless has_block

      raise SitePrism::UnsupportedBlock, "#{obj.class}##{name}"
    end

    def raise_wait_for_if_failed(obj, name, timeout, failed)
      return unless SitePrism.raise_on_wait_fors && failed

      raise SitePrism::TimeOutWaitingForExistenceError, \
            "Timed out after #{timeout}s waiting for #{obj.class}##{name}"
    end

    def raise_wait_for_no_if_failed(obj, name, timeout, failed)
      return unless SitePrism.raise_on_wait_fors && failed

      raise SitePrism::TimeOutWaitingForNonExistenceError, \
            "Timed out after #{timeout}s waiting for no #{obj.class}##{name}"
    end

    # Sanitize method called before calling any SitePrism DSL method or
    # meta-programmed method. This ensures that the Capybara query is correct.
    #
    # Accepts any combination of arguments sent at DSL definition or runtime
    # and combines them in such a way that Capybara can operate with them.
    def merge_args(find_args, runtime_args, override_options = {})
      find_args = find_args.dup
      runtime_args = runtime_args.dup
      options = {}
      options.merge!(find_args.pop) if find_args.last.is_a? Hash
      options.merge!(runtime_args.pop) if runtime_args.last.is_a? Hash
      options.merge!(override_options)
      options[:wait] = false unless wait_required?(options)

      return [*find_args, *runtime_args] if options.empty?

      [*find_args, *runtime_args, options]
    end

    def wait_required?(options)
      SitePrism.use_implicit_waits || options.key?(:wait)
    end

    # rubocop:disable Metrics/ModuleLength
    module ClassMethods
      attr_reader :mapped_items, :expected_items

      def element(name, *find_args)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &element_block|
            raise_if_block(self, name, !element_block.nil?)
            _find(*merge_args(find_args, runtime_args))
          end
        end
      end

      def elements(name, *find_args)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &element_block|
            raise_if_block(self, name, !element_block.nil?)
            _all(*merge_args(find_args, runtime_args))
          end
        end
      end

      def collection(name, *find_args)
        warn 'Using collection is now deprecated and will be removed.'
        warn 'Use elements DSL notation instead.'
        elements(name, *find_args)
      end

      def expected_elements(*elements)
        @expected_items = elements
      end

      def section(name, *args, &block)
        section_class, find_args = extract_section_options(args, &block)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &runtime_block|
            section_element = _find(*merge_args(find_args, runtime_args))
            section_class.new(self, section_element, &runtime_block)
          end
        end
      end

      def sections(name, *args, &block)
        section_class, find_args = extract_section_options(args, &block)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &element_block|
            raise_if_block(self, name, !element_block.nil?)
            _all(*merge_args(find_args, runtime_args)).map do |element|
              section_class.new(self, element)
            end
          end
        end
      end

      def iframe(iframe_name, iframe_page_class, *args)
        element_find_args = deduce_iframe_element_find_args(args)
        scope_find_args = deduce_iframe_scope_find_args(args)
        add_to_mapped_items(iframe_name)
        add_iframe_helper_methods(iframe_name, *element_find_args)
        define_method(iframe_name) do |&block|
          within_frame(*scope_find_args) do
            block.call iframe_page_class.new
          end
        end
      end

      def add_to_mapped_items(item)
        @mapped_items ||= []
        @mapped_items << item
      end

      private

      def build(name, *find_args)
        if find_args.empty?
          create_no_selector(name)
        else
          add_to_mapped_items(name)
          yield
        end
        add_helper_methods(name, *find_args)
      end

      def add_helper_methods(name, *find_args)
        create_existence_checker(name, *find_args)
        create_nonexistence_checker(name, *find_args)
        create_waiter(name, *find_args)
        create_nonexistence_waiter(name, *find_args)
        create_visibility_waiter(name, *find_args)
        create_invisibility_waiter(name, *find_args)
      end

      def add_iframe_helper_methods(name, *find_args)
        create_existence_checker(name, *find_args)
        create_nonexistence_checker(name, *find_args)
        create_waiter(name, *find_args)
        create_nonexistence_waiter(name, *find_args)
      end

      def create_helper_method(proposed_method_name, *find_args)
        if find_args.empty?
          create_no_selector(proposed_method_name)
        else
          yield
        end
      end

      def create_existence_checker(element_name, *find_args)
        method_name = "has_#{element_name}?"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            wait_time = SitePrism.use_implicit_waits ? max_wait_time : 0
            visibility_args = { wait: wait_time }
            element_exists?(*merge_args(find_args, runtime_args, **visibility_args))
          end
        end
      end

      def create_nonexistence_checker(element_name, *find_args)
        method_name = "has_no_#{element_name}?"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            wait_time = SitePrism.use_implicit_waits ? max_wait_time : 0
            visibility_args = { wait: wait_time }
            element_does_not_exist?(
              *merge_args(find_args, runtime_args, **visibility_args)
            )
          end
        end
      end

      def create_waiter(element_name, *find_args)
        method_name = "wait_for_#{element_name}"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |timeout = max_wait_time, *runtime_args|
            visibility_args = { wait: timeout }
            result = element_exists?(*merge_args(find_args, runtime_args, **visibility_args))
            raise_wait_for_if_failed(self, element_name.to_s, timeout, !result)
            result
          end
        end
      end

      def create_nonexistence_waiter(element_name, *find_args)
        method_name = "wait_for_no_#{element_name}"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |timeout = max_wait_time, *runtime_args|
            visibility_args = { wait: timeout }
            res = element_does_not_exist?(*merge_args(find_args, runtime_args, **visibility_args))
            raise_wait_for_no_if_failed(self, element_name.to_s, timeout, !res)
            res
          end
        end
      end

      def create_visibility_waiter(element_name, *find_args)
        method_name = "wait_until_#{element_name}_visible"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |timeout = max_wait_time, *runtime_args|
            visibility_args = { visible: true, wait: timeout }
            args = merge_args(find_args, runtime_args, **visibility_args)
            return true if element_exists?(*args)
            raise SitePrism::TimeOutWaitingForElementVisibility
          end
        end
      end

      def create_invisibility_waiter(element_name, *find_args)
        method_name = "wait_until_#{element_name}_invisible"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |timeout = max_wait_time, *runtime_args|
            visibility_args = { visible: true, wait: timeout }
            args = merge_args(find_args, runtime_args, **visibility_args)
            return true if element_does_not_exist?(*args)
            raise SitePrism::TimeOutWaitingForElementInvisibility
          end
        end
      end

      def create_no_selector(method_name)
        define_method(method_name) do
          raise SitePrism::NoSelectorForElement.new,
                "#{self.class.name} => :#{method_name} needs a selector"
        end
      end

      def deduce_iframe_scope_find_args(args)
        case args[0]
        when Integer
          [args[0]]
        when String
          [:css, args[0]]
        else
          args
        end
      end

      def deduce_iframe_element_find_args(args)
        case args[0]
        when Integer
          "iframe:nth-of-type(#{args[0] + 1})"
        when String
          [:css, args[0]]
        else
          args
        end
      end

      def extract_section_options(args, &block)
        if args.first.is_a?(Class)
          klass = args.shift
          section_class = klass if klass.ancestors.include?(SitePrism::Section)
        end

        section_class = deduce_section_class(section_class, &block)
        arguments = deduce_search_arguments(section_class, args)
        [section_class, arguments]
      end

      def deduce_section_class(base_class, &block)
        klass = base_class

        klass = Class.new(klass || SitePrism::Section, &block) if block_given?

        unless klass
          raise ArgumentError, "You should provide descendant of \
SitePrism::Section class or/and a block as the second argument."
        end
        klass
      end

      def deduce_search_arguments(section_class, args)
        extract_search_arguments(args) ||
          extract_search_arguments(section_class.default_search_arguments) ||
          raise(ArgumentError, "You should provide search arguments \
in section creation or set_default_search_arguments within section class")
      end

      def extract_search_arguments(args)
        args if args && !args.empty?
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
