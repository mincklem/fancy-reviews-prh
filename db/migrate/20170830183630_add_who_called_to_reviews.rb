class AddWhoCalledToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :who_called, :string
  end
end
