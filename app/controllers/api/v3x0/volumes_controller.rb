module Api
  module V3x0
    class VolumesController < Api::V2x0::VolumesController
      include Mixins::IndexMixin
    end
  end
end
