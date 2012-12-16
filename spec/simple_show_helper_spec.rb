require 'spec_helper'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
SampleMigration.run

describe ApplicationHelper do
  include ApplicationHelper

  it 'basic' do
    instance = SampleModel.new
    instance.name = 'Name'
    instance.serialized = { a: 1, b: 2, c: { d: 5, e: 10 } }
    instance.save!
    string = simple_show_helper(instance)

    puts string

  end
end

