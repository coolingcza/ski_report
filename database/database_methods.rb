# Module: DatabaseClassMethods
#
# Facilitates Class interaction with database.
#
# Public Methods:
# #find
# #all
# #find_by_attr

module DatabaseClassMethods
  
  # Public: find
   # Inserts the newly created item into the database.
   #
   # Parameters:
   # table     - String: the table being searched.
   # record_id - Number: row id number.
   #
   # Returns: 
   # An object generated from information returned from database.
   #
   # State changes:
   # none.
  
  def find(table, record_id)
    results = DATABASE.execute("SELECT * FROM #{table} 
                                WHERE id = #{record_id}")
    record_details = results[0] # Hash of the record's details.
    self.new(record_details)
  end
  
  # Public: all
   # Returns all rows of a given table.
   #
   # Parameters:
   # table - String: the table of interest.
   #
   # Returns: 
   # An array populated with objects.
   #
   # State changes:
   # none.
  
  def all(table)
    results = DATABASE.execute("SELECT * FROM #{table}")
    results_as_objects = []

    results.each do |r|
      results_as_objects << self.new(r)
    end

    results_as_objects
  end
  
  # Public: find_by_attr
   # Searches a given database table for rows with fields matching a given
   # value.
   #
   # Parameters:
   # table - String: the table of interest.
   # field - String: the field name to search in table.
   # value - Number or String: value in table to match.
   #
   # Returns: 
   # @id the primary key for the product key.
   #
   # State changes:
   # Selected values are updated in the database.
  
  def where_attr(table, field, value)
    #set value with ' ' if string
    value = "'#{value}'" if value.is_a? String
    
    results = DATABASE.execute("SELECT * FROM #{table} 
                                WHERE #{field} = #{value}")
    results_as_objects = []

    results.each do |r|
      results_as_objects << self.new(r)
    end

    results_as_objects
  end
    
  
end

# Module: DatabaseInstanceMethods
#
# Facilitates object interaction with database.
#
# Public Methods:
# #insert
# #save
# #delete

module DatabaseInstanceMethods
    
  # Public: insert
   # Inserts the newly created item into the database.
   #
   # Parameters:
   # none
   #
   # Returns: 
   # @id: the primary key for the new row.
   #
   # State changes:
   # New row is created in the database.
    
  def insert
  
    attributes = []
    instance_variables.each do |i|
      attributes << i.to_s.delete("@") if (i != :@id && i != :@table)
    end
  
    values = []
    attributes.each do |a|
      value = self.send(a)
    
      if value.is_a?(Integer)
        values << "#{value}"
      else values << "'#{value}'"
      end
    end
  
    DATABASE.execute("INSERT INTO #{@table} (#{attributes.join(", ")}) 
                      VALUES (#{values.join(", ")})")
    @id = DATABASE.last_insert_row_id

  end
  

  # Public: save
   # Updates database with current object values.
   #
   # Parameters:
   # none
   #
   # Returns: 
   # Array containing Hash of data for saved record.
   #
   # State changes:
   # Row values in the database are updated.

  def save
    attributes = []
    
    instance_variables.each do |i|
      attributes << i.to_s.delete("@") if i != :@table
    end
    
    query_components_array = []
    
    attributes.each do |a|
      value = self.send(a)
      
      if value.is_a?(Integer)
        query_components_array << "#{a} = #{value}"
      else
        query_components_array << "#{a} = '#{value}'"
      end
    end
    
    query_string = query_components_array.join(", ")
    # name = 'Sumeet', age = 75, hometown = 'San Diego'

    DATABASE.execute("UPDATE #{@table} SET #{query_string} WHERE id = #{id}")
  end
  
  # Public: delete
   # Removes a row from the database.
   #
   # Parameters:
   # none
   #
   # Returns: 
   # empty array?
   #
   # State changes:
   # Row is removed from the database.
  
  def delete
    DATABASE.execute("DELETE from #{table} WHERE id = #{id}")
  end

  
end