module Api
  module V0
    class VolumeAttachmentsController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      private

      def list_params
        params.permit(:tenant_id, :vm_id, :volume_id)
      end

      def model
        VolumeAttachment
      end
    end
  end
end
