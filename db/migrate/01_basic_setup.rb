class BasicSetup < ActiveRecord::Migration
  def change
    create_table :users, :force => true do |t|
      t.column 'email', :string, :null => false, :default => ''
      t.column 'admin', :boolean, :null => true, :default => false
      t.column 'first_name', :string, :null => true
      t.column 'last_name', :string, :null => true
      t.column 'created_on', :timestamp, :null => true
    end

    create_table :movies, :force => true do |t|
      t.column 'name', :string, :null => false
      t.column 'kinopoisk_id', :integer, :null => true
      t.column 'name_ru', :string, :null => true
      t.column 'year', :integer, :null => true
      t.column 'country', :string, :null => true
      t.column 'description', :text, :null => true
      t.column 'add_date', :timestamp, :null => true
    end

    create_table :pictures, :force => true do |t|
      t.belongs_to :movie
      t.attachment :image
    end

    create_table :torrents, :force => true do |t|
      t.belongs_to :movie
      t.column 'quality', :string, :null => false, :default => ''
      t.attachment :torrent_file
    end

    create_table :movie_ratings, :force => true do |t|
      t.belongs_to :movie
      t.belongs_to :user
      t.column :rating, :float, :null => false
    end
    add_index :movie_ratings, [:movie_id, :user_id], :unique => true

    create_table :watched_movies, :force => true do |t|
      t.belongs_to :movie
      t.belongs_to :user
      t.column :watched, :boolean, :null => false
    end
    add_index :watched_movies, [:movie_id, :user_id], :unique => true

    create_table :movie_to_watches, :force => true do |t|
      t.belongs_to :movie
      t.belongs_to :user
      t.column :date_of_added, :timestamp, :null => true
    end
    add_index :movie_to_watches, [:movie_id, :user_id], :unique => true


  end
end