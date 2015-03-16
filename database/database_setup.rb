unless ActiveRecord::Base.connection.table_exists?(:users)
  ActiveRecord::Base.connection.create_table :users do |t|
    t.text :name
    t.text :password
  end
end
                  
unless ActiveRecord::Base.connection.table_exists?(:resorts)
  ActiveRecord::Base.connection.create_table :resorts do |t|
    t.text :name
    t.float :latitude
    t.float :longitude
    t.text :state
  end
end

unless ActiveRecord::Base.connection.table_exists?(:users_resorts)
  ActiveRecord::Base.connection.create_table :users_resorts do |t|
    t.integer :user_id
    t.integer :resort_id
  end
end                                
                  
