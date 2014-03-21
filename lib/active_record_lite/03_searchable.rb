require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    #p params
    param_string = params.keys.map{ |att| "#{att} = :#{att}" }.join(' AND ')
    where_line = " WHERE #{param_string}"
    select_line = "SELECT * FROM #{self.table_name} "

    DBConnection.execute(select_line + where_line, params).map do |att_hash|
      self.new(att_hash)
    end
  end
end

class SQLObject
  extend Searchable
end
