# btsync

A Ruby wrapper for the [BitTorrent Sync API](http://www.bittorrent.com/sync/developers).

## Installation

Add this line to your application's Gemfile:

    gem 'btsync_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install btsync_api

## Usage

Once you started the BitTorrent Sync client as described in the [documentation](http://www.bittorrent.com/sync/developers/api), you can use the wrapper:

```ruby
options = {host: 'localhost', port: 8888, login: '', password: ''} # default
api = BtsyncApi::Api.new(options)
api.get_os # => {"os"=>"mac"}

# pass arguments to the API
api.add_folder(dir: dirPath, secret: my_secret, selective_sync: 1)

api.remove_folder # raises BtsyncApi::ApiError('Specify all the required parameters for remove_folder')
```
*Note:* The error codes from the BitTorrent Sync API are not yet completely consistent, so expect some `NoMethodError` where it should actually be `Btsync::ApiError`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
