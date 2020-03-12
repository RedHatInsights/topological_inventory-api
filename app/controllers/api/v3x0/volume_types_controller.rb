module Api
  module V3x0
    class VolumeTypesController < Api::V2x0::VolumeTypesController
      include Mixins::IndexMixin
    end
  end
end
