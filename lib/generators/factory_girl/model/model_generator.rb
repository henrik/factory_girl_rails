require 'generators/factory_girl'
require 'factory_girl_rails'

module FactoryGirl
  module Generators
    class ModelGenerator < Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :dir, :type => :string, :default => "test/factories", :desc => "The directory where the factories should go"

      def create_fixture_file
        factories_file = options[:dir] + ".rb"

        if File.exist?(factories_file)
          factory_definition = template 'single_file_fixtures.erb'

          text = File.read(factories_file)
          new_text = text.gsub(/^end/, factory_definition)
          File.open(factories_file, "w") {|f| f.puts new_text}
        else
          filename = [table_name, filename_suffix].compact.join('_')
          template 'fixtures.erb', File.join(options[:dir], "#{filename}.rb")
        end
      end

      private

      def filename_suffix
        factory_girl_options[:suffix]
      end

      def factory_girl_options
        generators.options[:factory_girl] || {}
      end

      def generators
        config = FactoryGirl::Railtie.config
        config.respond_to?(:app_generators) ? config.app_generators : config.generators
      end
    end
  end
end
