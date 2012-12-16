require 'spec_helper'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
SampleMigration.run

describe ApplicationHelper do
  include ApplicationHelper

  it 'basic' do
    instance = SampleModel.new
    instance.save!
    string = simple_show_helper(instance)

    puts string

  end
end

