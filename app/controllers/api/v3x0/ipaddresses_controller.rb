module Api
  module V3x0
    class IpaddressesController < Api::V1::IpaddressesController
      include Mixins::IndexMixin
    end
  end
end
