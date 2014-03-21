require_relative '04_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)


    through_options = self.assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]


    define_method(name) do
      source_options.model_class.find(source_options.primary_key)
    end
     #= assoc_options[source_name]
  end
end



#options = BelongsToOptions.new(name, options) #this is a bit confusing; options is a reassigned to a mapping of the original options
# self.class.assoc_options[name] = options
#
# #.to_s
# define_method(name) do
#   options.model_class.find(options.primary_key)
# end