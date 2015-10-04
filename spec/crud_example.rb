RSpec.shared_examples "crud" do
  def self.prop_keys
    ["name", "copyrightText", "introductoryText", "shortDescription", "sidebarText"]
  end

  def prop_keys
    return self.class.prop_keys
  end

  def make(klass, attrs)
    if (klass == DSpace::Rest::Collection) then
      parent = DSpace::Rest::Community.list('limit' => 1)[0]
    else
      parent = nil
    end
    obj = klass.new(parent, attrs)
    obj.save
    return obj
  end

  def update_attrs(klass, id, attrs)
    upd = klass.find_by_id(id)
    attrs.each { |k, v|
      upd[k] = v
    }
    upd.save
    read = klass.find_by_id(id)
    return read;
  end

  def fake_prop_val(prop)
    return "#{prop} by #{self.class}"
  end

  def fake_prop_hash(prefix)
    hsh={}
    prop_keys.each { |k| hsh[k] = "#{prefix}:#{fake_prop_val(k)}" }
    return hsh
  end

  it "crud_create_then_delete" do
    create = make(described_class, "name" => fake_prop_val("name"))
    id = create.id
    expect(id).to_not be_nil
    expect(described_class.find_by_id(id)).to_not  be_nil
    res = create.delete
    expect(res == "")
    expect { described_class.find_by_id(id) }.to raise_error(RestClient::ResourceNotFound)
  end


  prop_keys.each do |prop|
    it "crud_create single_#{prop}" do
      val = fake_prop_val(prop)
      create = make(described_class, prop => val)
      expect(create.attributes['id']).to_not be_nil
      prop_keys.each do |k|
        if (k == prop) then
          expect(create.attributes[prop]).to eq(val)
        elsif (k == "name") then
          # "Untitled" with default DSPACE config - might be something else with non english configs
          expect(create.attributes[k].class).to eq(String)
        else
          expect(create.attributes[k]).to eq("")
        end
      end
      create.delete
    end
  end

  it "crud_create multi_val" do
    hsh = fake_prop_hash("CREATE")
    create = make(described_class, hsh)
    expect(create.attributes['id']).to_not be_nil
    hsh.each do |k, v|
      expect(create.attributes[k]).to eq(v)
    end
    create.delete
  end

  it "crud_read" do
    create = make(described_class, "name" => fake_prop_val("name"))
    read = described_class.find_by_id(create.id)
    expect(read.attributes["name"]).to eq(create.attributes["name"])
    create.delete
  end

  prop_keys.each do |prop|
    it "crud_update single_#{prop}" do
      hsh = fake_prop_hash("MAKE")
      create = make(described_class, hsh)
      upd = update_attrs(described_class, create.id, prop => "UPD " + fake_prop_val(prop))
      upd.attributes.each do |k, v|
        if (k == prop) then
          expect(upd.attributes[prop]).to eq("UPD " + fake_prop_val(prop))
        else
          expect(upd.attributes[k]).to eq(create.attributes[k])
        end
      end
      upd.delete
    end
  end

  it "crud_update multi_val" do
    hsh = fake_prop_hash("MAKE")
    create = make(described_class, hsh)
    new_hsh = fake_prop_hash("UPD")
    upd = update_attrs(described_class, create.id, new_hsh)
    prop_keys.each do |k|
      expect(upd.attributes[k]).to eq(new_hsh[k])
    end
    create.delete
  end


end
