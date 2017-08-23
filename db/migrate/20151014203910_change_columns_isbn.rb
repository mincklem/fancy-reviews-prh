class ChangeColumnsIsbn < ActiveRecord::Migration
  def change
  	  	change_column :reviews, :isbn, :string
  end
end
