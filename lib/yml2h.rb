require_relative "yml2h/version"
require "erb"
require "fileutils"
require "ostruct"
require "yaml"

module Yml2h
  module Write
    attr_writer :output_file
    def write_to_yaml!(path = nil)
      destination = path || @output_file || "anonymous.yml"
      write_to_yaml(self, Pathname.new(destination))
    end

    # NOTE: When a hash is extended with Write, #write_to_yaml becomes available as a private method.
    module_function

    # @param object [Object] A ruby object which can be written to YAML
    # @param path [String] An absolute path which the YAML will be written to
    def write_to_yaml(hash, path)
      File.open(path, "w") { |f| f.write(hash.to_yaml) }
    end
  end

  module Read
    attr_writer :input_file
    def read_from_yaml!(path = nil, permitted_classes: nil)
      input = path || @input_file || "anonymous.yml"
      read_from_yaml(input, permitted_classes: permitted_classes)
    end

    module_function

    # @param path [String, Pathname] An absolute path to parseable YAML contents
    # @param permitted_classes [Array<Object>] Keyword arg; Additive list of classes to permit when loading a file
    def read_from_yaml(path, permitted_classes: nil)
      raw = ERB.new(Pathname.new(path).read).result(binding)
      permitted_classes ||= [Symbol, Struct, OpenStruct, Time, Date, DateTime]
      YAML.safe_load(raw, permitted_classes: permitted_classes)
    rescue ArgumentError => e
      # TODO: Remove after ruby 2.5 support dropped (currently only here for AWS compat)
      fail e unless e.message.match?(/unknown keyword: permitted_classes/)
      YAML.safe_load(raw, permitted_classes)
    end
  end

  module Compile
    attr_writer :input_dir
    def compile_from_dir!(dir = nil, extension: false, **options)
      source = dir || @input_dir || `pwd`.chomp
      compile_from_dir(Pathname.new(source), extension: extension, **options).to_h
    end

    module_function

    # @param dir [String, Pathname] An absolute path to a directory which will have YAML files
    # @param extension [Boolean] Whether or not to keep the file extension in the compiled result
    # @param options @see Read#read_from_yaml
    # @return [Array<Array<String, Object>>] Set of arrays where idx0 is the file name (extension optionally truncated), idx1 the attributes
    def compile_from_dir(dir, extension: false, **options)
      include_fixtures = singleton_class.included_modules.include?(Read)
      file_extensions = %w[yml yaml]
      file_extensions += %w[yml.erb yaml.erb] if include_fixtures

      Dir.glob("#{dir}/*.{#{file_extensions.join(",")}}").map do |filename|
        definition = filename

        # Drop final "/" and extension unless specified
        unless extension
          # Drop extension
          definition = definition.gsub(/\.(yml|yaml)(\.erb)?\z/i, "")
          # Capture final "/" onwards
          definition = definition.match(/\/\w+\z/i).to_s
          # Drop "/"
          definition = definition.sub("/", "")
        end

        # If we have access to Read#read_from_yaml!, use it here for injecting our current binding
        as_object = if include_fixtures
          read_from_yaml!(filename, **options)
        else
          Read.read_from_yaml(filename, **options)
        end

        [definition, as_object]
      end
    end
  end
end
