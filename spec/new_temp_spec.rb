
require 'spec_helper'

describe SitePrism::Page do
  describe '#expected_elements' do
    class PageWithAFewElements < SitePrism::Page
      element :bob, 'a.b c.d'
      element :dave, 'w.x y.z'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    before do
      allow(page).to receive(:present?).with(:bob).and_return(true)
      allow(page).to receive(:present?).with(:dave).and_return(false)
      allow(page).to receive(:present?).with(:success_msg).and_return(true)
    end

    let(:page) { PageWithAFewElements.new }

    subject { page.elements_present }

    describe '#elements_present' do
      it 'only lists the SitePrism objects that are present on the page' do
        expect(subject).to eq([:bob, :success_msg])
      end
    end
  end
end
