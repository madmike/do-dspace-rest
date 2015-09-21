RSpec.shared_examples "byid" do 

  it "byid" do
    obj = described_class.list({})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.attributes['id']);
      expect(one.attributes).to eq(the_one.attributes)
    else
      raise "not enough #{described_class} objects for test case"
    end
  end

end