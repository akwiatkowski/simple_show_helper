require 'active_record'

class SampleMigration < ActiveRecord::Migration
  def self.run
    create_table :sample_models do |t|
      t.string :name
      t.string :serialized
      t.timestamps
    end
  end
end