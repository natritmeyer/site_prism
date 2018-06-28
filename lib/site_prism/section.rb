# frozen_string_literal: true

require 'site_prism/loadable'

module SitePrism
  class Section
    include Capybara::DSL
    include ElementChecker
    include Loadable
    include ElementContainer

    attr_reader :root_element, :parent

    def self.set_default_search_arguments(*args)
      @default_search_arguments = args
    end

    def self.default_search_arguments
      @default_search_arguments ||
        (
          superclass.respond_to?(:default_search_arguments) &&
          superclass.default_search_arguments
        ) ||
        nil
    end

    def initialize(parent, root_element)
      @parent = parent
      @root_element = root_element
      Capybara.within(@root_element) { yield(self) } if block_given?
    end

    # Capybara::DSL module "delegates" Capybara methods to the "page" method
    # as such we need to overload this method so that the correct scoping
    # occurs and calls within a section (For example section.find(element))
    # correctly scope to look within the section only
    def page
      root_element || super
    end

    def visible?
      page.visible?
    end

    def execute_script(input)
      Capybara.current_session.execute_script(input)
    end

    def evaluate_script(input)
      Capybara.current_session.evaluate_script(input)
    end

    def parent_page
      candidate = parent
      candidate = candidate.parent until candidate.is_a?(SitePrism::Page)
      candidate
    end

    def native
      root_element.native
    end

    private

    def _find(*find_args)
      page.find(*find_args)
    end

    def _all(*find_args)
      if SitePrism.use_implicit_waits
        page.all(*find_args)
      else
        page.all(*find_args, wait: false)
      end
    end

    def element_exists?(*find_args)
      root_element.has_selector?(*find_args) unless root_element.nil?
    end

    def element_does_not_exist?(*find_args)
      root_element.has_no_selector?(*find_args) unless root_element.nil?
    end
  end
end
