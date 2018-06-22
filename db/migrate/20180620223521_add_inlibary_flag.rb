class AddInlibaryFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :in_library, :boolean
  end
end
