require "pry"
require "SQLite3"
require "minitest/autorun"

DATABASE = SQLite3::Database.new('powder_report_test.db')

require_relative "../database/database_setup"
require_relative "../database/database_methods"
require_relative "../models/resort"
require_relative "../models/user"


class UserTest < Minitest::Test
    
  def test_user_confirm_insert
    user = User.new({"name"=>"Test"})
    user.insert
    a = DATABASE.execute("SELECT * FROM users WHERE name = 'Test'")
    assert(a)
  end
  
  def test_user_where_name
    user = User.where_name("Test")
    a = DATABASE.execute("SELECT * FROM users WHERE name = 'Test'")
    assert(a)
  end
  
  def test_user_save
    user = User.find("users",1)
    user.name = "Biplane"
    user.save
    user = User.find("users",1)
    assert_equal("Biplane",user.name)
  end
  
  def test_user_find
    user1 = DATABASE.execute("SELECT * FROM users WHERE id = 1")
    user2 = User.find("users",1)
    assert_equal(user2.name,user1[0]["name"])
  end
  
  def test_dc_where_attr
    n = User.new({"name"=>"Mogul"})
    n.insert
    a = DATABASE.execute("SELECT * FROM users WHERE name = 'Mogul'") #array of hashes
    b = User.where_attr("users","name","Mogul") #array of objs
    aname = a[0]["name"]
    bname = b[0].name
    assert_equal(bname,aname)
  end
  
  def test_user_all
    a = DATABASE.execute("SELECT * FROM users")
    b = User.all("users")
    assert_equal(b.length,a.length)
  end
  
  def test_insert_user_resort
    a = DATABASE.execute("SELECT * FROM users_resorts")
    user = User.new({"id"=>1,"name"=>"Roger"})
    user.insert_user_resort(user.id,1)
    b = DATABASE.execute("SELECT * FROM users_resorts")
    assert_equal(a.length+1,b.length)
  end
  
  def test_get_user_resorts
    user = User.new({"id"=>1,"name"=>"Roger"})
    DATABASE.execute("INSERT INTO users_resorts (user_id, resort_id) VALUES (1, 1)")
    a = user.get_user_resorts(user.id)
    assert(a.length > 0)
  end
  
  def test_delete_user_resorts
    user = User.new({"id"=>1,"name"=>"Roger"})
    DATABASE.execute("INSERT INTO users_resorts (user_id, resort_id) VALUES (1, 1)")
    user.delete_user_resorts(user.id)
    a = DATABASE.execute("SELECT * FROM users_resorts WHERE user_id=#{user.id}")
    assert(a.length == 0)
  end
  
end

class ResortTest < Minitest::Test
  
  def test_resort_insert
    test=Resort.new({"name"=>"Test Resort","latitude"=>41,"longitude"=>-106,"state"=>"Wyoming"})
    test.insert
    test_ex = DATABASE.execute("SELECT * FROM resorts WHERE name = 'Test Resort'")
    assert(test_ex)
    
  end
  
  def test_resort_where_name
    tr = Resort.where_name("Test Resort")
    a = DATABASE.execute("SELECT * FROM resorts WHERE name = 'Test Resort'")
    assert_equal(tr[0].name,a[0]["name"])
  end
  
  def test_resort_get_states
    r = Resort.get_states
    r_alt = DATABASE.execute("SELECT DISTINCT state FROM resorts")
    assert_equal(r.length,r_alt.length)
  end
  
end


