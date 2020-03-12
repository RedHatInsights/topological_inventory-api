module Api
  module V3x0
    class VolumeAttachmentsController < Api::V2x0::VolumeAttachmentsController
      include Mixins::IndexMixin
    end
  end
end
