RSpec.shared_examples "byid" do
  it "byid" do
    obj = described_class.list({'limit' => 1})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.id);
      expect(one.attributes).to eq(the_one.attributes)
    else
      raise "not enough #{described_class} objects for test case"
    end
  end

  described_class::EXPAND.each do |expand|
    it "byid_expand_#{expand}" do
      obj = described_class.list({'limit' => 1})
      if (obj.count > 0) then
        one = obj[0]
        the_one = described_class.find_by_id(one.id, [expand]);
        described_class::EXPAND.each do |x|
          #puts "#{expand} tst-#{x} #{the_one.attributes.keys.join(":")}"
          if (the_one.attributes.keys.include?(x) != (x == expand)) then
            if (x == expand) then
              raise "#{x} should be expanded for #{the_one.to_s}"
            else
              raise "#{x} should NOT be expanded for #{the_one.to_s}"
            end
          end
        end
      end
    end
  end

  it "byid_expand_two" do
    pair = [described_class::EXPAND.first, described_class::EXPAND.last]
    obj = described_class.list({'limit' => 1})
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.id, pair);
      described_class::EXPAND.each do |x|
        if (the_one.attributes.keys.include?(x) != pair.include?(x)) then
          if (pair.include?(x)) then
            raise "#{x} should be expanded for #{the_one.to_s} and with expand=#{pair.join(",")}"
          else
            raise "#{x} should NOT be expanded for #{the_one.to_s} and with expand=#{pair.join(",")}"
          end
        end
      end
    end
  end

  it "byid_expand_all" do
    obj = described_class.list({'limit' => 1})
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.id, ["all"]);
      described_class::EXPAND.each do |ex|
        if (not the_one.attributes.keys.include?(ex)) then
          raise "#{ex} should be expanded"
        end
      end
    end
  end
end