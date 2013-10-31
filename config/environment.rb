require 'yaml'

# monkeypatch array to avoid requiring activesupport
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless defined? Array.new.extract_options!
end

Dir[File.join(".", "lib/*.rb")].each {|f| require f}

CONFIG = YAML.load_file('config/config.yml')