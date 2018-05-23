require 'dtliiif/version'
require 'dtliiif/builder'
require 'yaml'

module Dtliiif
  def self.main
    OptionParser.new do |parser|
      parser.banner = "Usage: metsiiif [options] /path/to/digital/entity/file"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    cnf = YAML::load_file(File.join(__dir__, '../config.yml'))

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