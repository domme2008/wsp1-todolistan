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
        @todos = ('SELECT * FROM todos')     
        @categories = ('SELECT * FROM categories')
        ap @todos
        ap @categories
        erb(:'todos/index')
    end

    get '/categories' do
        @todos = ('SELECT * FROM todos')
        @categories = ('SELECT * FROM categories')
        ap @todos
        ap @categories
        erb(:'categories/index')
    end

    get '/todos/:id' do | id |
        @todo = ('SELECT * FROM todos WHERE id=?', id)
        @category = ('SELECT * FROM categories WHERE id=?', @todo[category_id])
        ap @todos
        ap @categories
        erb(:'todos/show')
    end

    get '/categories/:id' do | id |
        @todos = ('SELECT * FROM todos WHERE category_id=?', id)
        @category = ('SELECT * FROM categories WHERE id=?', id)
        ap @todos
        ap @category
        erb(:'categories/show')
    end

    get '/todos/new' do 
        @categories = ('SELECT * FROM categories ORDER BY name ASC')
        ap @categories
        erb(:'todos/new')
    end

    get '/categories/new' do
        erb(:'categories/new')
    end

    post '/todos' do
        ap params
        t_name = params[:'todo_name']
        t_description = params[:'todo_description']
        t_completed = params[:'todo_completed']
        t_category = params[:'todo_category']
        db.execute('INSERT INTO todos (name, description, completed, category_id) VALUES (?, ?, ?, ?)',  [t_name, t_description, t_completed, t_category])
        redirect("/todos")
    end
end
