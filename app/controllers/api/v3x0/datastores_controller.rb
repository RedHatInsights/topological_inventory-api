module Api
  module V3x0
    class DatastoresController < Api::V1::DatastoresController
      include Mixins::IndexMixin
    end
  end
end
