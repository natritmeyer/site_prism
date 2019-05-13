# frozen_string_literal: true

describe 'Element' do
  # This stops the stdout process leaking between tests
  before(:each) { wipe_logger! }
  let(:expected_elements) { SitePrism::SpecHelper.present_stubs }

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

    it 'supports rspec existence matchers' do
      expect(subject).to have_element_one
    end

    it 'supports negated rspec existence matchers' do
      expect(subject).to receive(:has_no_element_two?).once.and_call_original
      expect(subject).not_to have_element_two
    end

    describe '#all_there?' do
      subject { page.all_there? }

      context 'with no recursion' do
        it { is_expected.to be_truthy }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end
    end

    describe '#elements_present' do
      it 'only lists the SitePrism objects that are present on the page' do
        expect(page.elements_present.sort).to eq(expected_elements.sort)
      end
    end

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
