class CreateControllers < ActiveRecord::Migration
  def change
    create_table :controllers do |t|
      t.string :sessions
      t.string :new
      t.string :create
      t.string :destroy

      t.timestamps
    end
  end
end
