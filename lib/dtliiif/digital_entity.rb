require 'nokogiri'

module Dtliiif
  class DigitalEntity
    def initialize(digital_entity_path)
      @doc = File.open(digital_entity_path) { |f| Nokogiri::XML(f) }
    end

    def marc_record
    end

    def obj_id
    end

    def collection_name
    end

    def label
    end

    def handle
    end

    def filename
    end

    def rights_information
    end
  end
end