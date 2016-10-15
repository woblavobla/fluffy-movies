class MovieUpdateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :movie_update_requests, :force => true do |t|
      t.belongs_to :user
      t.belongs_to :movie
      t.column :kinopoisk_link, :string, :null => false, :default => ''
      t.column :request_time, :timestamp, :null => true
    end
  end
end
