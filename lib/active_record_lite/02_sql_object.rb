require_relative 'db_connection'
require_relative '00_attr_accessor_object'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject < AttrAccessorObject
  def self.parse_all(results)
    results.map { |params_hash| self.new(params_hash) }
  end
end

class SQLObject < MassObject
  # include AttrAccessorObject

  def self.columns
    _table_name = self.table_name
    # _table_name = 'cats'
    columns = DBConnection.execute2("SELECT * FROM #{_table_name}").first
     # columns = [:id, :name, :owner_id]
    columns.each do |column|
      self.my_attr_accessor(column)
    end

    columns.map { |col_string| col_string.to_sym }
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # unless @table_name
   #    class_name = self.to_s.underscore.pluralize
   #
   #  end

    @table_name ||= self.to_s.underscore.pluralize
  end

  # return an array of all the records in the DB
  def self.all
    sql = <<-SQL
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    SQL

    self.parse_all(DBConnection.execute(sql))
  end
  # look up a single record by primary key
  def self.find(id)
    sql = <<-SQL
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    WHERE
    #{table_name}.id = #{id}
    SQL

    self.new(DBConnection.execute(sql).first)
  end

  def attributes
    @attributes ||= Hash.new
  end
  # insert a new row into the table to represent the SQLObject.
  def insert
    # doesn't this already includes an :id attribute?
    attributes_hash = self.attributes
    p attributes_hash
    insert_into_string = attributes_hash.keys.join(', ')
    p attributes_hash.keys
    values_symbol_string = attributes_hash.keys.map { |att| ":#{att}"}.join(', ')
    # puts "insert into"
    # puts "#{self.class.table_name} (#{insert_into_string})"
    # puts "value_symbol:"
    # puts "(#{values_symbol_string})"
    sql = <<-SQL
    INSERT INTO
    #{self.class.table_name} (#{insert_into_string})
    VALUES
    (#{values_symbol_string})
    SQL

    DBConnection.execute(sql, attributes_hash)

    self.id = DBConnection.last_insert_row_id
  end

  def initialize(params)
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym
      unless self.class.columns.include?(attr_sym)
        raise "unknown attribute #{attr_name}"
      end
    end

    super(params)

  end
  # convenience method that either calls insert/update depending on whether the SQLObject already exists in the table.
  def save
    # ...
  end
  # update the row with the id of this SQLObject
  def update
    # ...
  end

  def attribute_values
    # ...
  end
end
