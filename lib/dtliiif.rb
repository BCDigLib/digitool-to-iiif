require 'dtliiif/version'
require 'dtliiif/opts'
require 'dtliiif/builder'
require 'optparse'

module Dtliiif
  def self.main
    cnf = Opts.cnf

    iiif_host = build_server_string(cnf['iiif_server'])
    manifest_host = build_server_string(cnf['manifest_server'])
    image_filetype = cnf['image_filetype']

    digital_entity_path = ARGV[0]

    @builder = Dtliiif::Builder.new(iiif_host, manifest_host, image_filetype)
    manifest = @builder.build(digital_entity_path)
    puts manifest
  end

  def self.build_server_string(cnf)
    "#{cnf['protocol']}://#{cnf['host']}#{cnf['path']}"
  end
end