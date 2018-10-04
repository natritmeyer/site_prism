# frozen_string_literal: true

module SitePrism
  module ElementContainer
    def self.included(klass)
      klass.extend ClassMethods
    end

    private

    def wait_time
      Capybara.default_max_wait_time
    end

    def raise_if_block(obj, name, has_block, type)
      return unless has_block

      SitePrism.logger.debug("Type passed in: #{type}")
      SitePrism.logger.warn('section / iFrame can only accept blocks.')
      SitePrism.logger.error("#{obj.class}##{name} does not accept blocks")

      raise SitePrism::UnsupportedBlockError
    end

    # Sanitize method called before calling any SitePrism DSL method or
    # meta-programmed method. This ensures that the Capybara query is correct.
    #
    # Accepts any combination of arguments sent at DSL definition or runtime
    # and combines them in such a way that Capybara can operate with them.
    def merge_args(find_args, runtime_args, visibility_args = {})
      find_args = find_args.dup
      runtime_args = runtime_args.dup
      options = visibility_args.dup
      SitePrism.logger.debug("Initial args: #{find_args}, #{runtime_args}.")

      recombine_args(find_args, runtime_args, options)

      return [*find_args, *runtime_args] if options.empty?

      [*find_args, *runtime_args, options]
    end

    # Options re-combiner. This takes the original inputs and combines
    # them such that there is only one hash passed as a final argument
    # to Capybara.
    #
    # If the hash is empty, then the hash is omitted from the payload sent
    # to Capybara, and the find / runtime arguments are sent alone.
    def recombine_args(find_args, runtime_args, options)
      options.merge!(find_args.pop) if find_args.last.is_a? Hash
      options.merge!(runtime_args.pop) if runtime_args.last.is_a? Hash
      options[:wait] = wait_time unless wait_key_present?(options)
    end

    def wait_key_present?(options)
      options.key?(:wait)
    end

    # rubocop:disable Metrics/ModuleLength
    module ClassMethods
      attr_reader :mapped_items, :expected_items

      def element(name, *find_args)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &element_block|
            raise_if_block(self, name, !element_block.nil?, :element)
            _find(*merge_args(find_args, runtime_args))
          end
        end
      end

      def elements(name, *find_args)
        build(name, *find_args) do
          define_method(name) do |*runtime_args, &element_block|
            raise_if_block(self, name, !element_block.nil?, :elements)
            _all(*merge_args(find_args, runtime_args))
          end
        end
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
            raise_if_block(self, name, !element_block.nil?, :sections)
            _all(*merge_args(find_args, runtime_args)).map do |element|
              section_class.new(self, element)
            end
          end
        end
      end

      def iframe(name, klass, *args)
        element_find_args = deduce_iframe_element_find_args(args)
        scope_find_args = deduce_iframe_scope_find_args(args)
        add_to_mapped_items(name)
        add_iframe_helper_methods(name, *element_find_args)
        define_method(name) do |&block|
          raise MissingBlockError unless block

          within_frame(*scope_find_args) do
            block.call(klass.new)
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
          create_error_method(name)
        else
          add_to_mapped_items(name)
          yield
        end
        add_helper_methods(name, *find_args)
      end

      def add_helper_methods(name, *find_args)
        create_existence_checker(name, *find_args)
        create_nonexistence_checker(name, *find_args)
        create_visibility_waiter(name, *find_args)
        create_invisibility_waiter(name, *find_args)
      end

      def add_iframe_helper_methods(name, *find_args)
        create_existence_checker(name, *find_args)
        create_nonexistence_checker(name, *find_args)
      end

      def create_helper_method(proposed_method_name, *find_args)
        if find_args.empty?
          create_error_method(proposed_method_name)
        else
          yield
        end
      end

      def create_existence_checker(element_name, *find_args)
        method_name = "has_#{element_name}?"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            args = merge_args(find_args, runtime_args)
            element_exists?(*args)
          end
        end
      end

      def create_nonexistence_checker(element_name, *find_args)
        method_name = "has_no_#{element_name}?"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            args = merge_args(find_args, runtime_args)
            element_does_not_exist?(*args)
          end
        end
      end

      def create_visibility_waiter(element_name, *find_args)
        method_name = "wait_until_#{element_name}_visible"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            args = merge_args(find_args, runtime_args, visible: true)
            return true if element_exists?(*args)
            raise SitePrism::ElementVisibilityTimeoutError
          end
        end
      end

      def create_invisibility_waiter(element_name, *find_args)
        method_name = "wait_until_#{element_name}_invisible"
        create_helper_method(method_name, *find_args) do
          define_method(method_name) do |*runtime_args|
            args = merge_args(find_args, runtime_args, visible: true)
            return true if element_does_not_exist?(*args)
            raise SitePrism::ElementInvisibilityTimeoutError
          end
        end
      end

      def create_error_method(name)
        SitePrism.logger.debug("#{name} has come from an item with 0 locators.")

        define_method(name) do
          raise SitePrism::InvalidElementError
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
