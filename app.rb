require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    get '/todos' do   
        @todos = db.execute("SELECT * FROM todos")     
        @categories = db.execute("SELECT * FROM categories")
        ap @todos
        ap @categories
        erb(:'todos/index')
    end

    get '/categories' do
        @todos = db.execute("SELECT * FROM todos")
        @categories = db.execute("SELECT * FROM categories")
        ap @todos
        ap @categories
        erb(:'categories/index')
    end

    get '/todos/:id' do | id |
        @todo = db.execute("SELECT * FROM todos WHERE id=?", id).first
        @category = db.execute("SELECT * FROM categories WHERE id=?", @todo[category_id])
        ap @todo
        ap @categories
        erb(:'todos/show')
    end

    get '/categories/:id' do | id |
        @todos = db.execute("SELECT * FROM todos WHERE category_id=?", id).first
        @category = db.execute("SELECT * FROM categories WHERE id=?", id).first
        ap @todos
        ap @category
        erb(:'categories/show')
    end

    get '/todos/new' do 
        @categories = db.execute("SELECT * FROM categories ORDER BY name ASC")
        ap @categories
        erb(:'todos/new')
    end

    get '/categories/new' do
        erb(:'categories/new')
    end

    get '/todos/:id/edit' do | id |
        @todo = db.execute("SELECT * FROM todos WHERE id=?", id)
        @categories = db.execute("SELECT * FROM categories")
        ap @todo
        ap @categories
    end

    get '/categories/:id/edit' do | id |
        @todos = db.execute("SELECT * FROM todos")
        @category = db.execute("SELECT * FROM categories WHERE id=?", id)
        ap @todos
        ap @category
    end

    post '/todos' do
        ap params
        t_name = params[:'todo_name']
        t_description = params[:'todo_description']
        t_completed = params[:'todo_completed']
        t_category = params[:'todo_category']
        db.execute("INSERT INTO todos (name, description, completed, category_id) VALUES (?, ?, ?, ?)",  [t_name, t_description, t_completed, t_category])
        redirect("/todos")
    end

    post '/categories' do
        ap params
        c_name = params[:'category_name']
        c_description = params[:'category_description']
        c_todos = params[:'category_todos']
        db.execute("INSERT INTO categories (name, description) VALUES (?,?)", [c_name, c_description, [category_todos]])
        redirect("/categories")
    end

    post '/todos/:id/delete' do | id |
        db.execute("DELETE FROM todos WHERE id=?", id)
        redirect("/todos")
    end

    post '/categories/:id/delete' do | id |
        db.execute("DELETE FROM categories WHERE id=?", id)
        redirect("/categories")
    end

    post '/todos/:id/update' do | id |
        ap params
        t_name = params[:'todo_name']
        t_description = params[:'todo_description']
        t_completed = params[:'todo_completed']
        t_category = params[:'todo_category']
        db.execute("UPDATE todo SET name=?, description=?, completed=?, category_id=? WHERE id=?", [t_name, t_description, t_completed, t_category, id])
        redirect("/todos")
    end

    post '/categories/:id/update' do | id |
        ap params
        c_name = params[:'category_name']
        c_description = params[:'category_description']
        c_todos = params[:'category_todos']
        db.execute("UPDATE category SET name=?, description=?, todos=? WHERE id=?", [c_name, c_description, [c_todos], id])
        redirect("/categories")
    end

end
