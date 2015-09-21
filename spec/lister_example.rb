RSpec.shared_examples "listers" do |klass|

 let(:max_in_list) { 100 }

  it "#{klass}_all" do
    obj = klass.list({})
    expect(obj.is_a?(Array)).to be true
    expect(obj.count <= max_in_list).to be true
  end

  [0, 1, 5].each do |limit|
    it "#{klass}_get_#{limit}" do
      all = klass.list({})
      if (all.count >= limit) then
        obj = klass.list({'limit' => limit, 'offset' => 0})
        expect(obj.is_a?(Array)).to be true
        expect(obj.count).to eq(limit)
      else
        raise "not enough #{klass} objects for test case"
      end
    end
  end

  [0, 1, 5].each do |offset|
    it "#{klass}_offset_#{offset}" do
      from = klass.list({'limit' => 1, 'offset' => offset})
      expect(from.is_a?(Array)).to be true
      if (from.count > 0) then
        from_zero = klass.list({'limit' => offset + 2, 'offset' => 0})
        expect(from_zero.is_a?(Array)).to be true
        expect(from[0].attributes).to eq(from_zero[offset].attributes)
      else
        raise "not enough #{klass} objects for test case"
      end
    end
  end

end