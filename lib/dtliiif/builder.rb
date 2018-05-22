require 'iiif/presentation'
require 'dtliiif/digital_entity'

module Dtliiif
  class Builder
    def initialize
      digital_entity_file = Dtliiif::DigitalEntity.new
    end

    def build
    end

    def build_manifest(digital_entity_file)
    end

    def image_annotation_from_id(image_file, label, order)
    end

    def build_canvas(annotation, canvas_id, label)
    end

    def build_range(image_file, label, order)
    end

    def image_resource_from_page_hash(page_id)
    end
  end
end
