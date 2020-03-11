module Api
  module V3x0
    class VolumeAttachmentsController < Api::V1::VolumeAttachmentsController
      include Mixins::IndexMixin
    end
  end
end
