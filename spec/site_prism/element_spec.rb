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

    describe '#all_there?' do
      subject { page.all_there? }

      context 'by default' do
        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to none' do
        subject { page.all_there?(recursion: 'none') }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to one' do
        subject { page.all_there?(recursion: 'one') }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:element_one).once
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to an invalid value' do
        subject { page.all_there?(recursion: 'go nuts') }

        it 'does not check any elements' do
          expect(page).not_to receive(:there?)

          subject
        end

        it 'sends an error to the SitePrism logger' do
          SitePrism.configure { |config| config.enable_logging = true }

          log_messages = capture_stdout do
            subject
          end

          expect(lines(log_messages)).to eq(2)
        end
      end
    end

    describe '#elements_present' do
      it 'only lists the SitePrism objects that are present on the page' do
        expect(page.elements_present).to eq(%i[element_one element_three])
      end
    end

    describe '.expected_elements' do
      it 'sets the value of expected_items' do
        expect(klass.expected_items).to eq([:element_one])
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
