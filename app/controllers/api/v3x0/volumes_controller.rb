module Api
  module V3x0
    class VolumesController < Api::V1::VolumesController
      include Mixins::IndexMixin
    end
  end
end
