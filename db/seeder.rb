require 'sqlite3'
require_relative '../config'

db = SQLite3::Database.new(DB_PATH)

puts "Använder databasen: #{DB_PATH}"
puts "🧹 Tar bort gamla tabeller..."
db.execute('DROP TABLE IF EXISTS todos')

puts "🧱 Skapar tabeller..."
db.execute('CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, 
            description TEXT,
            category_id INTEGER NOT NULL
            completed INTEGER DEFAULT 0 )')

db.execute('CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT )')

puts "🍎 Fyller på med data..."
db.execute('INSERT INTO todos (name, description, category_id, completed) VALUES ("Köp mjölk", 1, "3 lite mellanmjölk, eko", 1)')
db.execute('INSERT INTO todos (name, description, category_id, completed) VALUES ("Köp julgran", 1, "En rödgran", 0)')
db.execute('INSERT INTO todos (name, description, category_id, completed) VALUES ("Pynta gran", 2, "Glöm inte lamporna i granen och tomten", 0)')
db.execute('INSERT INTO categories (name, description) VALUES ("Köp", "En inköpslista")')
db.execute('INSERT INTO categories (name, description) VALUES ("Göra", "Något som ska göras")')

puts "✅ Databasen är seedad!"