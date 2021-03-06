module Prow
  module AppBuilder
    class Create < Struct.new(:path)
      def perform
        copy('config.ru')
        copy('Guardfile')
        mkdir('public')
        mkdir('templates')
        mkdir('config')
        mkdir('templates/layouts')
        mkdir('templates/pages')
        mkdir('templates/partials')
        copy('config/pages.json')
        copy_partials
        mkdir('sass')
        create_and_move_stylesheets
        copy_pages_and_layouts
      end

      def copy_pages_and_layouts
        copy('templates/layouts/default.mustache')
        copy('templates/pages/index.mustache')
      end

      def copy_partials
        ShipdStyle::CopyDirectory.new(app_path + "/templates/partials", "templates").perform
      end

      def create_and_move_stylesheets
        copier = ShipdStyle::CopyStylesheets.new(app_path)
        copier.perform
        copier.remove_namespace
      end

      def mkdir(dir)
        FileUtils.mkdir(app_path + "/" + dir) unless File.exist?(dir)
      end

      def copy(file_path)
        FileUtils.cp(templates_path + "/" + file_path, app_path + "/" + file_path)
      end

      def templates_path
        File.dirname(__FILE__) + "/templates"
      end

      def app_path
        path || `pwd`.chomp
      end
    end
  end
end
