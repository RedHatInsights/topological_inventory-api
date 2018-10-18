RSpec.describe Api::V0x0::ServiceOfferingsController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }
end
