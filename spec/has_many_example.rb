RSpec.shared_examples "has_many" do |method|


  it "has_many #{method}" do
    obj = described_class.list({})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      the_one = described_class.find_by_id(obj[0].id);
      subs = the_one.send method, {}
      expect(subs.is_a?(Array)).to be true
    else
      raise "not enough objects to test #{described_class}.#{method}"
    end
  end

  [1, 5].each do |limit|
    it "has_many #{method} limit_#{limit}" do
      success = false
      list = described_class.list({})
      expect(list.is_a?(Array)).to be true
      list.each do |the_one|
        subs = the_one.send method, {}
        if (subs.count > limit) then
          subs = the_one.send method, {'limit' => limit}
          expect(subs.is_a?(Array)).to be true
          expect(subs.count).to eq(limit)
          success = true
          break
        end
      end
      raise "not enough objects to test #{described_class}.#{method}" if not success
    end
  end

  [0, 1, 5].each do |offset|
    it "has_many #{method} offset_#{offset}" do
      success = false
      list = described_class.list({})
      expect(list.is_a?(Array)).to be true
      list.each do |the_one|
        from_zero = the_one.send method, {'offset' => 0, 'limit' => (offset + 1)}
        if (from_zero.count > offset) then
          subs_offset = the_one.send method, {'offset' => offset, 'limit' => 1}
          expect(subs_offset.count).to eq(1)
          expect(from_zero[offset].attributes).to eq(subs_offset[0].attributes)
          success = true
          break
        end
      end
      raise "not enough objects to test #{described_class}.#{method}" if not success
    end
  end

end