module Api
  module V3x0
    class NetworksController < Api::V2x0::NetworksController
      include Mixins::IndexMixin
    end
  end
end
