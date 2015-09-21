RSpec.shared_examples "listers" do

 let(:max_in_list) { 100 }

  it "all" do
    obj = described_class.list({})
    expect(obj.is_a?(Array)).to be true
    expect(obj.count <= max_in_list).to be true
  end

  [0, 1, 5].each do |limit|
    it "get_#{limit}" do
      all = described_class.list({})
      if (all.count >= limit) then
        obj = described_class.list({'limit' => limit, 'offset' => 0})
        expect(obj.is_a?(Array)).to be true
        expect(obj.count).to eq(limit)
      else
        raise "not enough #{described_class} objects for test case"
      end
    end
  end

  [0, 1, 5].each do |offset|
    it "offset_#{offset}" do
      from = described_class.list({'limit' => 1, 'offset' => offset})
      expect(from.is_a?(Array)).to be true
      if (from.count > 0) then
        from_zero = described_class.list({'limit' => offset + 2, 'offset' => 0})
        expect(from_zero.is_a?(Array)).to be true
        expect(from[0].attributes).to eq(from_zero[offset].attributes)
      else
        raise "not enough #{described_class} objects for test case"
      end
    end
  end

end