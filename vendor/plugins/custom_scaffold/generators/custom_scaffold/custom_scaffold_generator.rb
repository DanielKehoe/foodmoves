require 'rails_generator/generators/components/scaffold/scaffold_generator'

class CustomScaffoldingSandbox
  include ActionView::Helpers::ActiveRecordHelper

  attr_accessor :form_action, :singular_name, :suffix, :model_instance

  def sandbox_binding
    binding
  end

  def default_input_block
    Proc.new { |record, column| <<-END_ROW 
    <label>#{column.human_name}</label>
    <span>#{input(record, column.name, :limit => column.limit)}</span><br />
END_ROW
    }
  end
end

class ActionView::Helpers::InstanceTag
  def to_input_field_tag(field_type, options={})
    field_meth = "form.#{field_type}_field"
    limit = options.delete(:limit)
    the_limit = ""
    the_limit = "'size' => #{limit}, " if limit and limit < 255
    "<%= #{field_meth} \:#{@method_name}\ %>"
  end

  def to_text_area_tag(options = {})
    limit = options.delete(:limit)
    "<%= form.text_area \:#{@method_name}\ %>"
  end

  def to_date_select_tag(options = {})
    limit = options.delete(:limit)
    "<%= form.date_select \:#{@method_name}\ %>"
  end

  def to_datetime_select_tag(options = {})
    limit = options.delete(:limit)
    "<%= form.datetime_select \:#{@method_name}\ %>"
  end
  
  def to_time_select_tag(options = {})
    limit = options.delete(:limit)
    "<%= form.time_select \:#{@method_name}\ %>"
  end

  def to_boolean_select_tag(options = {})
    limit = options.delete(:limit)
    "<%= form.check_box \:#{@method_name}\ %>"
  end
end

class CustomScaffoldGenerator < ScaffoldGenerator

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}ControllerTest", "#{controller_class_name}Helper"

      # Controller, helper, views, and test directories.
      m.directory File.join('app/controllers', controller_class_path)
      m.directory File.join('app/helpers', controller_class_path)
      m.directory File.join('app/views', controller_class_path, controller_file_name)
      m.directory File.join('app/views/layouts', controller_class_path)
      m.directory File.join('test/functional', controller_class_path)

      # Depend on model generator but skip if the model exists.
      # DK removed 5/11/07
      # m.dependency 'model', [singular_name], :collision => :skip, :skip_migration => true

      # Scaffolded forms.
      m.complex_template "form.rhtml",
        File.join('app/views',
                  controller_class_path,
                  controller_file_name,
                  "_form.rhtml"),
        :insert => 'form_scaffolding.rhtml',
        :sandbox => lambda { create_sandbox },
        :begin_mark => 'form',
        :end_mark => 'eoform',
        :mark_id => singular_name

      # DK changed 5/11/07
      # scaffold_views = %w{list show new edit}
      scaffold_views = %w{index show new edit}

      # Scaffolded views.
      scaffold_views.each do |action|
        m.template "view_#{action}.rhtml",
                   File.join('app/views',
                             controller_class_path,
                             controller_file_name,
                             "#{action}.rhtml"),
                   :assigns => { :action => action }
      end

      # Controller class, functional test, helper, and views.
      m.template 'controller.rb',
                  File.join('app/controllers',
                            controller_class_path,
                            "#{controller_file_name}_controller.rb"), :collision => :skip

      # DK removed 5/11/07
      # m.template 'functional_test.rb',
      #            File.join('test/functional',
      #                      controller_class_path,
      #                      "#{controller_file_name}_controller_test.rb"), :collision => :skip

      m.template 'helper.rb',
                  File.join('app/helpers',
                            controller_class_path,
                            "#{controller_file_name}_helper.rb"), :collision => :skip

      # Layout and stylesheet.
      # DK removed 5/11/07
      # m.template 'layout.rhtml',
      #           File.join('app/views/layouts',
      #                     controller_class_path,
      #                     "#{controller_file_name}.rhtml"), :collision => :skip

      m.template 'style.css',     'public/stylesheets/scaffold.css', :collision => :skip


      # Unscaffolded views.
      unscaffolded_actions.each do |action|
        path = File.join('app/views',
                          controller_class_path,
                          controller_file_name,
                          "#{action}.rhtml")
        m.template "controller:view.rhtml", path,
                   :assigns => { :action => action, :path => path}
      end
    end
  end

  def create_sandbox
    sandbox = CustomScaffoldingSandbox.new
    sandbox.singular_name = singular_name
    begin
      sandbox.model_instance = model_instance
      sandbox.instance_variable_set("@#{singular_name}", sandbox.model_instance)
    rescue ActiveRecord::StatementInvalid => e
        logger.error "Before updating scaffolding from new DB schema, try creating a table for your model (#{class_name})"
        raise SystemExit
    end
    sandbox.suffix = suffix
    sandbox
  end
end
