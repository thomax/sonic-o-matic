# sonic-o-matic

Crowdsourced Spotify playlist assembly :-)

## Usage

	git clone git@github.com:thomax/sonic-o-matic.git
	cd sonic-o-matic
	bundle install

Get a Spotify app key, and put it here config/spotify_appkey.key.

  cp config/config-example.yml config/config.yml

...and and your Spotify credentials.

	./bin/sonic-o-matic start


## TODO
* some tests
* player stop/next/previous
* store tracks to a collaborative playlist
* web interface
