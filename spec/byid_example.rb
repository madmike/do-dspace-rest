RSpec.shared_examples "byid" do
  valid_names = described_class.valid_attributes - DSpace::Rest::DSpaceObj.valid_attributes;

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

  valid_names.each do |expand|
    it "byid_expand_#{expand}" do
      obj = described_class.list({'limit' => 1})
      if (obj.count > 0) then
        one = obj[0]
        the_one = described_class.find_by_id(one.id, [expand])
        valid_names.each do |x|
          #puts "#{expand} tst-#{x} #{the_one.attributes.keys.join(":")}"
          if (the_one.attributes.keys.include?(x) != (x == expand)) then
            if (x == expand) then
              raise "#{x} should be expanded for #{the_one.to_s}"
            else
              raise "#{x} has value '#{the_one.attributes[x]}', but should NOT be expanded for #{the_one.to_s} with expand=#{expand}"
            end
          end
        end
      else
        raise "not enough #{described_class} objects for test case"
      end
    end
  end

  it "byid_expand_two" do
    pair = [valid_names.first, valid_names.last]
    obj = described_class.list({'limit' => 1})
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.id, pair);
      valid_names.each do |x|
        if (the_one.attributes.keys.include?(x) != pair.include?(x)) then
          if (pair.include?(x)) then
            raise "#{x} should be expanded for #{the_one.to_s} and with expand=#{pair.join(",")}"
          else
            raise "#{x} has value value '#{the_one.attributes[x]}', but should NOT be expanded for #{the_one.to_s} and with expand=#{pair.join(",")}"
          end
        end
      end
    else
      raise "not enough #{described_class} objects for test case"
    end
  end

  it "byid_expand_all" do
    obj = described_class.list({'limit' => 1})
    if (obj.count > 0) then
      one = obj[0]
      the_one = described_class.find_by_id(one.id, ["all"]);
      # test for ARRAY type

      valid_names.each do |ex|
        if (not the_one.attributes.keys.include?(ex)) then
          raise "#{ex} should be expanded"
        end
        if (described_class::EXPAND_TO_ARRAY.include?(ex)) then
          if (the_one.attributes[ex].class != Array) then
            raise "#{ex} should be an Array"
          end
        end
      end
    else
      raise "not enough #{described_class} objects for test case"
    end
  end
end