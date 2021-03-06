require 'iiif/presentation'
require 'dtliiif/digital_entity'

module Dtliiif
  class Builder
    def initialize(iiif_host, manifest_host, image_filetype)
      @iiif_host = iiif_host
      @manifest_host = manifest_host
      @image_filetype = image_filetype
    end

    def build(digital_entity_path)
      digital_entity_file = Dtliiif::DigitalEntity.new(digital_entity_path)

      @sequence_base = "#{@iiif_host}/#{digital_entity_file.obj_id}"

      sequence = IIIF::Presentation::Sequence.new
      sequence.canvases = digital_entity_file.filenames.map.with_index { |comp, i| image_annotation_from_id("#{comp}.#{@image_filetype}", "#{comp}", i) }

      range = IIIF::Presentation::Range.new
      range.ranges = digital_entity_file.filenames.map.with_index { |comp, i| build_range("#{comp}.#{@image_filetype}", "#{comp}", i) }

      manifest = build_manifest(digital_entity_file)
      manifest.sequences << sequence
      manifest.structures << range
      thumb = sequence.canvases.first.images.first.resource['@id'].gsub(/full\/full/, 'full/!200,200')
      manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)

      structures = manifest["structures"][0]["ranges"]
      manifest["structures"] = structures
      manifest.to_json(pretty: true)
    end

    def build_manifest(digital_entity_file)
      seed = {
          '@id' => "#{@manifest_host}/#{digital_entity_file.obj_id}.json",
          'label' => "#{digital_entity_file.label}",
          'viewing_hint' => 'paged',
          'attribution' => "#{digital_entity_file.rights_information}",
          'metadata' => [
            {"handle": "#{digital_entity_file.handle}"},
            {"label": "Preferred Citation", "value": "#{digital_entity_file.label}, #{digital_entity_file.collection_name}, #{digital_entity_file.collection_id + ', ' unless digital_entity_file.collection_name.include?("Becker")}#{digital_entity_file.owner}, #{digital_entity_file.handle}."}
          ]
      }
      IIIF::Presentation::Manifest.new(seed)
    end

    def image_annotation_from_id(image_file, label, order)
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      canvas_id = "#{@sequence_base}/canvas/000#{order}"

      seed = {
          '@id' => "#{canvas_id}/annotation/1",
          'on' => canvas_id
      }
      annotation = IIIF::Presentation::Annotation.new(seed)
      annotation.resource = image_resource_from_page_hash(image_file)

      build_canvas(annotation, canvas_id, label)
    end

    def build_canvas(annotation, canvas_id, label)
      seed = {
          '@id' => canvas_id,
          'label' => label,
          'width' => annotation.resource['width'],
          'height' => annotation.resource['height'],
          'images' => [annotation]
      }
      IIIF::Presentation::Canvas.new(seed)
    end

    def build_range(image_file, label, order)
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      range_id = "#{@sequence_base}/range/r-#{order}"
      canvas_id = "#{@sequence_base}/canvas/000#{order}"

      seed = {
          '@id' => range_id,
          'label' => label,
          'canvases' => [canvas_id]
      }
      IIIF::Presentation::Range.new(seed)
    end

    def image_resource_from_page_hash(page_id)
      base_uri = "#{@iiif_host}/#{page_id}"
      image_api_params = '/full/full/0/default.jpg'

      params = {
          service_id: base_uri,
          resource_id_default: "#{base_uri}#{image_api_params}",
          resource_id: "#{base_uri}#{image_api_params}"
      }
      IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end
  end
end
