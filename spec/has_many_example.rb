RSpec.shared_examples "has_many" do |method|

  it "has_many #{method}" do
    obj = described_class.list({})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      the_one = described_class.find_by_id(obj[0].attributes['id']);
      subs = the_one.send method, {}
      expect(subs.is_a?(Array)).to be true
    else
      raise "not enough #{described_class} objects for test case"
    end
  end

end