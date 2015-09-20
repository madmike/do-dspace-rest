RSpec.shared_examples "crud" do |klass, prop_keys, parent|
  PROP_KEYS = prop_keys
  PARENT = parent
  KLASS = klass

  def make(attrs)
    obj = KLASS.new(PARENT, attrs)
    obj.save
    return obj
  end

  def update_attrs(id, attrs)
    upd = KLASS.find_by_id(id)
    attrs.each { |k, v|
      upd[k] = v
    }
    upd.save
    read = KLASS.find_by_id(id)
    return read;
  end

  def fake_prop_val(prop)
    return "#{prop} by #{self.class}"
  end

  def fake_prop_hash(prefix)
    hsh={}
    PROP_KEYS.each { |k| hsh[k] = "#{prefix}:#{fake_prop_val(k)}" }
    return hsh
  end

  PROP_KEYS.each do |prop|
    it "create single_#{prop}" do
      val = fake_prop_val(prop)
      create = make(prop => val)
      expect(create.attributes['id']).to_not be_nil
      PROP_KEYS.each do |k|
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

  it "create multi_val" do
    hsh = fake_prop_hash("CREATE")
    create = make(hsh)
    expect(create.attributes['id']).to_not be_nil
    hsh.each do |k, v|
      expect(create.attributes[k]).to eq(v)
    end
    create.delete
  end

  it "read" do
    create = make("name" => fake_prop_val("name"))
    read = DCollection.find_by_id(create.id)
    expect(read.attributes["name"]).to eq(create.attributes["name"])
    create.delete
  end

  PROP_KEYS.each do |prop|
    it "update single_#{prop}" do
      hsh = fake_prop_hash("MAKE")
      create = make(hsh)
      upd = update_attrs(create.id, prop => "UPD " + fake_prop_val(prop))
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

  it "update multi_val" do
    hsh = fake_prop_hash("MAKE")
    create = make(hsh)
    new_hsh = fake_prop_hash("UPD")
    upd = update_attrs(create.id, new_hsh)
    PROP_KEYS.each do |k|
      expect(upd.attributes[k]).to eq(new_hsh[k])
    end
    create.delete
  end

  it "delete" do
    create = make("name" => fake_prop_val("name"))
    id = create.id
    res = create.delete
    expect(res == "")
    expect { DCollection.find_by_id(id) }.to raise_error(RestClient::ResourceNotFound)
  end

end