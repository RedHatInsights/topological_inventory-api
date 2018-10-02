class InitialMigration < ActiveRecord::Migration[5.1]
  def change
    create_table :sources, :id => :bigserial do |t|
      t.string :name
      t.string :external_uid

      t.timestamps
    end
  end
end
