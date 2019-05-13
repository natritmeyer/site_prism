# frozen_string_literal: true

describe SitePrism::ElementChecker do
  # This stops the stdout process leaking between tests
  before(:each) { wipe_logger! }

  shared_examples 'a page' do
    describe '#all_there?' do
      context 'by default' do
        subject { page.all_there? }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expected_items.each do |name|
            expect(page).to receive(:there?).with(name).once.and_call_original
          end
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to none' do
        subject { page.all_there?(recursion: 'none') }

        it { is_expected.to be true }

        it 'checks only the expected elements' do
          expected_items.each do |name|
            expect(page).to receive(:there?).with(name).once.and_call_original
          end
          expect(page).not_to receive(:there?).with(:element_two)

          subject
        end
      end

      context 'with recursion set to one' do
        subject { page.all_there?(recursion: 'one') }

        let!(:section) { instance_double('SitePrism::Section') }

        before do
          allow(page).to receive(:section_one).and_return(section)
          # allow(section).to receive(:all_there?).and_call_original
          allow(section).to receive(:there?).with(:inner_element_one).and_return(true)
          allow(section).to receive(:there?).with(:inner_element_two).and_return(true)
          allow(section).to receive(:there?).with(:iframe).and_return(true)
        end

        # it { is_expected.to be true }

        it 'checks each item in expected elements plus all first-generation descendants' do
          expected_items.each do |name|
            expect(page).to receive(:there?).with(name).once.and_call_original
          end

          expect(section).to receive(:all_there?).with({ recursion: 'none' }).and_call_original
          expect(section).to receive(:has_inner_element_one?)
          expect(section).to receive(:has_inner_element_two?)
          expect(section).to receive(:has_iframe?)
          expect(page).not_to receive(:there?).with(:element_two)

          page.all_there?(recursion: 'one')
        end
      end

      context 'with recursion set to an invalid value' do
        subject { page.all_there?(recursion: 'go nuts') }

        it 'does not check any elements' do
          expect(page).not_to receive(:there?)

          subject
        end

        it 'sends an error to the SitePrism logger' do
          log_messages = capture_stdout do
            SitePrism.configure { |config| config.log_level = :DEBUG }
            subject
          end

          expect(lines(log_messages)).to eq(1)
        end
      end
    end

    describe '#elements_present' do
      it 'lists the SitePrism objects that are present on the page' do
        expect(page.elements_present)
          .to eq(%i[element_one element_three elements_one section_one sections_one])
      end
    end
  end

  context 'on a CSS Page' do
    let(:page) { CSSPage.new }
    let(:expected_items) { CSSPage.expected_items }

    it_behaves_like 'a page'
  end

  context 'on an XPath Page' do
    let(:page) { XPathPage.new }
    let(:expected_items) { XPathPage.expected_items }

    it_behaves_like 'a page'
  end
end
