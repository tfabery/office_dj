class AddColumnsToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :artist, :string
    add_column :libraries, :popularity, :integer
    add_column :libraries, :album, :string
  end
end
