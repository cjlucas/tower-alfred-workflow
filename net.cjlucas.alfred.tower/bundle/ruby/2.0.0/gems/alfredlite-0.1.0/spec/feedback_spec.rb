require File.expand_path('../spec_helper.rb', __FILE__)

Item = Alfred::Feedback::Item

describe Item do
  it 'adds attributes and child nodes properly' do
    item = Item.new.tap do |item|
      item.title        = 'this is the title'
      item.subtitle     = 'this is the subtitle'
      item.arg          = 'this is the arg'
      item.valid        = false
      item.uid          = 'alfredlite-43223'
      item.autocomplete = 'autocompleter'
      item.icon         = '/path/to/icon.png'
      item.icon_type    = 'fileicon'
    end
    xml = item.to_xml
    
    # check attributes
    Item::ATTRIBUTES.each do |attrib|
      xml_attrib = Item::ATTRIBUTES_XML_MAP.fetch(attrib, attrib)
      xml.attributes[xml_attrib.to_s].should eq(item.method(attrib).call)
    end

    # child nodes
    Item::CHILD_NODES.keys do |node_name|
      nodes = xml.children.select {|child| child.name.eql?(node_name.to_s)}
      nodes.count.should eq(1)
      nodes.first.name.should eq(node_name)
    end
  end

  #it "Doesn't add attributes and nodes that are nil" do
    #item = Item.new
  #end
end
