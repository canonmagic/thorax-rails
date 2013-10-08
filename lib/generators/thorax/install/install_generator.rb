require 'generators/thorax/resource_helpers'

module Thorax
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Thorax::Generators::ResourceHelpers

      source_root File.expand_path("../templates", __FILE__)

      desc "This generator a directory sturcture for thorax in  app/assets/javascripts"

      class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
                              :desc => "Skip Git ignores and keeps"


      def inject_thorax
        inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree" do
          "//= require underscore\n//= require backbone\n//= require handlebars.runtime\n//= require thorax\n//= require root\n//= require view\n//= require collection-view\n//= require layout-view\n//= require model\n//= require collection\n//= require_tree ./templates\n//= require_tree ./models\n//= require_tree ./collections\n//= require_tree ./views\n//= require_tree ./routers\n"
        end
      end

      def create_dir_layout
        %W{collections routers models views}.each do |dir|
          empty_directory "app/assets/javascripts/#{dir}"
          create_file "app/assets/javascripts/#{dir}/.gitkeep" unless options[:skip_git]
        end
        empty_directory "app/assets/javascripts/templates"
        create_file "app/assets/templates/.gitkeep" unless options[:skip_git]
      end

      def create_class_files
        template "collection-view.coffee", "app/assets/javascripts/collection-view.js.coffee"
        template "collection.coffee", "app/assets/javascripts/collection.js.coffee"
        template "layout-view.coffee", "app/assets/javascripts/layout-view.js.coffee"
        template "model.coffee", "app/assets/javascripts/model.js.coffee"
        template "view.coffee", "app/assets/javascripts/view.js.coffee"
        template "root.coffee", "app/assets/javascripts/views/root.js.coffee"
        template "root.hbs", "app/assets/javascripts/templates/root.hbs"
        template "namespace.coffee", "app/assets/javascripts/#{application_name.underscore}.js.coffee"
        template "init.js", "app/assets/javascripts/init.js"
      end

      def init_thorax
        append_file "app/assets/javascripts/application.js", File.open("app/assets/javascripts/init.js", "rb").read
        File.delete("app/assets/javascripts/init.js")
      end
    end
  end
end
