class SampleModel < ActiveRecord::Base
  serialize :serialized, Hash
end