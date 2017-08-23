class AddAuthorToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :author, :string
  end
end
