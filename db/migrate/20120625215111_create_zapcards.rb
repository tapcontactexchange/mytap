class CreateZapcards < ActiveRecord::Migration
  def change
    create_table :zapcards do |t|

      t.timestamps
    end
  end
end
