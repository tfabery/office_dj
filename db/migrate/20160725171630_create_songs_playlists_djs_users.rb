class CreateSongsPlaylistsDjsUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
    end

    create_table :library do |t|
      t.string :name
    end

    create_table :djs do |t|
      t.string :name
      t.integer :djscore
      t.integer :requests
      t.integer :vetos
      t.integer :user_id
    end

    create_table :songs do |t|
      t.integer :spin_score
      t.integer :library_id
      t.integer :dj_id
    end

    create_table :songs_users do |t|
      t.integer :song_id
      t.integer :user_id
    end
  end
end
