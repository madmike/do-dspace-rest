require "initializer"
require "lister_example"
require "byid_example"
require "has_many_example"

RSpec.describe DCollection do
  include_examples "listers", DCollection
  include_examples "byid", DCollection
  include_examples "has_many", DCollection, "items"

  PROP_KEYS = ["name", "copyrightText", "introductoryText", "shortDescription", "sidebarText"]

  NAME = "new collection from rspec"

  def make(attrs)
    parent = DCommunity.list({})[0]
    obj = DCollection.new(parent, attrs)
    obj.save
    return obj
  end

  def update_attrs(id, attrs)
    upd = DCollection.find_by_id(id)
    attrs.each { |k, v|
      upd[k] = v
    }
    upd.save
    read = DCollection.find_by_id(id)
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

  context "create" do
    PROP_KEYS.each do |prop|
      it "single_#{prop}" do
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

    it "multi_val" do
      hsh = fake_prop_hash("CREATE")
      create = make(hsh)
      expect(create.attributes['id']).to_not be_nil
      hsh.each do |k, v|
        expect(create.attributes[k]).to eq(v)
      end
      create.delete
    end
  end

  it "read" do
    create = make("name" => NAME)
    read = DCollection.find_by_id(create.id)
    expect(read.attributes["name"]).to eq(create.attributes["name"])
    create.delete
  end

  context "update" do
    PROP_KEYS.each do |prop|
      it "single_#{prop}" do
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

    it "multi_val" do
      hsh = fake_prop_hash("MAKE")
      create = make(hsh)
      new_hsh = fake_prop_hash("UPD")
      upd = update_attrs(create.id, new_hsh)
      PROP_KEYS.each do |k|
        expect(upd.attributes[k]).to eq(new_hsh[k])
      end
      create.delete
    end
  end

  it "delete" do
    create = make("name" => NAME)
    id = create.id
    res = create.delete
    expect(res == "")
    expect { DCollection.find_by_id(id) }.to raise_error(RestClient::ResourceNotFound)
  end

end

