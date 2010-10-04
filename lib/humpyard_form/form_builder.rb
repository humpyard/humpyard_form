module HumpyardForm
  ####
  # HumpyardForm::FormHelper is a helper for forms 
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    attr_reader :object, :options, :html_options, :url, :form_type
    
    @@file_methods = [ :file?, :public_filename ]
    
    cattr_accessor :file_methods
    
    def initialize(renderer, object, options={})
      @renderer = renderer
      @object = @renderer.convert_to_model(object)
      @html_options = options.delete(:html) || {}
      @html_options[:class] = @html_options[:class] ? "#{@html_options[:class]} humpyard-form" : 'humpyard-form'
      @url = options.delete(:url) || @renderer.polymorphic_path(@object)
      @options = options
      
      if object.respond_to?(:persisted?) && object.persisted?
        @form_type = 'Edit'
        @html_options[:'data-action'] = @renderer.dom_class(object, :edit),
        @html_options[:method] = :put
      else
        @form_type = 'New'
        @html_options[:'data-action'] = @renderer.dom_class(object, :new),
        @html_options[:method] = :post 
      end
    end
        
    def namespace
      if @options[:as]
        @options[:as]
      else
        @object.class.name.underscore.gsub('/', '_')
      end
    end
    
    def uuid
      @uuid ||= rand(1000)
    end
    
    def inputs
    end
    
    def input(method, options={}) #:nodoc:
      options[:as] ||= default_input_type(method)
      options[:translation_info] = translation_info(method)
      @renderer.render :partial => "/humpyard_form/form_element", :locals => {:form => self, :name => method, :options => options, :as => options[:as]}
    end
    
    def inputs_for(method, options={}, &block)
      records = object.send(method)
      result = ''
      counter = 0
      records.each do |record|
        form = HumpyardForm::FormBuilder.new(@renderer, record, :url => @url, :as => "#{namespace}[#{method}_attributes][#{counter}]")
        inner_haml = @renderer.capture_haml(form, &block)
        result += @renderer.render :partial => '/humpyard_form/fields_for', :locals => {:form => form, :inner_haml => inner_haml}
        counter += 1
      end
      if options[:add_empty_set]
        form = HumpyardForm::FormBuilder.new(@renderer, records.new, :url => @url, :as => "#{namespace}[#{method}_attributes][#{counter}]")
        inner_haml = @renderer.capture_haml(form, &block)
        result += @renderer.render :partial => '/humpyard_form/fields_for', :locals => {:form => form, :inner_haml => inner_haml} 
      end
      result.html_safe
    end
    
    def submit(options={})
      @renderer.render :partial => '/humpyard_form/submit', :locals => {:form => self, :options => options}
    end

    def translation_info(method) #:nodoc:
      if @object.respond_to?(:translated_attribute_names) and @object.translated_attribute_names.include?(method)
        tmp = @object.class.translation_class.new
        if tmp
          column = tmp.column_for_attribute(method) if tmp.respond_to?(:column_for_attribute)
          if column
            {:locales => HumpyardForm::config.locales, :column => column}
          end
        end
      else
        false
      end
    end
    
    # Get Column infomation for methods
    def column_info(method)
      column = @object.column_for_attribute(method) if @object.respond_to?(:column_for_attribute)
      
      # translated attributes dont have a column info at this point
      # check the associated translation class
      if not column
        tx_info = translation_info(method)
        if tx_info
          column = tx_info[:column]
        end
      end
      
      column
    end
    
    # For methods that have a database column, take a best guess as to what the input method
    # should be.  In most cases, it will just return the column type (eg :string), but for special
    # cases it will simplify (like the case of :integer, :float & :decimal to :numeric), or do
    # something different (like :password and :select).
    #
    # If there is no column for the method (eg "virtual columns" with an attr_accessor), the
    # default is a :string, a similar behaviour to Rails' scaffolding.
    #
    def default_input_type(method) #:nodoc:
      column = column_info(method)

      if column
        # handle the special cases where the column type doesn't map to an input method
        return :time_zone if column.type == :string && method.to_s =~ /time_zone/
        return :select    if column.type == :integer && method.to_s =~ /_id$/
        return :datetime  if column.type == :timestamp
        return :numeric   if [:integer, :float, :decimal].include?(column.type)
        return :password  if column.type == :string && method.to_s =~ /password/
        #return :country   if column.type == :string && method.to_s =~ /country/

        # otherwise assume the input name will be the same as the column type (eg string_input)
        return column.type
      else
        if @object
          #return :select if find_reflection(method)
         
          file = @object.send(method) if @object.respond_to?(method)
          if file && @@file_methods.any? { |m| file.respond_to?(m) }
            if file.styles.keys.empty?
              return :file
            else
              return :image_file
            end
          end
        end

        return :password if method.to_s =~ /password/
        return :string
      end
    end
    
    # Used by select and radio inputs. The collection can be retrieved by
    # three ways:
    #
    # * Explicitly provided through :collection
    # * Retrivied through an association
    # * Or a boolean column, which will generate a localized { "Yes" => true, "No" => false } hash.
    #
    # If the collection is not a hash or an array of strings, fixnums or arrays,
    # we use label_method and value_method to retreive an array with the
    # appropriate label and value.
    #
    def find_collection_for_column(column, options) #:nodoc:
      collection = find_raw_collection_for_column(column, options)

      # Return if we have an Array of strings, fixnums or arrays
      return collection if (collection.instance_of?(Array) || collection.instance_of?(Range)) &&
                           [Array, Fixnum, String, Symbol].include?(collection.first.class)

      label, value = detect_label_and_value_method!(collection, options)
      collection.map { |o| [send_or_call(label, o), send_or_call(value, o)] }
    end
    
    # As #find_collection_for_column but returns the collection without mapping the label and value
    #
    def find_raw_collection_for_column(column, options) #:nodoc:
      collection = if options[:collection]
        options.delete(:collection)
      elsif reflection = self.reflection_for(column.to_s.gsub(/_id$/, '').to_sym)
        options[:find_options] ||= {}

        if conditions = reflection.options[:conditions]
          options[:find_options][:conditions] = reflection.klass.merge_conditions(conditions, options[:find_options][:conditions])
        end

        reflection.klass.find(:all, options[:find_options])
      else
        create_boolean_collection(options)
      end

      collection = collection.to_a if collection.is_a?(Hash)
      collection
    end
    
    # Detects the label and value methods from a collection values set in 
    # @@collection_label_methods. It will use and delete
    # the options :label_method and :value_methods when present
    #
    def detect_label_and_value_method!(collection_or_instance, options = {}) #:nodoc
      label = options.delete(:label_method) || detect_label_method(collection_or_instance)
      value = options.delete(:value_method) || :id
      [label, value]
    end

    # Detected the label collection method when none is supplied using the
    # values set in @@collection_label_methods.
    #
    def detect_label_method(collection) #:nodoc:
      HumpyardForm::config.collection_label_methods.detect { |m| collection.first.respond_to?(m) }
    end

    # Detects the method to call for fetching group members from the groups when grouping select options
    #
    def detect_group_association(method, group_by)
      object_to_method_reflection = self.reflection_for(method)
      method_class = object_to_method_reflection.klass

      method_to_group_association = method_class.reflect_on_association(group_by)
      group_class = method_to_group_association.klass

      # This will return in the normal case
      return method.to_s.pluralize.to_sym if group_class.reflect_on_association(method.to_s.pluralize)

      # This is for belongs_to associations named differently than their class
      # form.input :parent, :group_by => :customer
      # eg. 
      # class Project
      #   belongs_to :parent, :class_name => 'Project', :foreign_key => 'parent_id'
      #   belongs_to :customer
      # end
      # class Customer
      #   has_many :projects
      # end
      group_method = method_class.to_s.underscore.pluralize.to_sym
      return group_method if group_class.reflect_on_association(group_method) # :projects

      # This is for has_many associations named differently than their class
      # eg. 
      # class Project
      #   belongs_to :parent, :class_name => 'Project', :foreign_key => 'parent_id'
      #   belongs_to :customer
      # end
      # class Customer
      #   has_many :tasks, :class_name => 'Project', :foreign_key => 'customer_id'
      # end
      possible_associations =  group_class.reflect_on_all_associations(:has_many).find_all{|assoc| assoc.klass == object_class}
      return possible_associations.first.name.to_sym if possible_associations.count == 1

      raise "Cannot infer group association for #{method} grouped by #{group_by}, there were #{possible_associations.empty? ? 'no' : possible_associations.size} possible associations. Please specify using :group_association"
    end
    
    
 
    
    
    # Returns a hash to be used by radio and select inputs when a boolean field
    # is provided.
    #
    def create_boolean_collection(options) #:nodoc:
      options[:true] ||= ::I18n.t(:yes)
      options[:false] ||= ::I18n.t(:no)
      options[:value_as_class] = true unless options.key?(:value_as_class)

      [ [ options.delete(:true), true], [ options.delete(:false), false ] ]
    end  
    
    
    # If an association method is passed in (f.input :author) try to find the
    # reflection object.
    #
    def reflection_for(method) #:nodoc:
      @object.class.reflect_on_association(method) if @object.class.respond_to?(:reflect_on_association)
    end
    
    def send_or_call(duck, object)
      if duck.is_a?(Proc)
        duck.call(object)
      else
        object.send(duck)
      end
    end
  end
end