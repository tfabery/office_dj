class AddImageToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :image, :string
  end
end
