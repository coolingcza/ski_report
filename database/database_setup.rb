
DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS users 
                  (id INTEGER PRIMARY KEY, name TEXT)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS resorts
                  (id INTEGER PRIMARY KEY, name TEXT, latitude FLOAT, 
                  longitude FLOAT, state TEXT)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS markers
                  (id INTEGER PRIMARY KEY, condition TEXT, description TEXT)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS users_resorts
                  (user_id NUMBER, resort_id NUMBER)")
                  
                  
                  
                  