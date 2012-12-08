require 'yaml'
Dir[File.join(".", "lib/*.rb")].each {|f| require f}

CONFIG = YAML.load_file('config/config.yml')