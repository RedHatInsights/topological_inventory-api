module Api
  module V3x0
    class IpaddressesController < Api::V2x0::IpaddressesController
      include Mixins::IndexMixin
    end
  end
end
