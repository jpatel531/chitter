# encoding: UTF-8

require 'sinatra/base'

module Sinatra
  module Partial
    
    # This is here to make testing the private code easier while not including it in the helpers.
    module Private
      
      # This gets the path to the template, taking into account whether leading underscores are needed.      
      # @private
      # param [String] partial_path
      # param [true,false,nil] underscores Defaults to false
      def self.partial_expand_path(partial_path, underscores=false)
        underscores ||= false
        dirs, base = File.dirname(partial_path), File.basename(partial_path) 
        base.insert(0, "_") if underscores
        xs = dirs == "." ? [base] : [dirs, base]
        File.join(xs).to_sym
      end
      
      # This takes the name of the local from the template's name, and corrects local by removing leading underscore if it's there.
      # @private
      # param [String] partial_path
      def self.partial_local(partial_path)
        partial_path = partial_path[1..-1] if partial_path.start_with? "_"
        File.basename(partial_path).to_sym
      end
    end
    
    
    module Helpers
      # Renders a partial to a string.
      # 
      # @param [#to_s] partial_name The partial to render.
      # @param [Hash] options The options to render the partial with.
      # @option options [Hash] :locals Local variables to render with
      # @option options [Array] :collection Renders the template once per object in this array.
      # @option options [Symbol] :template_engine The template engine to use. Haml by default.
      # @option options [true,false] :underscores Set to true if you wish to follow the Rails convention of partial files having a leading underscore.
      #
      # @return [String] The rendered template contents.
      #
      # @example simply render a partial
      #   partial(:meta, :locals => {meta: meta})
      #     # => renders views/_meta.haml
      #
      # @example render a partial in a subfolder
      #   partial("meta/news", :locals => {news: [<News>]})
      #     # => renders views/meta/_news.haml
      #
      # @example render a collection of objects with one partial
      #   partial(:"meta/news", :collection => [<News>])
      #     # => renders views/meta/_news.haml once per item in :collection,
      #           with the local variable `news` being the current item in the iteration
      def partial(partial_name, options={})
        options.merge! :layout => false
        partial_location = partial_name.to_s
        engine = options.fetch(:template_engine, settings.partial_template_engine)
        underscores = options.fetch(:underscores, settings.partial_underscores)
        
        template = Private.partial_expand_path(partial_location, underscores)
        
        if collection = options.delete(:collection)
          member_local = Private.partial_local(partial_location)
        
          locals = options.fetch(:locals, {})
  
          collection.inject([]) do |buffer, member|
            new_locals = {member_local => member}.merge(locals)
            buffer << self.method(engine).call(template, options.merge(:locals => new_locals))
          end.join("\n")
        else
          # TODO benchmark this and see if caching the method
          # speeds things up
          self.method(engine).call(template, options)
        end
      end
      
    end # of Helpers
    
    # This is here to allow configuration options to be set.
    # @private
    def self.registered(app)
      app.helpers(Partial::Helpers)
      
      # Configuration
      app.set :partial_underscores, false
      app.set :partial_template_engine, :haml
    end
    
  end # Partial
  register(Sinatra::Partial)
end


