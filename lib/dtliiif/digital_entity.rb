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
      marc_node = @doc.at_xpath(descmd).content
      marc_node = Nokogiri::XML(marc_node)

      marc_node
    end

    def premis_record
      presmd = @cnf['de_fields']['preservation_md']
      premis_node = @doc.at_xpath(presmd).content
      premis_node = Nokogiri::XML(premis_node)

      premis_node
    end

    def obj_id
      hdl = premis_record.xpath('premis:object/premis:objectIdentifier/premis:objectIdentifierValue', 'premis' => @premis_ns).text
      hdl_suffix = hdl.split('/').last

      if collection_name == "Liturgy and life collection"
        resource_id = "BC2013_017"
      elsif collection_name == "The Becker Collection"
        resource_id = "becker"
      elsif collection_name == "Thomas P. O'Neill, Jr. Congressional Papers (Tip O'Neill Papers) photographs"
        resource_id = "CA2009_001"
      elsif collection_name == "Boston Gas Company Records"
        resource_id = "MS1986_088"
      end

      resource_id + "_" + hdl_suffix
    end

    def collection_id
      if collection_name == "Liturgy and life collection"
        "BC.2013.017"
      elsif collection_name == "Thomas P. O'Neill, Jr. Congressional Papers (Tip O'Neill Papers) photographs"
        "CA.2009.001"
      elsif collection_name == "Boston Gas Company Records"
        "MS.1986.088"
      end
    end

    def collection_name
      collection_node = @cnf['marc_fields']['local_collection']
      local_collection = marc_record.xpath(collection_node, 'marc' => @marc_ns).map { |el| el.text }

      if local_collection.include?("LITURGY AND LIFE")
        "Liturgy and life collection"
      elsif local_collection.include?("BECKER COLLECTION")
        "The Becker Collection"
      elsif local_collection.include?("CONGRESSIONAL ARCHIVE")
         "Thomas P. O'Neill, Jr. Congressional Papers (Tip O'Neill Papers) photographs"
      elsif marc_record.to_s.include?("Boston Gas")
        "Boston Gas Company Records"
      end
    end

    def label
      control_node = @cnf['de_fields']['control']

      @doc.xpath("#{control_node}/label").text.chomp('.')
    end

    def handle
      hdl = premis_record.xpath('premis:object/premis:objectIdentifier/premis:objectIdentifierValue', 'premis' => @premis_ns).text

      "http://hdl.handle.net/" + hdl
    end

    def filenames
      streamref = @cnf['de_fields']['stream_ref']

      @doc.xpath("#{streamref}/file_name").map { |f| f.text.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg') }
    end

    def owner
      owner = @cnf['marc_fields']['owner']

      if owner.include?('marc')
        marc_record.xpath(owner, 'marc' => @marc_ns).text
      else
        owner
      end
    end

    def rights_information
      access_condition = @cnf['marc_fields']['access_condition']

      marc_record.xpath(access_condition, 'marc' => @marc_ns).text
    end
  end
end