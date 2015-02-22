require "pry"
require "SQLite3"
require "minitest/autorun"

DATABASE = SQLite3::Database.new('powder_report_test.db')

require_relative "../database/database_setup"
require_relative "../database/database_methods"
require_relative "../models/marker"
require_relative "../models/resort"
require_relative "../models/user"

#testclub = DATABASE.execute("INSERT INTO dinnerclubs (name) VALUES 'testname'")

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
    user2 = DATABASE.execute("SELECT * FROM users WHERE id = 1")
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
  
end

class ResortTest < Minitest::Test
  
  #pick up here:
  
  def test_person_insert
    sam=Person.new({"name"=>"Sam","club_id"=>1})
    sam.insert
    sam_ex = DATABASE.execute("SELECT * FROM people WHERE name = 'Sam'")
    assert(sam_ex)
    
  end
  
  def test_person_where_name
    group = Person.where_name("Sam")
    a = DATABASE.execute("SELECT * FROM people WHERE name = 'Sam'")
    assert_equal(group[0].name,a[0]["name"])
  end
  
  def test_person_where_club_id
    group = Person.where_club_id(1)
    a = DATABASE.execute("SELECT * FROM people WHERE club_id = 1")
    assert_equal(group[0].club_id,a[0]["club_id"])
  end
  
end

class MarkerTest < Minitest::Test
  
end

