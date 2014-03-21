require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    name = name.to_s #in case name was input as a symbol??

    self.foreign_key = (options[:foreign_key] ||
                  (name.singularize.downcase + "_id").to_sym)
    #self.class_name = options[:class_name] || self.model_class.to_s
    self.class_name =( options[:class_name] ||
                      name.singularize.capitalize.camelcase)
    self.primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s

    self.foreign_key = (options[:foreign_key] ||
                  (self_class_name.singularize.downcase + "_id").to_sym)
    self.class_name = (options[:class_name] ||
                        name.singularize.capitalize.camelcase)
    self.primary_key = options[:primary_key] || :id

  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
     options = BelongsToOptions.new(name, options) #this is a bit confusing; options is a reassigned to a mapping of the original options
     self.assoc_options[name] = options

     #.to_s
     define_method(name) do
       options.model_class.find(options.primary_key)
     end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    #.to_s
    define_method(name) do
      options.model_class.where(options.foreign_key => self.send(options.primary_key))
    end
  end

  def assoc_options
    @assoc_options ||= Hash.new
  end
end

class SQLObject
  extend Associatable
end
