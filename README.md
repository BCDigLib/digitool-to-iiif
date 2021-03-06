# Dtliiif

Builds a IIIF manifest from a DigiTool digital entity file using [osullivan](https://github.com/iiif-prezi/osullivan). 
Currently this gem only supports simple MARC objects.

## Installation

To use the command line tool you will need to install locally. Clone or download this repository and install the gem:

    $ git clone https://github.com/BCDigLib/digitool-to-iiif
    $ cd digitool-to-iiif
    $ gem build dtliiif.gemspec
    $ gem install ./dtliiif-x.x.x.gem
    
## Usage

To run on the command line:

    $ dtliiif /path/to/digitool/digital/entity/file > manifest.json

Or use a 'for' loop to generate several manifests:

    $ for file in /path/to/digital/entity/*.xml; do dtliiif $file > `basename $file .xml`.json; done

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/digitool-to-iiif. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dtliiif project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dtliiif/blob/master/CODE_OF_CONDUCT.md).
