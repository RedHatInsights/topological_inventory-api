module Api
  module V3x0
    class VolumeTypesController < Api::V1::VolumeTypesController
      include Mixins::IndexMixin
    end
  end
end
