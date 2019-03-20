# frozen_string_literal: true

describe 'Element' do
  # This stops the stdout process leaking between tests
  before(:each) { wipe_logger! }

  shared_examples 'an element' do
    describe '.element' do
      it 'should be settable' do
        expect(SitePrism::Page).to respond_to(:element)

        expect(SitePrism::Section).to respond_to(:element)
      end
    end

    it { is_expected.to respond_to(:element_one) }
    it { is_expected.to respond_to(:has_element_one?) }
    it { is_expected.to respond_to(:has_no_element_one?) }
    it { is_expected.to respond_to(:wait_until_element_one_visible) }
    it { is_expected.to respond_to(:wait_until_element_one_invisible) }

    describe '.expected_elements' do
      it 'sets the value of expected_items' do
        expect(klass.expected_items)
          .to eq(%i[element_one elements_one section_one sections_one])
      end
    end
  end

  context 'defined as css' do
    let(:page) { CSSPage.new }
    let(:klass) { CSSPage }

    subject { page }

    it_behaves_like 'an element'
  end

  context 'defined as xpath' do
    let(:page) { XPathPage.new }
    let(:klass) { XPathPage }

    subject { page }

    it_behaves_like 'an element'
  end
end
