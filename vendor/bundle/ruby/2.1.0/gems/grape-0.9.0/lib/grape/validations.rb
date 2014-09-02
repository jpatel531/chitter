module Grape
  module Validations
    ##
    # All validators must inherit from this class.
    #
    class Validator
      attr_reader :attrs

      def initialize(attrs, options, required, scope)
        @attrs = Array(attrs)
        @required = required
        @scope = scope
      end

      def validate!(params)
        attributes = AttributesIterator.new(self, @scope, params)
        attributes.each do |resource_params, attr_name|
          if @required || resource_params.key?(attr_name)
            validate_param!(attr_name, resource_params)
          end
        end
      end

      class AttributesIterator
        include Enumerable

        def initialize(validator, scope, params)
          @attrs = validator.attrs
          @params = scope.params(params)
          @params = (@params.is_a?(Array) ? @params : [@params])
        end

        def each
          @params.each do |resource_params|
            @attrs.each do |attr_name|
              yield resource_params, attr_name
            end
          end
        end
      end

      def self.convert_to_short_name(klass)
        ret = klass.name.gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr("-", "_")
          .downcase
        File.basename(ret, '_validator')
      end
    end

    ##
    # Base class for all validators taking only one param.
    class SingleOptionValidator < Validator
      def initialize(attrs, options, required, scope)
        @option = options
        super
      end
    end

    # We define Validator::inherited here so SingleOptionValidator
    # will not be considered a validator.
    class Validator
      def self.inherited(klass)
        short_name = convert_to_short_name(klass)
        Validations.register_validator(short_name, klass)
      end
    end

    class << self
      attr_accessor :validators
    end

    self.validators = {}

    def self.register_validator(short_name, klass)
      validators[short_name] = klass
    end

    class ParamsScope
      attr_accessor :element, :parent

      include Grape::DSL::Parameters

      def initialize(opts, &block)
        @element  = opts[:element]
        @parent   = opts[:parent]
        @api      = opts[:api]
        @optional = opts[:optional] || false
        @type     = opts[:type]
        @declared_params = []

        instance_eval(&block) if block_given?

        configure_declared_params
      end

      def should_validate?(parameters)
        return false if @optional && params(parameters).respond_to?(:all?) && params(parameters).all?(&:blank?)
        return true if parent.nil?
        parent.should_validate?(parameters)
      end

      def full_name(name)
        return "#{@parent.full_name(@element)}[#{name}]" if @parent
        name.to_s
      end

      def root?
        !@parent
      end

      protected

      def push_declared_params(attrs)
        @declared_params.concat attrs
      end

      private

      def require_required_and_optional_fields(context, opts)
        if context == :all
          optional_fields = Array(opts[:except])
          required_fields = opts[:using].keys - optional_fields
        else # context == :none
          required_fields = Array(opts[:except])
          optional_fields = opts[:using].keys - required_fields
        end
        required_fields.each do |field|
          field_opts = opts[:using][field]
          raise ArgumentError, "required field not exist: #{field}" unless field_opts
          requires(field, field_opts)
        end
        optional_fields.each do |field|
          field_opts = opts[:using][field]
          optional(field, field_opts) if field_opts
        end
      end

      def validate_attributes(attrs, opts, &block)
        validations = { presence: true }
        validations.merge!(opts) if opts
        validations[:type] ||= Array if block
        validates(attrs, validations)
      end

      def new_scope(attrs, optional = false, &block)
        opts = attrs[1] || { type: Array }
        raise ArgumentError unless opts.keys.to_set.subset? [:type].to_set
        ParamsScope.new(api: @api, element: attrs.first, parent: self, optional: optional, type: opts[:type], &block)
      end

      # Pushes declared params to parent or settings
      def configure_declared_params
        if @parent
          @parent.push_declared_params [element => @declared_params]
        else
          @api.settings.peek[:declared_params] ||= []
          @api.settings[:declared_params].concat @declared_params
        end
      end

      def validates(attrs, validations)
        doc_attrs = { required: validations.keys.include?(:presence) }

        # special case (type = coerce)
        validations[:coerce] = validations.delete(:type) if validations.key?(:type)

        coerce_type = validations[:coerce]
        doc_attrs[:type] = coerce_type.to_s if coerce_type

        desc = validations.delete(:desc)
        doc_attrs[:desc] = desc if desc

        default = validations[:default]
        doc_attrs[:default] = default if default

        values = validations[:values]
        doc_attrs[:values] = values if values

        values = (values.is_a?(Proc) ? values.call : values)

        # default value should be present in values array, if both exist
        if default && values && !values.include?(default)
          raise Grape::Exceptions::IncompatibleOptionValues.new(:default, default, :values, values)
        end

        # type should be compatible with values array, if both exist
        if coerce_type && values && values.any? { |v| !v.kind_of?(coerce_type) }
          raise Grape::Exceptions::IncompatibleOptionValues.new(:type, coerce_type, :values, values)
        end

        doc_attrs[:documentation] = validations.delete(:documentation) if validations.key?(:documentation)

        full_attrs = attrs.collect { |name| { name: name, full_name: full_name(name) } }
        @api.document_attribute(full_attrs, doc_attrs)

        # Validate for presence before any other validators
        if validations.key?(:presence) && validations[:presence]
          validate('presence', validations[:presence], attrs, doc_attrs)
          validations.delete(:presence)
        end

        # Before we run the rest of the validators, lets handle
        # whatever coercion so that we are working with correctly
        # type casted values
        if validations.key? :coerce
          validate('coerce', validations[:coerce], attrs, doc_attrs)
          validations.delete(:coerce)
        end

        validations.each do |type, options|
          validate(type, options, attrs, doc_attrs)
        end
      end

      def validate(type, options, attrs, doc_attrs)
        validator_class = Validations.validators[type.to_s]

        if validator_class
          (@api.settings.peek[:validations] ||= []) << validator_class.new(attrs, options, doc_attrs[:required], self)
        else
          raise Grape::Exceptions::UnknownValidator.new(type)
        end
      end
    end
  end
end

# Load all defined validations.
Dir[File.expand_path('../validations/*.rb', __FILE__)].each do |path|
  require(path)
end
