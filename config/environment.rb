require 'yaml'
Dir[File.join(".", "lib/*.rb")].each {|f| require f}

SPOTIFY_CONFIG = YAML.load_file('config/spotify_credentials.yml')