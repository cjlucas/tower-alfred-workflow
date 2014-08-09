require 'rexml/document'

module Alfred
  class Workflow
    def feedback_items
      @feedback_items ||= []
    end

    def feedback_xml
      doc = REXML::Document.new
      doc << REXML::Element.new('items')
      feedback_items.each { |item| doc.root << item.to_xml }

      doc
    end
  end
end

module Alfred
  module Feedback
    class Item
      # Compatibility Note:
      #   In Ruby 1.8, Object#type is defined, to workaround this the type 
      #   attribute can be accessed via #item_type
      ATTRIBUTES  = [:uid, :arg, :valid, :autocomplete, :item_type]
      ATTRIBUTES_XML_MAP = {
        :item_type => :type,
      }
      CHILD_NODES = {
        :title => [], 
        :subtitle  => [], 
        :icon => [:type],
      }

      def initialize
        @item_type = 'file'
      end

      def valid=(valid)
        @valid = valid ? 'true' : 'false'
      end

      def to_xml
        item_node = REXML::Element.new('item')
        ATTRIBUTES.each do |attrib|
          value = method(attrib).call
          xml_attrib = ATTRIBUTES_XML_MAP.fetch(attrib, attrib)
          #item_node[xml_attrib.to_s] = value unless value.nil?
          item_node.add_attribute(xml_attrib.to_s, value) unless value.nil?
        end

        CHILD_NODES.each do |node_name, node_attribs|
          value = method(node_name).call
          unless value.nil?
            item_node << REXML::Element.new(node_name.to_s).tap do |child|
              child.text = value

              node_attribs.each do |attrib|
                attr = self.class.child_attribute_name(node_name, attrib)
                value = method(attr).call
                child.add_attribute(attr, value) unless value.nil?
              end
            end
          end
        end

        item_node
      end

      private

      # generate getters and setters
      
      def self.instance_method_exists?(method)
        # In Ruby 1.8, Object.instance_methods returns and array of strings
        # In Ruby 1.9+, it returns an array of symbols
        method = RUBY_VERSION < '1.9' ? method.to_s : method.to_sym

        instance_methods.include?(method)
      end
      
      def self.child_attribute_name(child_node, attribute)
        "#{child_node}_#{attribute}"
      end

      def self.getter_unless_exists(attr)
        getter = attr.to_sym
        attr_reader attr unless instance_method_exists?(getter)
      end
      
      def self.setter_unless_exists(attr)
        setter = "#{attr}=".to_sym
        attr_writer attr unless instance_method_exists?(setter)
      end

      ATTRIBUTES.each do |attrib|
        getter_unless_exists(attrib)
        setter_unless_exists(attrib)
      end

      CHILD_NODES.each do |name, attribs|
        getter_unless_exists(name)
        setter_unless_exists(name)
        
        attribs.each do |attrib|
          child_attribute_name(name, attrib).tap do |attr|
            getter_unless_exists(attr)
            setter_unless_exists(attr)
          end
        end
      end

    end
  end
end
