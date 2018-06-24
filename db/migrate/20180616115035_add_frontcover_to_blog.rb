class AddFrontcoverToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :frontcover, :string
  end
end
