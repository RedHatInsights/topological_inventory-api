module Api
  module V3x0
    class DatastoresController < Api::V2x0::DatastoresController
      include Mixins::IndexMixin
    end
  end
end
