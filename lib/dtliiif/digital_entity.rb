require 'nokogiri'

module Dtliiif
  class DigitalEntity
    def initialize(digital_entity_path)
      @doc = File.open(digital_entity_path) { |f| Nokogiri::XML(f) }
      @cnf = Opts.cnf
      @marc_ns = @cnf['namespaces']['marc']
      @premis_ns = @cnf['namespaces']['premis']
    end

    def marc_record
      descmd = @cnf['de_fields']['desc_md']
      marc_node = @doc.xpath(descmd).content
      marc_node = Nokogiri::XML(marc_node)

      marc_node
    end

    def obj_id
      hdl_suffix = @hdl.split('/').last

      if collection_name == "Liturgy and life collection"
        resource_id = "BC2013_017"
      elsif collection_name == "The Becker Collection"
        resource_id = "becker_"
      elsif collection_name == "Thomas P. O'Neill, Jr. Congressional Papers photographs"
        resource_id = "CA2009_001"
      elsif collection_name == "Boston Gas Company Records"
        resource_id = "MS1986_088"
      end

      resource_id + "_" + hdl_suffix
    end

    def collection_name
      collection_node = @cnf['marc_fields']['local_collection']
      local_collection = @doc.xpath("#{marc_record}/#{local_collection}", 'marc' => @marc_ns).text

      if local_collection == "LITURGY AND LIFE"
        "Liturgy and life collection"
      elsif local_collection == "BECKER COLLECTION"
        "The Becker Collection"
      elsif local_collection == "CONGRESSIONAL ARCHIVES"
         "Thomas P. O'Neill, Jr. Congressional Papers (Tip O'Neill Papers) photographs"
      elsif marc_record.include?("Boston Gas")
        "Boston Gas Company Records"
      end
    end

    def label
      control_node = @cnf['de_fields']['control']

      @doc.xpath("#{control_node}/label").text
    end

    def handle
      presmd = @cnf['de_fields']['preservation_md']
      premis_node = @doc.xpath(presmd).content
      premis_node = Nokogiri::XML(premis_node)
      @hdl = premis_node.xpath('premis:object/premis:objectIdentifier/premis:objectIdentifierValue', 'premis' => @premis_ns).text

      "http://hdl.handle.net/" + @hdl
    end

    def filename
      streamref = @cnf['de_fields']['stream_ref']

      @doc.xpath("#{streamref}/file_name").map { |f| f.text }
    end

    def owner
      owner = @cnf['marc_fields']['owner']

      @doc.xpath("#{marc_record}/#{owner}", 'marc' => @marc_ns).text
    end

    def rights_information
      access_condition = @cnf['marc_fields']['access_condition']

      @doc.xpath("#{marc_record}/#{access_condition}", 'marc' => @marc_ns)
    end
  end
end